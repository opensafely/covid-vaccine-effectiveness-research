
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
    over80s = (age>=80) & (is.na(care_home_type)) & (is.na(prior_positive_test_date)) & (!is.na(region)),
    in70s = (age>=70 & age<80) & (is.na(care_home_type)) & (is.na(prior_positive_test_date)) & (!is.na(region)),
    under65s = (age<=64) & (is.na(care_home_type)) & (is.na(prior_positive_test_date))  & (!is.na(region)),
  )


## define different cohorts ----

metadata_cohorts <- tribble(
  ~cohort, ~outcome, ~cohort_descr, ~outcome_var, ~outcome_descr, #~postvax_cuts, ~knots,
  "over80s", "postest", "Aged 80+, non-carehome, no prior positive test", "positive_test_1_date", "Positive test",
  "in70s", "postest", "Aged 70-79, non-carehome, no prior positive test", "positive_test_1_date", "Positive test",
  "under65s", "postest", "Aged <=64, no prior positive test", "positive_test_1_date", "Positive test"
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



## define outcomes, exposures, and covariates ----

formula_exposure <- . ~ . + timesincevax_pw
formula_demog <- . ~ . + age + I(age*age) + sex + imd + ethnicity
formula_comorbs <- . ~ . +
  chronic_cardiac_disease + current_copd + dementia + dialysis +
  solid_organ_transplantation + chemo_or_radio +
  permanant_immunosuppression + asplenia +
  dmards +
  intel_dis_incl_downs_syndrome + psychosis_schiz_bipolar +
  lung_cancer + cancer_excl_lung_and_haem + haematological_cancer +
  flu_vaccine

formula_secular <- . ~ . + ns(tstop, knots=knots)
formula_secular_region <- . ~ . + ns(tstop, knots=knots)*region
formula_timedependent <- . ~ . + hospital_status + probable_covid_status + suspected_covid_status # consider adding local infection rates


formula_all_rhsvars <- update(1 ~ 1, formula_exposure) %>%
  update(formula_demog) %>%
  update(formula_comorbs) %>%
  update(formula_secular) %>%
  update(formula_secular_region) %>%
  update(formula_timedependent)

list_formula <- lst(
  formula_exposure,
  formula_demog,
  formula_comorbs,
  formula_secular,
  formula_secular_region,
  formula_timedependent,
  formula_all_rhsvars
)

write_rds(list_formula, here::here("output", "data", glue::glue("list_formula.rds")))


