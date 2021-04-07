
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits some marginal structural models for vaccine effectiveness, with different adjustment sets
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by four arguments,
# 1. the name of the cohort defined in data_define_cohorts.R
# 2. the name of the outcome defined in data_define_cohorts.R
# 3. the name of the brand (currently "az" or "pfizer")
# 4. the stratification variable. Use "all" if no stratification
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
removeobs <- TRUE

if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"
  outcome <- "postest"
  brand <- "any"
  strata_var <- "all"
}



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

data_pt <- read_rds(here::here("output", cohort, "data", glue::glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
  filter(
    .[[glue::glue("{outcome}_status")]] == 0, # follow up ends at (day after) occurrence of outcome, ie where status not >0
    lastfup_status == 0, # follow up ends at (day after) occurrence of censoring event (derived from lastfup = min(end_date, death, dereg))
    death_status == 0, # follow up ends at (day after) occurrence of death
    dereg_status == 0, # follow up ends at (day after) practce deregistration
    vaxany_status == .[[glue::glue("vax{brand}_status")]], # follow up ends at (day after) occurrence of competing vaccination, ie where vax{competingbrand}_status not >0
  ) %>%
  mutate(
    all = factor("all",levels=c("all")),
    timesincevax_pw = timesince_cut(timesincevaxany1, postvaxcuts, "pre-vax"),
    outcome = .[[outcome]],
  ) %>%
  left_join(
    data_fixed, by="patient_id"
  ) %>%
  mutate( # this step converts logical to integer so that model coefficients print nicely in gtsummary methods
    across(
      where(is.logical),
      ~.x*1L
    )
  )


### print dataset size ----
cat(glue::glue("data_pt data size = ", nrow(data_pt)), "\n  ")
cat(glue::glue("memory usage = ", format(object.size(data_pt), units="GB", standard="SI", digits=3L)), "\n  ")


##  Create big loop over all categories

strata <- read_rds(here::here("output", "data", "list_strata.rds"))[[strata_var]]

for(stratum in strata){

  cat("  \n")
  cat(stratum, "  \n")
  cat("  \n")

  # create output directories ----
  dir.create(here::here("output", cohort, outcome, brand, strata_var, stratum), showWarnings = FALSE, recursive=TRUE)


  # subset data
  data_pt_sub <- data_pt %>% filter(.[[strata_var]] == stratum)

  if(brand=="any"){

    # IPW model for any vaccination ----

    data_pt_atriskvaxany1 <- data_pt_sub %>% filter(vaxany_status==0)

    ### with time-updating covariates
    cat("  \n")
    cat("ipwvaxany1 \n")
    ipwvaxany1 <- parglm(
      formula = update(vaxany1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_strata_var) ,
      data = data_pt_atriskvaxany1,
      family=binomial,
      control = parglmparams,
      na.action = "na.fail",
      model = FALSE
    )


    print(jtools::summ(ipwvaxany1, digits =3))
    cat(glue::glue("ipwvaxany1 data size = ", length(ipwvaxany1$y)), "\n")
    cat(glue::glue("memory usage = ", format(object.size(ipwvaxany1), units="GB", standard="SI", digits=3L)), "\n")



    ### without time-updating covariates ----

    cat("  \n")
    cat("ipwvaxpany1_fxd \n")
    ipwvaxany1_fxd <- parglm(
      formula = update(vaxany1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
      data = data_pt_atriskvaxany1,
      family=binomial,
      control = parglmparams,
      na.action = "na.fail",
      model = FALSE
    )

    print(jtools::summ(ipwvaxany1_fxd, digits =3))
    cat(glue::glue("ipwvaxany1_fxd data size = ", length(ipwvaxany1_fxd$y)), "\n")
    cat(glue::glue("memory usage = ", format(object.size(ipwvaxany1_fxd), units="GB", standard="SI", digits=3L)), "\n")


    ## get predictions from model ----

    data_predvaxany1 <- data_pt_atriskvaxany1 %>%
      transmute(
        patient_id,
        tstart, tstop,

        # get predicted probabilities from ipw models
        predvaxany1=predict(ipwvaxany1, type="response"),
        predvaxany1_fxd=predict(ipwvaxany1_fxd, type="response"),
      )

    write_rds(data_pt_atriskvaxany1, here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwvaxany1.rds"), compress="gz")
    write_rds(ipwvaxany1, here::here("output", cohort, outcome, brand, strata_var, stratum, "model_ipwvaxany1.rds"), compress="gz")
    if(removeobs) rm(ipwvaxany1, ipwvaxany1_fxd, data_pt_atriskvaxany1)



  }

  if(brand!="any"){

    # IPW model for pfizer vaccination ----

    data_pt_atriskvaxpfizer1 <- data_pt_sub %>% filter(vaxpfizer_status==0)

    ### with time-updating covariates
    cat("  \n")
    cat("ipwvaxpfizer1 \n")
    ipwvaxpfizer1 <- parglm(
      formula = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_strata_var),
      data = data_pt_atriskvaxpfizer1,
      family=binomial,
      control = parglmparams,
      na.action = "na.fail",
      model = FALSE
    )

    print(jtools::summ(ipwvaxpfizer1, digits =3))
    cat(glue::glue("ipwvaxpfizer1 data size = ", length(ipwvaxpfizer1$y)), "\n")
    cat(glue::glue("memory usage = ", format(object.size(ipwvaxpfizer1), units="GB", standard="SI", digits=3L)), "\n")



    ### without time-updating covariates ----
    cat("  \n")
    cat("ipwvaxpfizer1_fxd \n")
    ipwvaxpfizer1_fxd <- parglm(
      formula = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
      data = data_pt_atriskvaxpfizer1,
      family=binomial,
      control = parglmparams,
      na.action = "na.fail",
      model = FALSE
    )

    print(jtools::summ(ipwvaxpfizer1_fxd, digits =3))
    cat(glue::glue("ipwvaxpfizer1_fxd data size = ", length(ipwvaxpfizer1_fxd$y)), "\n")
    cat(glue::glue("memory usage = ", format(object.size(ipwvaxpfizer1_fxd), units="GB", standard="SI", digits=3L)), "\n")


    ## get predictions from model ----

    data_predvaxpfizer1 <- data_pt_atriskvaxpfizer1 %>%
      transmute(
        patient_id,
        tstart, tstop,

        # get predicted probabilities from ipw models
        predvaxpfizer1=predict(ipwvaxpfizer1, type="response"),
        predvaxpfizer1_fxd=predict(ipwvaxpfizer1_fxd, type="response"),
      )

    write_rds(data_pt_atriskvaxpfizer1, here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwvaxpfizer1.rds"), compress="gz")
    write_rds(ipwvaxpfizer1, here::here("output", cohort, outcome, brand, strata_var, stratum, "model_ipwvaxpfizer1.rds"), compress="gz")
    if(removeobs) rm(ipwvaxpfizer1, ipwvaxpfizer1_fxd, data_pt_atriskvaxpfizer1)


    # IPW model for az vaccination ----
    data_pt_atriskvaxaz1 <- data_pt_sub %>% filter(vaxaz_status==0, tstart>=28)

    ### with time-updating covariates
    cat("  \n")
    cat("ipwvaxaz1 \n")
    ipwvaxaz1 <- parglm(
      formula = update(vaxaz1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_strata_var),
      data = data_pt_atriskvaxaz1,
      family=binomial,
      control = parglmparams,
      na.action = "na.fail",
      model = FALSE
    )


    print(jtools::summ(ipwvaxaz1, digits =3))
    cat(glue::glue("ipwvaxaz1 data size = ", length(ipwvaxaz1$y)), "\n")
    cat(glue::glue("memory usage = ", format(object.size(ipwvaxaz1), units="GB", standard="SI", digits=3L)), "\n")


    ### without time-updating covariates ----
    cat("  \n")
    cat("ipwvaxaz1_fxd \n")
    ipwvaxaz1_fxd <- parglm(
      formula = update(vaxaz1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
      data = data_pt_atriskvaxaz1,
      family=binomial,
      control = parglmparams,
      na.action = "na.fail",
      model = FALSE
    )
    print(jtools::summ(ipwvaxaz1_fxd, digits =3))
    cat(glue::glue("ipwvaxaz1_fxd data size = ", length(ipwvaxaz1_fxd$y)), "\n")
    cat(glue::glue("memory usage = ", format(object.size(ipwvaxaz1_fxd), units="GB", standard="SI", digits=3L)), "\n")


    ## get predictions from model ----

    data_predvaxaz1 <- data_pt_atriskvaxaz1 %>%
      transmute(
        patient_id,
        tstart, tstop,

        # get predicted probabilities from ipw models
        predvaxaz1=predict(ipwvaxaz1, type="response"),
        predvaxaz1_fxd=predict(ipwvaxaz1_fxd, type="response"),
      )

    write_rds(data_pt_atriskvaxaz1, here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwvaxaz1.rds"), compress="gz")
    write_rds(ipwvaxaz1, here::here("output", cohort, outcome, brand, strata_var, stratum, "model_ipwvaxaz1.rds"), compress="gz")
    if(removeobs) rm(ipwvaxaz1, ipwvaxaz1_fxd, data_pt_atriskvaxaz1)

  }

  # IPW model for death ----

  data_pt_atriskdeath <- data_pt_sub %>% filter(death_status==0)

  ### with time-updating covariates
  cat("  \n")
  cat("ipwdeath \n")
  ipwdeath <- parglm(
    formula = update(death ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_strata_var),
    data = data_pt_atriskdeath,
    family=binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  print(jtools::summ(ipwdeath, digits =3))
  cat(glue::glue("ipwdeath data size = ", length(ipwdeath$y)), "\n")
  cat(glue::glue("memory usage = ", format(object.size(ipwdeath), units="GB", standard="SI", digits=3L)), "\n")


  ### without time-updating covariates ----
  cat("  \n")
  cat("ipwdeath_fxd \n")
  ipwdeath_fxd <- parglm(
    formula = update(death ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
    data = data_pt_atriskdeath,
    family=binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )
  print(jtools::summ(ipwdeath_fxd, digits =3))
  cat(glue::glue("ipwdeath_fxd data size = ", length(ipwdeath_fxd$y)), "\n")
  cat(glue::glue("memory usage = ", format(object.size(ipwdeath_fxd), units="GB", standard="SI", digits=3L)), "\n")


  data_preddeath <- data_pt_atriskdeath %>%
    transmute(
      patient_id,
      tstart, tstop,

      # get predicted probabilities from ipw models
      preddeath=predict(ipwdeath, type="response"),
      preddeath_fxd=predict(ipwdeath_fxd, type="response"),
    )

  write_rds(data_pt_atriskdeath, here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwdeath.rds"), compress="gz")
  write_rds(ipwdeath, here::here("output", cohort, outcome, brand, strata_var, stratum, "model_ipwdeath.rds"), compress="gz")
  if(removeobs) rm(ipwdeath, ipwdeath_fxd, data_pt_atriskdeath)


  ## get predictions from model ----

  if (brand=="any"){


    data_weights <- data_pt_sub %>%
      left_join(data_predvaxany1, by=c("patient_id", "tstart", "tstop")) %>%
      left_join(data_preddeath, by=c("patient_id", "tstart", "tstop")) %>%
      group_by(patient_id) %>%
      mutate(

        ## Any

        # get probability of occurrence of realised vaccination status
        probvaxany_realised = case_when(
          is.na(predvaxany1) ~ 1, # if already vaccinated or not at risk of vaccine, by definition prob of status is = 1
          vaxany_status==0L & vaxany1!=1 ~ 1 - predvaxany1,
          vaxany_status==0L & vaxany1==1 ~ predvaxany1,
          TRUE ~ NA_real_
        ),
        # cumulative product of status probabilities
        cmlprobvaxany_realised = cumprod(probvaxany_realised),
        # inverse probability weights
        ipweightvaxany = 1/cmlprobvaxany_realised,

        #same but for time-independent model

        # get probability of occurrence of realised vaccination status (non-time varying model)
        probvaxany_realised_fxd = case_when(
          is.na(predvaxany1_fxd) ~ 1,
          vaxany_status==0L & vaxany1!=1 ~ 1 - predvaxany1_fxd,
          vaxany_status==0L & vaxany1==1 ~ predvaxany1_fxd,
          TRUE ~ NA_real_
        ),
        # cumulative product of status probabilities
        cmlprobvaxany_realised_fxd = cumprod(probvaxany_realised_fxd),
        # inverse probability weights
        ipweightvaxany_fxd = 1/cmlprobvaxany_realised_fxd,

        # stabilised inverse probability weights
        ipweightvaxany_stbl = cmlprobvaxany_realised_fxd/cmlprobvaxany_realised,


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
        ipweight_stbl = (ipweightvaxany_stbl * ipweightdeath_stbl)
      )

    if(removeobs) rm(data_predvaxany1, data_preddeath)

  }



  if (brand!="any"){


    data_weights <- data_pt_sub %>%
      left_join(data_predvaxpfizer1, by=c("patient_id", "tstart", "tstop")) %>%
      left_join(data_predvaxaz1, by=c("patient_id", "tstart", "tstop")) %>%
      left_join(data_preddeath, by=c("patient_id", "tstart", "tstop")) %>%
      group_by(patient_id) %>%
      mutate(

        ## PFIZER

        # get probability of occurrence of realised vaccination status
        probvaxpfizer_realised = case_when(
          is.na(predvaxpfizer1) ~ 1, # if already vaccinated, by definition prob of vaccine is = 1
          vaxpfizer_status==0L & vaxpfizer1!=1 ~ 1 - predvaxpfizer1,
          vaxpfizer_status==0L & vaxpfizer1==1 ~ predvaxpfizer1,
          TRUE ~ NA_real_
        ),
        # cumulative product of status probabilities
        cmlprobvaxpfizer_realised = cumprod(probvaxpfizer_realised),
        # inverse probability weights
        ipweightvaxpfizer = 1/cmlprobvaxpfizer_realised,

        #same but for time-independent model

        # get probability of occurrence of realised vaccination status (non-time varying model)
        probvaxpfizer_realised_fxd = case_when(
          is.na(predvaxpfizer1_fxd) ~ 1,
          vaxpfizer_status==0L & vaxpfizer1!=1 ~ 1 - predvaxpfizer1_fxd,
          vaxpfizer_status==0L & vaxpfizer1==1 ~ predvaxpfizer1_fxd,
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
          is.na(predvaxaz1) ~ 1, # if already vaccinated or not at risk of vaccine, by definition prob of status is = 1
          vaxaz_status==0L & vaxaz1!=1 ~ 1 - predvaxaz1,
          vaxaz_status==0L & vaxaz1==1 ~ predvaxaz1,
          TRUE ~ NA_real_
        ),
        # cumulative product of status probabilities
        cmlprobvaxaz_realised = cumprod(probvaxaz_realised),
        # inverse probability weights
        ipweightvaxaz = 1/cmlprobvaxaz_realised,

        #same but for time-independent model

        # get probability of occurrence of realised vaccination status (non-time varying model)
        probvaxaz_realised_fxd = case_when(
          is.na(predvaxaz1_fxd) ~ 1,
          vaxaz_status==0L & vaxaz1!=1 ~ 1 - predvaxaz1_fxd,
          vaxaz_status==0L & vaxaz1==1 ~ predvaxaz1_fxd,
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

    if(removeobs) rm(data_predvaxpfizer1, data_predvaxaz1, data_preddeath)

  }
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
    scale_x_log10(breaks=c(1/8,1/6,1/4,1/3,1/2,1/1.5,1,1.5,2,3,4,6,8), limits=c(1/8, 8))+
    theme_bw()

  ggsave(here::here("output", cohort, outcome, brand, strata_var, stratum, "weights_histogram.svg"), weight_histogram)
  if(removeobs) rm(weight_histogram)

  ## output weight distribution file ----

  data_weights <- data_weights %>%
    select(
      "patient_id",
      "tstart", "tstop",
      any_of(all.vars(formula_all_rhsvars)),
      "ipweight_stbl",
      "outcome",
    )
  cat("  \n")
  cat(glue::glue("data_weights data size = ", nrow(data_weights)), "\n")
  cat(glue::glue("memory usage = ", format(object.size(data_weights), units="GB", standard="SI", digits=3L)), "\n")

  write_rds(data_weights, here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("data_weights.rds")), compress="gz")

  # MSM model ----

  # do not use time-dependent covariates as these are accounted for with the weights
  # use cluster standard errors
  # use quasibinomial to suppress "non-integer #successes in a binomial glm!" warning (not possible with parglm)
  # use interaction with time terms?

  ### model 0 - unadjusted vaccination effect model ----
  ## no adjustment variables
  cat("  \n")
  cat("msmmod0 \n")
  msmmod0_par <- parglm(
    formula = update(outcome ~ 1, formula_exposure) %>% update(formula_remove_strata_var),
    data = data_weights,
    family = binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )


  print(jtools::summ(msmmod0_par, digits =3))
  cat(glue::glue("msmmod0_par data size = ", length(msmmod0_par$y)), "\n")
  cat(glue::glue("memory usage = ", format(object.size(msmmod0_par), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(msmmod0_par, here::here("output", cohort, outcome, brand, strata_var, stratum, "model0.rds"), compress="gz")
  if(removeobs) rm(msmmod0_par)

  ### model 1 - minimally adjusted vaccination effect model, baseline demographics only ----
  cat("  \n")
  cat("msmmod1 \n")
  msmmod1_par <- parglm(
    formula = update(outcome ~ 1, formula_demog) %>% update(formula_exposure) %>% update(formula_remove_strata_var),
    data = data_weights,
    family = binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  print(jtools::summ(msmmod1_par, digits =3))

  cat(glue::glue("msmmod1_par data size = ", length(msmmod1_par$y)), "\n")
  cat(glue::glue("memory usage = ", format(object.size(msmmod1_par), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(msmmod1_par, here::here("output", cohort, outcome, brand, strata_var, stratum,"model1.rds"), compress="gz")
  if(removeobs) rm(msmmod1_par)


  ### model 2 - minimally adjusted vaccination effect model, baseline demographics only ----
  cat("  \n")
  cat("msmmod2 \n")
  msmmod2_par <- parglm(
    formula = update(outcome ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_remove_strata_var),
    data = data_weights,
    family = binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  print(jtools::summ(msmmod2_par, digits =3))

  cat(glue::glue("msmmod2_par data size = ", length(msmmod2_par$y)), "\n")
  cat(glue::glue("memory usage = ", format(object.size(msmmod2_par), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(msmmod2_par, here::here("output", cohort, outcome, brand, strata_var, stratum,"model2.rds"), compress="gz")
  if(removeobs) rm(msmmod2_par)



  ### model 3 - baseline, comorbs, secular trend adjusted vaccination effect model ----
  cat("  \n")
  cat("msmmod3 \n")
  msmmod3_par <- parglm(
    formula = update(outcome ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_exposure) %>% update(formula_remove_strata_var),
    data = data_weights,
    family = binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  print(jtools::summ(msmmod3_par, digits =3))

  cat(glue::glue("msmmod3_par data size = ", length(msmmod3_par$y)), "\n")
  cat(glue::glue("memory usage = ", format(object.size(msmmod3_par), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(msmmod3_par, here::here("output", cohort, outcome, brand, strata_var, stratum, "model3.rds"), compress="gz")
  if(removeobs) rm(msmmod3_par)


  ### model 4 - baseline, comorbs, secular trend adjusted vaccination effect model + IP-weighted + do not use time-dependent covariates ----
  cat("  \n")
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

  print(jtools::summ(msmmod4_par, digits =3))

  cat(glue::glue("msmmod4_par data size = ", length(msmmod4_par$y)), "\n")
  cat(glue::glue("memory usage = ", format(object.size(msmmod4_par), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(msmmod4_par, here::here("output", cohort, outcome, brand, strata_var, stratum, "model4.rds"), compress="gz")
  if(removeobs) rm(msmmod4_par)


  ## print warnings
  print(warnings())
  cat("  \n")
  print(gc(reset=TRUE))
}


