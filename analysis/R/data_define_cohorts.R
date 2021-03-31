
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data
# creates indicator variables for each potential cohort/outcome combination of interest
# creates a metadata df that describes each cohort
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')

## create output directories ----
dir.create(here::here("output", "data"), showWarnings = FALSE, recursive=TRUE)

## Import processed data ----

data_all <- read_rds(here::here("output", "data", "data_all.rds"))

data_cohorts <- data_all %>%
  transmute(
    patient_id,
    over80s = (age>=80) & (is.na(care_home_type)) & (is.na(prior_positive_test_date) & is.na(prior_primary_care_covid_case_date) & is.na(prior_covidadmitted_date)),
    in70s = (age>=70 & age<80) & (is.na(care_home_type)) & (is.na(prior_positive_test_date) & is.na(prior_primary_care_covid_case_date) & is.na(prior_covidadmitted_date)) ,
    under65s = (age<=64) & (is.na(prior_positive_test_date) & is.na(prior_primary_care_covid_case_date) & is.na(prior_covidadmitted_date)),
  )


## define different cohorts ----

metadata_cohorts <- tribble(
  ~cohort, ~cohort_descr, #~postvax_cuts, ~knots,
  "over80s", "Aged 80+, non-carehome, no prior infection",
  "in70s", "Aged 70-79, non-carehome, no prior infection",
  "under65s", "Aged <=64, no prior infection",
) %>%
mutate(
  cohort_size = map_int(cohort, ~sum(data_cohorts[[.]]))
)

metadata_cohorts %>% select(cohort, cohort_size) %>% print(n=100)

stopifnot("cohort names should match" = names(data_cohorts)[-1] == metadata_cohorts$cohort)
stopifnot("all cohorts should contain at least 1 patient" = all(metadata_cohorts$cohort_size>0))


## Save processed data ----
write_rds(data_cohorts, here::here("output", "data", "data_cohorts.rds"))
write_rds(metadata_cohorts, here::here("output", "data", "metadata_cohorts.rds"))
write_csv(metadata_cohorts, here::here("output", "data", "metadata_cohorts.csv"))



## define different outcomes ----

metadata_outcomes <- tribble(
  ~outcome, ~outcome_var, ~outcome_descr,
 "postest", "positive_test_1_date", "Positive test",
 "emergency", "emergency_1_date", "A&E attendance",
 "covidadmitted", "covidadmitted_1_date", "COVID-related admission",
 "coviddeath", "coviddeath_date", "COVID-related death",
 "noncoviddeath", "noncoviddeath_date", "Non-COVID-related death",
 "death", "death_date", "Any death",
 "vaccine", "covid_vax_1_date", "First vaccination date"
)

write_rds(metadata_outcomes, here::here("output", "data", "metadata_outcomes.rds"))

## define outcomes, exposures, and covariates ----

formula_exposure <- . ~ . + timesincevax_pw
formula_demog <- . ~ . + age + I(age*age) + sex + imd + ethnicity
formula_comorbs <- . ~ . +
  bmi +
  chronic_cardiac_disease +
  heart_failure +
  other_heart_disease +

  dialysis +
  diabetes +
  chronic_liver_disease +

  current_copd +
  #cystic_fibrosis +
  other_resp_conditions +

  lung_cancer +
  haematological_cancer +
  cancer_excl_lung_and_haem +

  chemo_or_radio +
  #solid_organ_transplantation +
  #bone_marrow_transplant +
  #sickle_cell_disease +
  permanant_immunosuppression +
  #temporary_immunosuppression +
  asplenia +
  dmards +

  dementia +
  other_neuro_conditions +

  LD_incl_DS_and_CP +
  psychosis_schiz_bipolar +

  flu_vaccine


formula_region <- . ~ . + region
formula_secular <- . ~ . + ns(tstop, df=4)
formula_secular_region <- . ~ . + ns(tstop, df=4)*region

formula_timedependent <- . ~ . +
  timesince_probable_covid_pw +
  timesince_suspected_covid_pw +
  timesince_hosp_discharge_pw
  # consider adding local infection rates


formula_all_rhsvars <- update(1 ~ 1, formula_exposure) %>%
  update(formula_demog) %>%
  update(formula_comorbs) %>%
  update(formula_secular) %>%
  update(formula_secular_region) %>%
  update(formula_timedependent)

postvaxcuts <- c(0, 3, 7, 14, 21)

list_formula <- lst(
  formula_exposure,
  formula_demog,
  formula_comorbs,
  formula_secular,
  formula_secular_region,
  formula_timedependent,
  formula_all_rhsvars,
  postvaxcuts
)

write_rds(list_formula, here::here("output", "data", glue::glue("list_formula.rds")))


