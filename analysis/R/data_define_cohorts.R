
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
    under65s = (age<=64) & (is.na(care_home_type)) & (is.na(prior_positive_test_date))  & (!is.na(region)),
  )


## define different cohorts ----

metadata_cohorts <- tribble(
  ~cohort, ~outcome, ~cohort_descr, ~outcome_var, ~outcome_descr, #~postvax_cuts, ~knots,
  "over80s", "postest", "Aged 80+, non-carehome, no prior positive test", "positive_test_1_date", "Positive test",
  "under65s", "postest", "Aged <=64, no prior positive test", "positive_test_1_date", "Positive test"
) %>%
mutate(
  cohort_size = map_int(cohort, ~sum(data_cohorts[[.]]))
)

metadata_cohorts %>% select(cohort, cohort_size) %>% print(n=100)

stopifnot("cohort names should match" = names(data_cohorts)[-1] == metadata_cohorts$cohort)
stopifnot("all cohorts should contain at least 1 patient" = all(metadata_cohorts$cohort_size>0))

## Save processed tte data ----
write_rds(data_cohorts, here::here("output", "data", "data_cohorts.rds"))
write_rds(metadata_cohorts, here::here("output", "data", "metadata_cohorts.rds"))
write_csv(metadata_cohorts, here::here("output", "data", "metadata_cohorts.csv"))

