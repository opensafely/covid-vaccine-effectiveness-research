
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits some marginal structural models for vaccine effectiveness, with different adjustment sets
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by two arguments,
# 1. the name of the cohort defined in data_define_cohorts.R
# 2. the name of the outcome defined in data_define_cohorts.R
# 3. the name of the brand (currently "az" or "pfizer")
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
outcome <- args[[2]]
brand <- args[[3]]
strata_var <- args[[4]]

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  outcome <- "postest"
  brand <- "any"
  strata_var <- "sex"
}



# Import metadata for cohort ----

metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
metadata <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort & metadata_cohorts[["outcome"]]==outcome, ]


stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))

## define model hyper-parameters and characteristics ----

### model names ----

list2env(metadata, globalenv())

## or equivalently:
# cohort <- metadata_cohorts$cohort
# cohort_descr <- metadata_cohorts$cohort_descr
# outcome <- metadata_cohorts$outcome
# outcome_descr <- metadata_cohorts$outcome_descr

### define parglm optimisation parameters ----

parglmparams <- parglm.control(
  method = "LINPACK",
  nthreads = 8
)

### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "data", "list_formula.rds"))
list2env(list_formula, globalenv())

### post vax time periods ----

postvaxcuts <- c(0, 3, 7, 14, 21) # use if coded as days
#postvaxcuts <- c(0, 1, 2, 3) # use if coded as weeks

### knot points for calendar time splines ----

#knots <- c(21)


formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))

# Import processed data ----

data_fixed <- read_rds(here::here("output", cohort, "data", glue::glue("data_wide_fixed.rds")))

data_pt <- read_rds(here::here("output", cohort, "data", glue::glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
  filter(
    .[[glue::glue("{outcome}_status")]] == 0, # follow up ends at (day after) occurrence of outcome, ie where status not >0
    censored_status == 0, # follow up ends at (day after) occurrence of censoring event (derived from lastfup = min(end_date, death))
    death_status == 0, # follow up ends at (day after) occurrence of death
    vaxany_status == .[[glue::glue("vax{brand}_status")]], # follow up ends at (day after) occurrence of competing vaccination, ie where vax{competingbrand}_status not >0
  ) %>%
  mutate(
    all = factor("all",levels=c("all")),
    timesincevax_pw = timesince_cut(timesincevaxany1, postvaxcuts, "pre-vax"),
    outcome = .[[outcome]],
  ) %>%
  rename(
    vax_status = vaxany_status,
    vax1 = vaxany1,
    timesincevax1 = timesincevaxany1,
  ) %>%
  left_join(
    data_fixed, by="patient_id"
  )


### print dataset size ----
cat(glue::glue("data_pt data size = ", nrow(data_pt)), "\n  ")
cat(glue::glue("memory usage = ", format(object.size(data_pt), units="GB", standard="SI", digits=3L)), "\n  ")


##  Create big loop over all categories

strata <- unique(data_pt[[strata_var]])

dir.create(here::here("output", cohort, outcome, brand, strata_var), showWarnings = FALSE, recursive=TRUE)

write_rds(strata, here::here("output", cohort, outcome, brand, strata_var, "strata_vector.rds"))


for(stratum in strata){

  # create output directories ----
  dir.create(here::here("output", cohort, outcome, brand, strata_var, stratum), showWarnings = FALSE, recursive=TRUE)

  # save strata as vector




  # subset data
  data_pt_sub <- data_pt %>% filter(.[[strata_var]] == stratum)

  # IPW model for pfizer vaccination ----

  ## models for first vaccination ----

  data_pt_atriskvaxpfizer1 <- data_pt_sub %>% filter(vaxpfizer_status==0)

  ### with time-updating covariates

  cat("ipwvaxpfizer1 \n")
  ipwvaxpfizer1_par <- parglm(
    formula = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_strata_var),
    data = data_pt_atriskvaxpfizer1,
    family=binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  # ipwvaxpfizer1 <- glm(
  #   formula = ipwvaxpfizer1_par$formula,
  #   data = data_pt_atriskvaxpfizer1,
  #   family=binomial,
  #   control = list(maxit = 1),
  #   na.action = "na.fail",
  #   model = FALSE,
  #   start = coefficients(ipwvaxpfizer1_par)
  # )
  ipwvaxpfizer1<-ipwvaxpfizer1_par
  jtools::summ(ipwvaxpfizer1)


  ### without time-updating covariates ----
  # exclude time-updating covariates _except_ variables derived from calendar time itself (eg ns(calendar_time,3))
  # used for stabilised ip weights


  cat("ipwvaxpfizer1_fxd \n")
  ipwvaxpfizer1_fxd <- parglm(
    formula = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
    data = data_pt_atriskvaxpfizer1,
    family=binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )
  jtools::summ(ipwvaxpfizer1_fxd)

  ## get predictions from model ----

  data_predvaxpfizer1 <- data_pt_atriskvaxpfizer1 %>%
    transmute(
      patient_id,
      tstart, tstop,

      # get predicted probabilities from ipw models
      predvaxpfizer1=predict(ipwvaxpfizer1, type="response"),
      predvaxpfizer1_fxd=predict(ipwvaxpfizer1_fxd, type="response"),
    )


  # IPW model for az vaccination ----

  ## models for first vaccination ----

  data_pt_atriskvaxaz1 <- data_pt_sub %>% filter(vaxaz_status==0, tstart>=28)

  ### with time-updating covariates

  cat("ipwvaxaz1 \n")
  ipwvaxaz1_par <- parglm(
    formula = update(vaxaz1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_strata_var),
    data = data_pt_atriskvaxaz1,
    family=binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  # ipwvaxaz1 <- glm(
  #   formula = ipwvaxaz1_par$formula,
  #   data = data_pt_atriskvaxaz1,
  #   family=binomial,
  #   control = list(maxit = 1),
  #   na.action = "na.fail",
  #   model = FALSE,
  #   start = coefficients(ipwvaxaz1_par)
  # )
  ipwvaxaz1<-ipwvaxaz1_par
  jtools::summ(ipwvaxaz1)


  ### without time-updating covariates ----
  # exclude time-updating covariates _except_ variables derived from calendar time itself (eg ns(calendar_time,3))
  # used for stabilised ip weights


  cat("ipwvaxaz1_fxd \n")
  ipwvaxaz1_fxd <- parglm(
    formula = update(vaxaz1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
    data = data_pt_atriskvaxaz1,
    family=binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )
  jtools::summ(ipwvaxaz1_fxd)

  ## get predictions from model ----

  data_predvaxaz1 <- data_pt_atriskvaxaz1 %>%
    transmute(
      patient_id,
      tstart, tstop,

      # get predicted probabilities from ipw models
      predvaxaz1=predict(ipwvaxaz1, type="response"),
      predvaxaz1_fxd=predict(ipwvaxaz1_fxd, type="response"),
    )


  # IPW model for death ----

  ## models death ----

  data_pt_atriskdeath <- data_pt_sub %>% filter(death_status==0)

  ### with time-updating covariates

  cat("ipwdeath \n")
  ipwdeath <- parglm(
    formula = update(death ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_strata_var),
    data = data_pt_atriskdeath,
    family=binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )
  jtools::summ(ipwdeath)

  ### without time-updating covariates ----

  cat("ipwdeath_fxd \n")
  ipwdeath_fxd <- parglm(
    formula = update(death ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
    data = data_pt_atriskdeath,
    family=binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )
  jtools::summ(ipwdeath_fxd)







  ## get predictions from model ----

  data_predvaxpfizer1 <- data_pt_atriskvaxpfizer1 %>%
    transmute(
      patient_id,
      tstart, tstop,

      # get predicted probabilities from ipw models
      predvaxpfizer1=predict(ipwvaxpfizer1, type="response"),
      predvaxpfizer1_fxd=predict(ipwvaxpfizer1_fxd, type="response"),
    )

  data_predvaxaz1 <- data_pt_atriskvaxaz1 %>%
    transmute(
      patient_id,
      tstart, tstop,

      # get predicted probabilities from ipw models
      predvaxaz1=predict(ipwvaxaz1, type="response"),
      predvaxaz1_fxd=predict(ipwvaxaz1_fxd, type="response"),
    )

  data_preddeath <- data_pt_atriskdeath %>%
    transmute(
      patient_id,
      tstart, tstop,

      # get predicted probabilities from ipw models
      preddeath=predict(ipwdeath, type="response"),
      preddeath_fxd=predict(ipwdeath_fxd, type="response"),
    )

  data_weights <- data_pt_sub %>%
    left_join(data_predvaxpfizer1, by=c("patient_id", "tstart", "tstop")) %>%
    left_join(data_predvaxaz1, by=c("patient_id", "tstart", "tstop")) %>%
    left_join(data_preddeath, by=c("patient_id", "tstart", "tstop")) %>%
    group_by(patient_id) %>%
    mutate(

      ## PFIZER

      # get probability of occurrence of realised vaccination status
      probvaxpfizer_realised = case_when(
        vaxpfizer_status==0L & vaxpfizer1!=1 ~ 1 - predvaxpfizer1,
        vaxpfizer_status==0L & vaxpfizer1==1 ~ predvaxpfizer1,
        vaxpfizer_status>0L ~ 1, # if already vaccinated, by definition prob of vaccine is = 1
        TRUE ~ NA_real_
      ),
      # cumulative product of status probabilities
      cmlprobvaxpfizer_realised = cumprod(probvaxpfizer_realised),
      # inverse probability weights
      ipweightvaxpfizer = 1/cmlprobvaxpfizer_realised,

      #same but for time-independent model

      # get probability of occurrence of realised vaccination status (non-time varying model)
      probvaxpfizer_realised_fxd = case_when(
        vaxpfizer_status==0L & vaxpfizer1!=1 ~ 1 - predvaxpfizer1_fxd,
        vaxpfizer_status==0L & vaxpfizer1==1 ~ predvaxpfizer1_fxd,
        vaxpfizer_status>0L ~ 1,
        TRUE ~ NA_real_
      ),
      # cumulative product of status probabilities
      cmlprobvaxpfizer_realised_fxd = cumprod(probvaxpfizer_realised_fxd),
      # inverse probability weights
      ipweightvaxpfizer_fxd = 1/cmlprobvaxpfizer_realised_fxd,

      # stabilised inverse probability weights
      ipweightvaxpfizer_stbl = cmlprobvaxpfizer_realised_fxd/cmlprobvaxpfizer_realised,


      ## AZ

      # get probability of occurrence of realised vaccination status
      probvaxaz_realised = case_when(
        vaxaz_status==0L & tstart<28 ~ 1, # i.e., when nobody had AZ vaccine
        vaxaz_status==0L & vaxaz1!=1 ~ 1 - predvaxaz1,
        vaxaz_status==0L & vaxaz1==1 ~ predvaxaz1,
        vaxaz_status>0L ~ 1, # if already vaccinated, by definition prob of vaccine is = 1
        TRUE ~ NA_real_
      ),
      # cumulative product of status probabilities
      cmlprobvaxaz_realised = cumprod(probvaxaz_realised),
      # inverse probability weights
      ipweightvaxaz = 1/cmlprobvaxaz_realised,

      #same but for time-independent model

      # get probability of occurrence of realised vaccination status (non-time varying model)
      probvaxaz_realised_fxd = case_when(
        vaxaz_status==0L & tstart<28 ~ 1, # i.e., when nobody had AZ vaccine
        vaxaz_status==0L & vaxaz1!=1 ~ 1 - predvaxaz1_fxd,
        vaxaz_status==0L & vaxaz1==1 ~ predvaxaz1_fxd,
        vaxaz_status>0L ~ 1,
        TRUE ~ NA_real_
      ),
      # cumulative product of status probabilities
      cmlprobvaxaz_realised_fxd = cumprod(probvaxaz_realised_fxd),
      # inverse probability weights
      ipweightvaxaz_fxd = 1/cmlprobvaxaz_realised_fxd,

      # stabilised inverse probability weights
      ipweightvaxaz_stbl = cmlprobvaxaz_realised_fxd/cmlprobvaxaz_realised,


      ##DEATH

      # death censoring
      probdeath_realised = case_when(
        death_status==0L & death!=1 ~ 1 - preddeath,
        death_status==0L & death==1 ~ preddeath,
        death_status==1L ~ 1,
        TRUE ~ NA_real_
      ),
      # cumulative product of status probabilities
      cmlprobdeath_realised = cumprod(probdeath_realised),
      # inverse probability weights
      ipweightdeath = 1/cmlprobdeath_realised,

      # deathcensoring (fixed)
      probdeath_realised_fxd = case_when(
        death_status==0L & death!=1 ~ 1 - preddeath_fxd,
        death_status==0L & death==1 ~ preddeath_fxd,
        death_status==1L ~ 1,
        TRUE ~ NA_real_
      ),
      # cumulative product of status probabilities
      cmlprobdeath_realised_fxd = cumprod(probdeath_realised_fxd),
      # inverse probability weights
      ipweightdeath_fxd = 1/cmlprobdeath_realised_fxd,


      # stabilised inverse probability weights
      ipweightdeath_stbl = cmlprobdeath_realised_fxd/cmlprobdeath_realised,

    ) %>%
    ungroup()%>%
    mutate(
      ## COMBINE WEIGHTS
      # take product of all weights
      ipweight_stbl = (ipweightvaxpfizer_stbl * ipweightvaxaz_stbl * ipweightdeath_stbl)
    )


  # if(brand=="any"){
  #   data_weights <- data_weights %>%
  #     mutate(
  #       ## COMBINE WEIGHTS
  #       # take product of all weights
  #       ipweight_stbl = (ipweightvaxpfizer_stbl * ipweightvaxaz_stbl * ipweightdeath_stbl)
  #     )
  # } else{
  #   data_weights <- data_weights %>%
  #     mutate(
  #       ## COMBINE WEIGHTS
  #       # take product of all weights then undo product of actual outcome used
  #       ipweight_stbl = (ipweightvaxpfizer_stbl * ipweightvaxaz_stbl * ipweightdeath_stbl) / .[[glue::glue("ipweightvax{brand}_stbl")]]
  #   )


  ## report weights ----

  summarise_weights <-
    data_weights %>%
    select(starts_with("ipweight")) %>%
    map(redacted_summary_num) %>%
    enframe()

  capture.output(
    walk2(summarise_weights$value, summarise_weights$name, print_num),
    file = here::here("output", cohort, outcome, brand, strata_var, stratum, "weights_table.txt"),
    append=FALSE
  )

  ## save weights
  weight_histogram <- ggplot(data_weights) +
    geom_histogram(aes(x=ipweight_stbl)) +
    scale_x_log10(breaks=c(1/8,1/6,1/4,1/3,1/2,1/1.5,1,1.5,2,3,4,6,8))+
    theme_bw()

  ggsave(here::here("output", cohort, outcome, brand, strata_var, stratum, "weights_histogram.svg"), weight_histogram)


  ## print models
  ipwvaxpfizer1 %>%
    tbl_regression(
      pvalue_fun = ~style_pvalue(.x, digits=3),
      tidy_fun = tidy_parglm
    ) %>%
    as_gt() %>%
    gtsave(here::here("output", cohort, outcome, brand, strata_var, stratum, "weights_model_pfizer.html"))

  ipwvaxaz1 %>%
    tbl_regression(
      pvalue_fun = ~style_pvalue(.x, digits=3),
      tidy_fun = tidy_parglm
    ) %>%
    as_gt() %>%
    gtsave(here::here("output", cohort, outcome, brand, strata_var, stratum, "weights_model_az.html"))

  ## output weight distribution file ----

  data_weights <- data_weights %>%
    select(
      "patient_id",
      "tstart", "tstop",
      any_of(all.vars(formula_all_rhsvars)),
      "ipweight_stbl",
      "outcome",
    )

  cat(glue::glue("data_weights data size = ", nrow(data_weights)), "\n  ")
  cat(glue::glue("memory usage = ", format(object.size(data_weights), units="GB", standard="SI", digits=3L)), "\n  ")

  write_rds(data_weights, here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("data_weights.rds")), compress="gz")

  # MSM model ----

  # do not use time-dependent covariates as these are accounted for with the weights
  # use cluster standard errors
  # use quasibinomial to suppress "non-integer #successes in a binomial glm!" warning
  # use interaction with time terms?

  ### model 0 - unadjusted vaccination effect model ----
  ## no adjustment variables

  cat("msmmod0 \n")
  msmmod0_par <- parglm(
    formula = update(outcome ~ 1, formula_exposure) %>% update(formula_remove_strata_var),
    data = data_weights,
    family = binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )


  # msmmod0 <- glm(
  #   formula = msmmod0_par$formula,
  #   data = data_weights,
  #   weights = ipweight_stbl,
  #   family = binomial,
  #   control = list(maxit = 1),
  #   na.action = "na.fail",
  #   model = FALSE,
  #   start = coefficients(msmmod0_par)
  # )
  msmmod0<- msmmod0_par
  jtools::summ(msmmod0)


  ### model 1 - minimally adjusted vaccination effect model, baseline demographics only ----
  cat("msmmod1 \n")
  msmmod1_par <- parglm(
    formula = update(outcome ~ 1, formula_demog) %>% update(formula_exposure) %>% update(formula_remove_strata_var),
    data = data_weights,
    family = binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )


  # msmmod1 <- glm(
  #   formula = msmmod1_par$formula,
  #   data = data_weights,
  #   weights = ipweight_stbl,
  #   family = binomial,
  #   control = list(maxit = 1),
  #   na.action = "na.fail",
  #   model = FALSE,
  #   start = coefficients(msmmod1_par)
  # )
  msmmod1<-msmmod1_par
  jtools::summ(msmmod1)


  ### model 4 - baseline, comorbs, secular trend adjusted vaccination effect model + IP-weighted ----
  cat("msmmod4 \n")
  msmmod4_par <- parglm(
    formula = update(outcome ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_exposure) %>% update(formula_remove_strata_var),
    data = data_weights,
    weights = ipweight_stbl,
    family = binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )


  # msmmod4 <- glm(
  #   formula = msmmod4_par$formula,
  #   data = data_weights,
  #   weights = ipweight_stbl,
  #   family = binomial,
  #   control = list(maxit = 1),
  #   na.action = "na.fail",
  #   model = FALSE,
  #   start = coefficients(msmmod4_par)
  # )
  msmmod4<-msmmod4_par
  jtools::summ(msmmod4)


  ## Save models as rds ----

  write_rds(ipwvaxpfizer1, here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("ipwvaxpfizer1.rds")), compress="gz")
  write_rds(ipwvaxaz1, here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("ipwvaxaz1.rds")), compress="gz")
  write_rds(msmmod0, here::here("output", cohort, outcome, brand, strata_var, stratum, "model0.rds"), compress="gz")
  write_rds(msmmod1, here::here("output", cohort, outcome, brand, strata_var, stratum,"model1.rds"), compress="gz")
  write_rds(msmmod4, here::here("output", cohort, outcome, brand, strata_var, stratum, "model4.rds"), compress="gz")

}

