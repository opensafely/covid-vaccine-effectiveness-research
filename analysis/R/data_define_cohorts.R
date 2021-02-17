
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
dir.create(here::here("output", "modeldata"), showWarnings = FALSE, recursive=TRUE)

## Import processed data ----

data_all <- read_rds(here::here("output", "data", "data_all.rds"))

data_cohorts <- data_all %>%
  transmute(
    patient_id,
    over80s = (age>=80) & (is.na(care_home_type)) & (is.na(prior_positive_test_date)),
    under65s = (age<=64) & (is.na(care_home_type)) & (is.na(prior_positive_test_date)),
  )
## define different cohorts ----


metadata_cohorts <- tribble(
  ~cohort, ~cohort_descr, ~outcome, ~outcome_descr, #~postvax_cuts, ~knots,
  "over80s", "Aged 80+, non-carehome, no prior positive test", "positive_test_1_date", "Positive test",
  "under65s", "Aged <=64, no prior positive test", "positive_test_1_date", "Positive test"
)


stopifnot("cohort names should match" = names(data_cohorts)[-1] == metadata_cohorts$cohort)

## Save processed tte data ----
write_rds(data_cohorts, here::here("output", "modeldata", "data_cohorts.rds"))
write_rds(metadata_cohorts, here::here("output", "modeldata", "metadata_cohorts.rds"))
