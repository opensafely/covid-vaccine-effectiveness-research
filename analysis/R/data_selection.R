
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data from `data_process.R`
# filters out patients who should be exlcuded from the main analysis
# creates an inclusion/exclusion data frame that reports how many patients were excluded at each step
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')

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
fs::dir_create(here("output", cohort, "data"))

## Import processed data ----

data_processed <- read_rds(here("output", cohort, "data", "data_processed.rds"))

data_criteria <- data_processed %>%
  mutate(
    patient_id,
    has_age = !is.na(age),
    has_sex = !is.na(sex),
    has_imd = !is.na(imd),
    has_ethnicity = !is.na(ethnicity_combined),
    has_region = !is.na(region),
    has_follow_up_previous_year,
    previous_covid_vaccine = !is.na(covid_vax_pfizer_0_date) | !is.na(covid_vax_az_0_date),
    unknown_vaccine_brand = (
      (covid_vax_pfizer_1_date == covid_vax_az_1_date) & (!is.na(covid_vax_pfizer_1_date)) & (!is.na(covid_vax_az_1_date)) |
        covid_vax_pfizer_1_date == covid_vax_moderna_1_date & (!is.na(covid_vax_pfizer_1_date)) & (!is.na(covid_vax_moderna_1_date)) |
        covid_vax_moderna_1_date == covid_vax_az_1_date & (!is.na(covid_vax_moderna_1_date)) & (!is.na(covid_vax_az_1_date))
    ),
    unknown_vaccine_brand = covid_vax_1_type %in% c("duplicate"),
    care_home_combined,
    endoflife,
    nopriorcovid = (is.na(positive_test_0_date) & is.na(primary_care_covid_case_0_date) & is.na(covidadmitted_0_date)),

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
write_rds(data_cohort, here("output", cohort, "data", "data_cohort.rds"), compress="gz")


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
write_csv(data_flowchart, here("output", cohort, "data", glue("flowchart.csv")))




