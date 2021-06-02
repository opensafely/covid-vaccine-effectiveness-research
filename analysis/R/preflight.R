
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# checks that there are no separation issues between covariates and outcomes
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by 2 arguments,
# 1. the name of the cohort defined in data_define_cohorts.R
# 2. the stratification variable. Use "all" if no stratification
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('glue')
library('gt')
library('gtsummary')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"
  strata_var <- "all"
} else {
  cohort <- args[[1]]
  strata_var <- args[[2]]
  removeobs <- TRUE

}


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())

## if outcome is positive test, remove time-varying positive test info from covariate set


formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ", strata_var))

# Import processed data ----

data_fixed <- read_rds(here::here("output", cohort, "data", glue("data_fixed.rds")))

data_pt <- read_rds(here::here("output", cohort, "data", glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
  filter(
    #.[[glue("{outcome}_status")]] == 0, # follow up ends at (day after) occurrence of outcome, ie where status not >0
    lastfup_status == 0, # follow up ends at (day after) occurrence of censoring event (derived from lastfup = min(end_date, death, dereg))
    #vaxany1_status == .[[glue("vax{brand}1_status")]], # if brand-specific, follow up ends at (day after) occurrence of competing vaccination, ie where vax{competingbrand}_status not >0
    #.[[glue("sample_{outcome}")]] # select all patients who experienced the outcome, and a proportion of those who don't
  ) %>%
  mutate(
    all = factor("all",levels=c("all")),
    timesincevax_pw = timesince_cut(timesincevaxany1, postvaxcuts, "pre-vax"),
    #sample_weights = .[[glue("sample_weights_{outcome}")]],
    #outcome = .[[outcome]],
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


outcomes <- c("postest", "covidadmitted", "death")
brands <- c("any", "pfizer", "az")


for(outcome in outcomes){
  for(brand in brands){


    dir.create(here::here("output", cohort, "descriptive", "model-checks"), showWarnings = FALSE, recursive=TRUE)

    if(outcome=="postest"){
      formula_remove_postest <- as.formula(". ~ . - timesince_postesttdc_pw")
    } else{
      formula_remove_postest <- as.formula(". ~ .")
    }

    formula_1 <- outcome ~ 1
    formula_remove_strata_var <- as.formula(paste0(". ~ . - ", strata_var))


    treatment_any <- update(vaxany1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var)
    treatment_pfizer <- update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var)
    treatment_az <- update(vaxaz1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var)

    treatment_coviddeath <- update(coviddeath ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var)
    treatment_noncoviddeath <- update(noncoviddeath ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var)
    treatment_death <-  update(death ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var)

    outcome_formula <- formula_1 %>% update(formula_exposure) %>% update(formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var)

    data_pt_sub <- data_pt %>%
      filter(
        .[[glue("{outcome}_status")]] == 0, # follow up ends at (day after) occurrence of outcome, ie where status not >0
        lastfup_status == 0, # follow up ends at (day after) occurrence of censoring event (derived from lastfup = min(end_date, death, dereg))
        vaxany1_status == .[[glue("vax{brand}1_status")]], # if brand-specific, follow up ends at (day after) occurrence of competing vaccination, ie where vax{competingbrand}_status not >0
        .[[glue("sample_{outcome}")]] > 0 # select all patients who experienced the outcome, and a proportion of those who don't
      ) %>%
      mutate(
        sample_weights = .[[glue("sample_weights_{outcome}")]],
        outcome = .[[outcome]],
        timesincevax_pw = timesince_cut(timesincevaxany1, postvaxcuts, "pre-vax"),

        vaxany1_atrisk = (vaxany1_status==0 & lastfup_status==0),
        vaxpfizer1_atrisk = (vaxany1_status==0 & lastfup_status==0 & vaxpfizer_atrisk==1),
        vaxaz1_atrisk = (vaxany1_status==0 & lastfup_status==0 & vaxaz_atrisk==1),
        death_atrisk = (death_status==0 & lastfup_status==0),
      )

    data_pt_sub_treatment <- data_pt_sub %>%
      filter(.[[glue("vax{brand}1_atrisk")]])


    data_pt_sub_treatment %>%
      summarise(
        obs = n(),
        patients = n_distinct(patient_id),
        vaxany1 = sum(vaxany1),
        vaxapfizer1 = sum(vaxpfizer1),
        vaxaz1 = sum(vaxaz1),
        rate_vaxany1 = vaxany1/patients,
        rate_vaxpfizer1 = vaxpfizer1/patients,
        rate_vaxaz1 = vaxaz1/patients,
        incidencerate_vaxeany1 = vaxany1/obs,
        incidencerate_vaxpfizer1 = vaxapfizer1/obs,
        incidencerate_vaxaz1 = vaxaz1/obs
      ) %>%
      write_csv(path=here::here("output", cohort, "descriptive", "model-checks", "summary_{outcome}_{brand}_treatments.csv"))

    data_pt_sub %>%
      summarise(
        obs = n(),
        patients = n_distinct(patient_id),

        coviddeath = sum(coviddeath),
        noncoviddeath = sum(noncoviddeath),
        death = sum(death),
        dereg = sum(dereg),
        outcome = sum(outcome),

        rate_coviddeath = coviddeath/patients,
        rate_noncoviddeath = noncoviddeath/patients,
        rate_death = death/patients,
        rate_dereg = dereg/patients,

        incidencerate_coviddeath = coviddeath/obs,
        incidencerate_noncoviddeath = noncoviddeath/obs,
        incidencerate_death = death/obs,
        incidencerate_dereg = dereg/obs,

      ) %>%
      write_csv(path=here::here("output", cohort, "descriptive", "model-checks", glue("summary_{outcome}_{brand}_outcomes.csv")))


    data_pt_sub_treatment %>%
      select(all.vars(treatment_any)) %>%
      tbl_summary(
        by=as.character(treatment_any[2]),
        missing = "ifany"
      ) %>%
      as_gt() %>%
      gtsave(
        filename = glue("sepcheck_{outcome}_{brand}_vaxany1.html"),
        path=here::here("output", cohort, "descriptive", "model-checks")
      )

    data_pt_sub_treatment %>%
      select(all.vars(treatment_pfizer)) %>%
      tbl_summary(
        by=as.character(treatment_pfizer[2]),
        missing = "ifany"
      ) %>%
      as_gt() %>%
      gtsave(
        filename = glue("sepcheck_{outcome}_{brand}_vaxpfizer1.html"),
        path=here::here("output", cohort, "descriptive", "model-checks")
      )

    data_pt_sub_treatment %>%
      select(all.vars(treatment_az)) %>%
      tbl_summary(
        by=as.character(treatment_az[2]),
        missing = "ifany"
      ) %>%
      as_gt() %>%
      gtsave(
        filename = glue("sepcheck_{outcome}_{brand}_vaxaz1.html"),
        path=here::here("output", cohort, "descriptive", "model-checks")
      )

    data_pt_sub %>%
      select(all.vars(treatment_coviddeath)) %>%
      tbl_summary(
        by=as.character(treatment_coviddeath[2]),
        missing = "ifany"
      ) %>%
      as_gt() %>%
      gtsave(
        filename = glue("sepcheck_{outcome}_{brand}_coviddeath.html"),
        path=here::here("output", cohort, "descriptive", "model-checks")
      )

    data_pt_sub %>%
      select(all.vars(treatment_noncoviddeath)) %>%
      tbl_summary(
        by=as.character(treatment_noncoviddeath[2]),
        missing = "ifany"
      ) %>%
      as_gt() %>%
      gtsave(
        filename = glue("sepcheck_{outcome}_{brand}_noncoviddeath.html"),
        path=here::here("output", cohort, "descriptive", "model-checks")
      )

    data_pt_sub %>%
      select(all.vars(treatment_death)) %>%
      tbl_summary(
        by=as.character(treatment_death[2]),
        missing = "ifany"
      ) %>%
      as_gt() %>%
      gtsave(
        filename = glue("sepcheck_{outcome}_{brand}_death.html"),
        path=here::here("output", cohort, "descriptive", "model-checks")
      )


    data_pt_sub %>%
      select(all.vars(outcome_formula)) %>%
      tbl_summary(
        by=as.character(outcome_formula[2]),
        missing = "ifany"
      ) %>%
      as_gt() %>%
      gtsave(
        filename = glue("sepcheck_{outcome}_{brand}_outcome.html"),
        path=here::here("output", cohort, "descriptive", "model-checks")
      )


  }
}

