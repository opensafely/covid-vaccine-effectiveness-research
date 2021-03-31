
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits a cox model for vaccination
# saves model summaries (tables and figures)
# "tte" = "time-to-event"

# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('survival')
library('splines')
library('parglm')
library('gtsummary')
library('gt')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)

cohort <- args[[1]]
strata_var <- args[[2]]
if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  strata_var <- "all"
}

outcome <- "vaccination"

# Import metadata for cohort ----

metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
metadata <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort, ]


stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))

## define model hyper-parameters and characteristics ----

### model names ----

list2env(metadata, globalenv())

### define parglm optimisation parameters ----

parglmparams <- parglm.control(
  method = "LINPACK",
  nthreads = 8
)

### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "data", "list_formula.rds"))
list2env(list_formula, globalenv())


### knot points for calendar time splines ----

#knots <- c(21)


formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))

# Import processed data ----

data_fixed <- read_rds(here::here("output", cohort, "data", glue::glue("data_wide_fixed.rds")))
data_tte <- read_rds(here::here("output", cohort, "data", glue::glue("data_wide_tte.rds")))


# redo tte variables to indclude censoring date (ie use na.censor=FALSE)
data_tte <- data_tte %>%
  mutate(
    lastfupany_date = lastfup_date,
    lastfuppfizer_date = pmin(lastfup_date, covid_vax_az_1_date, na.rm=TRUE), #censor az time if pfizer analysis
    lastfupaz_date = pmin(lastfup_date, covid_vax_pfizer_1_date, na.rm=TRUE), #censor pfizer time if az analysis
  ) %>%
  mutate(
    # time to last follow up day
    tte_lastfup = tte(start_date, lastfup_date, lastfup_date),

    tte_vaxany1 = tte(start_date, covid_vax_1_date, lastfup_date, na.censor=FALSE),
    ind_vaxany1 = censor_indicator(covid_vax_1_date, lastfup_date),

    all = factor("all",levels=c("all")),
  )

data_cox <- data_fixed %>%
  left_join(data_tte, by="patient_id") %>%
  mutate(
    tte_outcome = .[[glue::glue("tte_",outcome)]],
    ind_outcome = .[[glue::glue("ind_",outcome)]],
  ) %>%
  mutate( # this step converts logical to integer so that model coefficients print nicely in gtsummary methods
    across(
      where(is.logical),
      ~.x*1L
    )
  )


### print dataset size ----
cat(glue::glue("data_cox data size = ", nrow(data_cox)), "\n  ")
cat(glue::glue("memory usage = ", format(object.size(data_cox), units="GB", standard="SI", digits=3L)), "\n  ")

##  Create big loop over all categories

strata <- unique(data_cox[[strata_var]])

dir.create(here::here("output", cohort, outcome, strata_var), showWarnings = FALSE, recursive=TRUE)

write_rds(strata, here::here("output", cohort, outcome, strata_var, "strata_vector_cox.rds"))

for(stratum in strata){

  cat("  \n")
  cat(stratum, "  \n")
  cat("  \n")

  # create output directories ----
  dir.create(here::here("output", cohort, outcome, strata_var, stratum), showWarnings = FALSE, recursive=TRUE)


  # subset data
  data_cox_sub <- data_cox %>% filter(.[[strata_var]] == stratum)

  write_rds(data_cox_sub, here::here("output", cohort, outcome, strata_var, stratum, "data_cox_sub.rds"), compress="gz")

  formula_unadjusted <- Surv(tte_vaxany1, ind_vaxany1) ~ 1

  ### model 0 - unadjusted vaccination effect model ----
  ## no adjustment variables
  cat("  \n")
  cat("coxmod0 \n")
  coxmod0 <- coxph(
    formula = formula_unadjusted,
    data = data_cox_sub
  )

  cat(glue::glue("coxmod0 data size = ", coxmod0$n), "\n")
  cat(glue::glue("memory usage = ", format(object.size(coxmod0), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(coxmod0, here::here("output", cohort, outcome, strata_var, stratum, "vaxmodelcox0.rds"), compress="gz")
  #rm(coxmod0)

  ### model 1 - minimally adjusted vaccination effect model, baseline demographics only ----
  cat("  \n")
  cat("coxmod1 \n")

  coxmod1 <- coxph(
    formula = formula_unadjusted %>% update(formula_demog) %>% update(formula_remove_strata_var),
    data = data_cox_sub
  )

  cat(glue::glue("coxmod1 data size = ", coxmod1$n), "\n")
  cat(glue::glue("memory usage = ", format(object.size(coxmod1), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(coxmod1, here::here("output", cohort, outcome, strata_var, stratum,"vaxmodelcox1.rds"), compress="gz")
  #rm(coxmod1)



  ### model 2 - baseline, demographics, comorbs adjusted vaccination effect model ----
  cat("  \n")
  cat("coxmod2 \n")

  coxmod2 <- coxph(
    formula = formula_unadjusted %>% update(formula_demog) %>% update(formula_comorbs) %>% update(formula_remove_strata_var),
    data = data_cox_sub
  )

  cat(glue::glue("coxmod2 data size = ", coxmod2$n), "\n")
  cat(glue::glue("memory usage = ", format(object.size(coxmod2), units="GB", standard="SI", digits=3L)), "\n")

  write_rds(coxmod2, here::here("output", cohort, outcome, strata_var, stratum, "vaxmodelcox2.rds"), compress="gz")
  #rm(coxmod2)



  ## print warnings
  print(warnings())
  cat("  \n")
  print(gc(reset=TRUE))
}


