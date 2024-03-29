
# Preliminaries ----

## Import libraries ----
library('tidyverse')

# Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))

## import command-line arguments ----
args <- commandArgs(trailingOnly=TRUE)

if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"

} else{
  removeobs <- TRUE
  cohort <- args[[1]]
}

## create output directories ----
dir.create(here::here("output", cohort, "data"), showWarnings = FALSE, recursive=TRUE)

## Import processed data ----

data_processed <- read_rds(here::here("output", cohort, "data", "data_processed.rds"))

## create one-row-per-event datasets ----
# for vaccination, positive test, hospitalisation/discharge, covid in primary care, death


data_admissions <- data_processed %>%
  select(patient_id, matches("^admitted\\_unplanned\\_\\d+\\_date"), matches("^discharged\\_unplanned\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(".value", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_drop_na = TRUE
  ) %>%
  select(patient_id, index, admitted_date=admitted_unplanned, discharged_date = discharged_unplanned) %>%
  arrange(patient_id, admitted_date)

data_admissions_infectious <- data_processed %>%
  select(patient_id, matches("^admitted\\_unplanned\\_infectious\\_\\d+\\_date"), matches("^discharged\\_unplanned\\_infectious\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(".value", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_drop_na = TRUE
  ) %>%
  select(patient_id, index, admitted_date=admitted_unplanned_infectious, discharged_date = discharged_unplanned_infectious) %>%
  arrange(patient_id, admitted_date)

#remove infeectious admissions from all admissions data
data_admissions_noninfectious <- anti_join(
  data_admissions,
  data_admissions_infectious,
  by = c("patient_id", "admitted_date", "discharged_date")
)


data_pr_suspected_covid <- data_processed %>%
  select(patient_id, matches("^primary_care_suspected_covid\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(NA, "suspected_index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)

data_pr_probable_covid <- data_processed %>%
  select(patient_id, matches("^primary_care_probable_covid\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(NA, "probable_index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)

data_postest <- data_processed %>%
  select(patient_id, matches("^positive\\_test\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(NA, "postest_index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)

data_vax <- local({

  data_vax_all <- data_processed %>%
    select(patient_id, matches("covid\\_vax\\_\\d+\\_date")) %>%
    pivot_longer(
      cols = -patient_id,
      names_to = c(NA, "vax_index"),
      names_pattern = "^(.*)_(\\d+)_date",
      values_to = "date",
      values_drop_na = TRUE
    ) %>%
    arrange(patient_id, date)

  data_vax_pf <- data_processed %>%
    select(patient_id, matches("covid\\_vax\\_pfizer\\_\\d+\\_date")) %>%
    pivot_longer(
      cols = -patient_id,
      names_to = c(NA, "vax_pf_index"),
      names_pattern = "^(.*)_(\\d+)_date",
      values_to = "date",
      values_drop_na = TRUE
    ) %>%
    arrange(patient_id, date)

  data_vax_az <- data_processed %>%
    select(patient_id, matches("covid\\_vax\\_az\\_\\d+\\_date")) %>%
    pivot_longer(
      cols = -patient_id,
      names_to = c(NA, "vax_az_index"),
      names_pattern = "^(.*)_(\\d+)_date",
      values_to = "date",
      values_drop_na = TRUE
    ) %>%
    arrange(patient_id, date)


  data_vax_all %>%
    left_join(data_vax_pf, by=c("patient_id", "date")) %>%
    left_join(data_vax_az, by=c("patient_id", "date")) %>%
    mutate(
      vaccine_type = fct_case_when(
        !is.na(vax_az_index) & is.na(vax_pf_index) ~ "Ox-AZ",
        is.na(vax_az_index) & !is.na(vax_pf_index) ~ "Pf-BNT",
        is.na(vax_az_index) & is.na(vax_pf_index) ~ "Unknown",
        !is.na(vax_az_index) & !is.na(vax_pf_index) ~ "Both",
        TRUE ~ NA_character_
      )
    ) %>%
    arrange(patient_id, date)

})


write_rds(data_vax, here::here("output", cohort, "data", "data_long_vax_dates.rds"), compress="gz")
write_rds(data_admissions, here::here("output", cohort,  "data", "data_long_admission_dates.rds"), compress="gz")
write_rds(data_admissions_infectious, here::here("output", cohort, "data", "data_long_admission_infectious_dates.rds"), compress="gz")
write_rds(data_admissions_noninfectious, here::here("output", cohort, "data", "data_long_admission_noninfectious_dates.rds"), compress="gz")
write_rds(data_pr_probable_covid, here::here("output", cohort, "data", "data_long_pr_probable_covid_dates.rds"), compress="gz")
write_rds(data_pr_suspected_covid, here::here("output", cohort, "data", "data_long_pr_suspected_covid_dates.rds"), compress="gz")
write_rds(data_postest, here::here("output", cohort,  "data", "data_long_postest_dates.rds"), compress="gz")
