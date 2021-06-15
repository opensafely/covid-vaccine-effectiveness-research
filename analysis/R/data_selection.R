
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data
# creates indicator variables for each potential cohort/outcome combination of interest
# creates a metadata df that describes each cohort
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')

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

data_criteria <- data_processed %>%
  mutate(
    patient_id,
    has_age = !is.na(age),
    has_sex = !is.na(sex),
    has_imd = !is.na(imd),
    has_ethnicity = !is.na(ethnicity_combined),
    has_region = !is.na(region),
    has_follow_up_previous_year,
    previous_covid_vaccine = !is.na(prior_covid_vax_date) | !is.na(prior_covid_vax_pfizer_date) | !is.na(prior_covid_vax_az_date),
    unknown_vaccine_brand,
    care_home_combined,
    endoflife,
    nopriorcovid = (is.na(prior_positive_test_date) & is.na(prior_primary_care_covid_case_date) & is.na(prior_covidadmitted_date)),

    include = (
      has_age & has_sex & has_imd & has_ethnicity & has_region &
        has_follow_up_previous_year &
        !unknown_vaccine_brand &
        !previous_covid_vaccine &
        !care_home_combined &
        !endoflife &
        nopriorcovid
    ),
  )

data_cohort <- data_criteria %>% filter(include)
write_rds(data_cohort, here::here("output", cohort, "data", "data_cohort.rds"), compress="gz")


data_flowchart <- data_criteria %>%
  transmute(
    c0_all = TRUE,
    c1_1yearfup = c0_all & (has_follow_up_previous_year),
    c2_notmissing = c1_1yearfup & (has_age & has_sex & has_imd & has_ethnicity & has_region),
    c3_previousvaccine = c2_notmissing & (!previous_covid_vaccine),
    c4_knownbrand = c3_previousvaccine & (!unknown_vaccine_brand),
    c5_noncarehome = c4_knownbrand & (!care_home_combined),
    c6_nonendoflife = c5_noncarehome & (!endoflife),
    c7_nopriorcovid = c6_nonendoflife & (nopriorcovid),
  ) %>%
  summarise(
    across(.fns=sum)
  ) %>%
  pivot_longer(
    cols=everything(),
    names_to="criteria",
    values_to="n"
  ) %>%
  mutate(
    n_exclude = lag(n) - n,
    pct_exclude = n_exclude/lag(n),
    pct_all = n / first(n),
    pct_step = n / lag(n),
  )
write_csv(data_flowchart, here::here("output", cohort, "data", glue::glue("flowchart.csv")))




