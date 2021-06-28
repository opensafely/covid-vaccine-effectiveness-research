
# # # # # # # # # # # # # # # # # # # # #
# This script:
# creates indicator variables for each potential cohort/outcome combination of interest
# creates a metadata df that describes each cohort
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')


## create output directories ----
dir.create(here::here("output", "metadata"), showWarnings = FALSE, recursive=TRUE)

# define cohorts ----

metadata_cohorts <- tribble(
  ~cohort, ~cohort_descr, #~postvax_cuts, ~knots,
  "over70s", "Aged 70+, non-carehome, no prior infection",
  "over80s", "Aged 80+, non-carehome, no prior infection",
  "in70s", "Aged 70-79, non-carehome, no prior infection",
  "under65s", "Aged <=64, no prior infection",
)
write_rds(metadata_cohorts, here::here("output", "metadata", "metadata_cohorts.rds"))
write_csv(metadata_cohorts, here::here("output", "metadata", "metadata_cohorts.csv"))

# define different outcomes ----

metadata_outcomes <- tribble(
  ~outcome, ~outcome_var, ~outcome_descr,
  "test", "covid_test_1_date", "Covid test",
  "postest", "positive_test_1_date", "Positive test",
  "emergency", "emergency_1_date", "A&E attendance",
  "covidadmitted", "covidadmitted_1_date", "COVID-19 hospitalisation",
  "coviddeath", "coviddeath_date", "COVID-19 death",
  "noncoviddeath", "noncoviddeath_date", "Non-COVID-19 death",
  "death", "death_date", "Any death",
  "vaccine", "covid_vax_1_date", "First vaccination date"
)

write_rds(metadata_outcomes, here::here("output", "metadata", "metadata_outcomes.rds"))

# define exposures and covariates ----


## choose and name characteristics to print ----

characteristics <- list(
  age ~ "Age",
  sex ~ "Sex",
  imd ~ "IMD",
  #region ~ "Region",
  ethnicity_combined ~ "Ethnicity",

  bmi ~ "Body Mass Index",

  heart_failure ~ "Heart failure",
  other_heart_disease ~ "Other heart disease",

  dialysis ~ "Dialysis",
  diabetes ~ "Diabetes",
  chronic_liver_disease ~ "Chronic liver disease",

  current_copd ~ "COPD",
  #cystic_fibrosis ~ "Cystic fibrosis",
  other_resp_conditions ~ "Other respiratory conditions",

  lung_cancer ~ "Lung Cancer",
  haematological_cancer ~ "Haematological cancer",
  cancer_excl_lung_and_haem ~ "Cancer excl. lung, haemo",

  #chemo_or_radio ~ "Chemo- or radio-therapy",
  #solid_organ_transplantation ~ "Solid organ transplant",
  #bone_marrow_transplant ~ "Bone marrow transplant",
  #sickle_cell_disease ~ "Sickle Cell Disease",
  #permanant_immunosuppression ~ "Permanent immunosuppression",
  #temporary_immunosuppression ~ "Temporary Immunosuppression",
  #asplenia ~ "Asplenia",
  #dmards ~ "DMARDS",

  any_immunosuppression ~ "Immunosuppressed",

  dementia ~ "Dementia",
  other_neuro_conditions ~ "Other neurological conditions",

  LD_incl_DS_and_CP ~ "Learning disabilities",
  psychosis_schiz_bipolar ~ "Serious mental illness",

  multimorb ~ "Morbidity count",
  efi_cat ~ "Frailty",

  shielded ~ "Shielding criteria met",

  flu_vaccine ~ "Flu vaccine in previous 5 years"

) %>%
  set_names(., map_chr(., all.vars))

write_rds(characteristics, here::here("output", "metadata", glue::glue("baseline_characteristics.rds")))

formula_exposure <- . ~ . + timesincevax_pw
#formula_demog <- . ~ . + age + I(age * age) + sex + imd + ethnicity
formula_demog <- . ~ . + poly(age, degree=2, raw=TRUE) + sex + imd + ethnicity_combined
formula_comorbs <- . ~ . +
  bmi +
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

  #chemo_or_radio +
  #solid_organ_transplantation +
  #bone_marrow_transplant +
  #sickle_cell_disease +
  #permanant_immunosuppression +
  #temporary_immunosuppression +
  #asplenia +
  #dmards +
  any_immunosuppression +

  dementia +
  other_neuro_conditions +

  LD_incl_DS_and_CP +
  psychosis_schiz_bipolar +

  multimorb +

  shielded +

  flu_vaccine +

  efi_cat


formula_region <- . ~ . + region
formula_secular <- . ~ . + ns(tstop, df=5)
formula_secular_region <- . ~ . + ns(tstop, df=5)*region

formula_timedependent <- . ~ . +
  #timesince_probable_covid_pw +
  timesince_postesttdc_pw +
  timesince_suspectedcovid_pw +
  timesince_hospinfectiousdischarge_pw +
  timesince_hospnoninfectiousdischarge_pw


formula_all_rhsvars <- update(1 ~ 1, formula_exposure) %>%
  update(formula_demog) %>%
  update(formula_comorbs) %>%
  update(formula_secular) %>%
  update(formula_secular_region) %>%
  update(formula_timedependent)

postvaxcuts <- c(0, 3, 7, 14, 21, 28, 35)

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

write_rds(list_formula, here::here("output", "metadata", glue::glue("list_formula.rds")))

## choose whether to reweight follow time by probability of death as a censoring event

reweight_death <- 0
write_rds(reweight_death, here::here("output", "metadata", glue::glue("reweight_death.rds")))

## define stratification variables ----

list_strata <- list(
  all = factor("all"),
  any_immunosuppression = c(0L, 1L)
)

write_rds(list_strata, here::here("output", "metadata", glue::glue("list_strata.rds")))

