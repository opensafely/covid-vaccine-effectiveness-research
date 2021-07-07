
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
library('here')
library('glue')
library('gt')
library('gtsummary')

## Import custom user functions from lib
source(here("lib", "utility_functions.R"))
source(here("lib", "redaction_functions.R"))
source(here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "in70s"
  strata_var <- "all"
  sample_nonoutcomeprop <- 0.1
} else {
  cohort <- args[[1]]
  strata_var <- args[[2]]
  sample_nonoutcomeprop <- as.numeric(args[[3]])
  removeobs <- TRUE
}


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())

## if outcome is positive test, remove time-varying positive test info from covariate set


formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ", strata_var))

# Import processed data ----

data_tte <- read_rds(here("output", cohort, "data", "data_tte.rds"))

data_samples <- data_tte  %>%
  transmute(
    patient_id,
    sample_postest = sample_nonoutcomes(tte_postest, patient_id, sample_nonoutcomeprop),
    sample_emergency = sample_nonoutcomes(tte_emergency, patient_id, sample_nonoutcomeprop),
    sample_covidadmitted = sample_nonoutcomes(tte_covidadmitted, patient_id, sample_nonoutcomeprop),
    sample_coviddeath= sample_nonoutcomes(tte_coviddeath, patient_id, sample_nonoutcomeprop),
    sample_noncoviddeath = sample_nonoutcomes(tte_noncoviddeath, patient_id, sample_nonoutcomeprop),
    sample_death = sample_nonoutcomes(tte_death, patient_id, sample_nonoutcomeprop),

    sample_weights_postest = sample_weights(tte_postest, sample_postest),
    sample_weights_emergency = sample_weights(tte_emergency, sample_emergency),
    sample_weights_covidadmitted = sample_weights(tte_covidadmitted, sample_covidadmitted),
    sample_weights_coviddeath = sample_weights(tte_coviddeath, sample_coviddeath),
    sample_weights_noncoviddeath = sample_weights(tte_noncoviddeath, sample_noncoviddeath),
    sample_weights_death = sample_weights(tte_death, sample_death),
  )

data_fixed <- read_rds(here("output", cohort, "data", glue("data_fixed.rds")))

data_pt <- read_rds(here("output", cohort, "data", glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
  mutate(
    all = factor("all",levels=c("all")),
    timesincevax_pw = timesince_cut(timesincevaxany1, postvaxcuts, "pre-vax"),
  ) %>%
  left_join(
    data_fixed, by="patient_id"
  )  %>%
  select(-starts_with("sample_")) %>%
  left_join(
    data_samples,
    by="patient_id"
  )

septab <- function(data, formula, outcome, brand, name){

  if(FALSE){
    #this function is a quicker alternative to the following gtsummary option:
    gttab <- data.matrix() %>%
      select(all.vars(formula)) %>%
      tbl_summary(
        by=as.character(formula[2]),
        missing = "ifany"
      ) %>%
      as_gt()
  }

  tbltab <- data %>%
    select(all.vars(formula), all) %>%
    select(where(~(!is.double(.)))) %>%
    select(-age) %>%
    mutate(
      across(
        where(is.integer),
        ~as.character(.)
      )
    ) %>%
    split(.[[1]]) %>%
    map(~.[,-1] %>% select(all, everything())) %>%
    map(
      function(data){
        map(data, redacted_summary_cat, redaction_threshold=0) %>%
          bind_rows(.id="variable") %>%
          select(-redacted, -pct_nonmiss)
      }
    )

  tbltab %>%
    bind_rows(.id = "event") %>%
    pivot_wider(
      id_cols=c(variable, .level),
      names_from = event,
      names_glue = "event{event}_{.value}",
      values_from = c(n, pct)
    ) %>%
    select(variable, .level, starts_with("event0"), starts_with("event1")) %>%
    gt(
      groupname_col="variable",
    ) %>%
    tab_spanner_delim("_") %>%
    fmt_number(
      columns = ends_with(c("pct")),
      decimals = 1,
      scale_by=100,
      pattern = "({x})"
    ) %>%
    gtsave(
      filename = glue("sepcheck_{outcome}_{brand}_{name}.html"),
      path=here("output", cohort, "descriptive", "model-checks")
    )
}


outcomes <- c("postest", "covidadmitted", "coviddeath", "noncoviddeath", "death")
brands <- c("any", "pfizer", "az")


for(outcome in outcomes){
  for(brand in brands){


    fs::dir_create(here("output", cohort, "descriptive", "model-checks"))

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

    data_pt_atrisk <- data_pt %>%
      filter(
        .[[glue("{outcome}_status")]] == 0, # follow up ends at (day after) occurrence of outcome, ie where status not >0
        lastfup_status == 0, # follow up ends at (day after) occurrence of censoring event (derived from lastfup = min(end_date, death, dereg))
        vaxany1_status == .[[glue("vax{brand}1_status")]], # if brand-specific, follow up ends at (day after) occurrence of competing vaccination, ie where vax{competingbrand}_status not >0
        .[[glue("sample_{outcome}")]] == 1, # select all patients who experienced the outcome, and a proportion of those who don't
        .[[glue("vax{brand}_atrisk")]] == 1 # select follow-up time where vax brand is being administered
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

    data_pt_atrisk_treatment <- data_pt_atrisk %>%
      filter(.[[glue("vax{brand}1_atrisk")]])


    data_pt_atrisk_death <- data_pt_atrisk %>%
      filter(.[[glue("death_atrisk")]])

    data_pt_atrisk_treatment %>%
      summarise(
        obs = n(),
        patients = n_distinct(patient_id),
        vaxany1 = sum(vaxany1),
        vaxpfizer1 = sum(vaxpfizer1),
        vaxaz1 = sum(vaxaz1),
        rate_vaxany1 = vaxany1/patients,
        rate_vaxpfizer1 = vaxpfizer1/patients,
        rate_vaxaz1 = vaxaz1/patients,
        incidencerate_vaxany1 = vaxany1/obs,
        incidencerate_vaxpfizer1 = vaxpfizer1/obs,
        incidencerate_vaxaz1 = vaxaz1/obs
      ) %>%
      write_csv(path=here("output", cohort, "descriptive", "model-checks", glue("summary_{outcome}_{brand}_treatments.csv")))

    data_pt_atrisk %>%
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
      write_csv(path=here("output", cohort, "descriptive", "model-checks", glue("summary_{outcome}_{brand}_outcomes.csv")))


    septab(data_pt_atrisk_treatment, treatment_any, outcome, brand, "vaxany1")
    septab(data_pt_atrisk_treatment, treatment_pfizer, outcome, brand, "vaxpfizer1")
    septab(data_pt_atrisk_treatment, treatment_az, outcome, brand, "vaxaz1")

    septab(data_pt_atrisk_death, treatment_coviddeath, outcome, brand, "coviddeath")
    septab(data_pt_atrisk_death, treatment_noncoviddeath, outcome, brand, "noncoviddeath")
    septab(data_pt_atrisk_death, treatment_death, outcome, brand, "death")

    septab(data_pt_atrisk, outcome_formula, outcome, brand, "outcome")

  }
}


