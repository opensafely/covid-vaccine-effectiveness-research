######################################

# This script:
# imports data extracted by the cohort extractor
# fills in unknown ethnicity from GP records with ethnicity from SUS (secondary care)
# tidies missing values
# re-orders date variables so no negative time differences (only actually does anything for dummy data)
# standardises some variables (eg convert to factor) and derives some new ones
# saves processed one-row-per-patient dataset
# saves one-row-per-patient dataset for vaccines and for hospital admissions

######################################




# Import libraries ----
library('tidyverse')
library('lubridate')
library('glue')
#library('arrow')

# Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))

# import globally defined repo variables from
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
gbl_vars$run_date =date(file.info(here::here("metadata", "extract_over80s.log"))$ctime)
#list2env(gbl_vars, globalenv())


## import command-line arguments ----
args <- commandArgs(trailingOnly=TRUE)
if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"

} else {
  removeobs <- TRUE
  cohort <- args[[1]]
}


if(cohort=="over80s"){
  start_date = "2020-12-08"
} else
if(cohort=="in70s"){
  start_date= "2021-01-05"
}

# output processed data to rds ----

dir.create(here::here("output", cohort, "data"), showWarnings = FALSE, recursive=TRUE)


# process ----

data_extract0 <- read_csv(
  here::here("output", glue("input_{cohort}.csv.gz")),
  col_types = cols_only(

    # identifiers
    patient_id = col_integer(),
    practice_id = col_integer(),

    # demographic / administrative
    msoa = col_character(),
    stp = col_character(),
    region = col_character(),
    imd = col_character(),
    rural_urban = col_integer(),
    care_home_type = col_character(),
    care_home_tpp = col_logical(),
    care_home_code = col_logical(),
    #nontpp_household = col_logical(),
    #tpp_coverage = col_double(),

    has_follow_up_previous_year = col_logical(),

    age = col_integer(),
    sex = col_character(),
    ethnicity = col_character(),
    ethnicity_6_sus = col_character(),
    #ethnicity_16 = col_character(),

    # dates
    dereg_date = col_date(format="%Y-%m-%d"),

    prior_positive_test_date = col_date(format="%Y-%m-%d"),
    prior_primary_care_covid_case_date = col_date(format="%Y-%m-%d"),
    prior_covidadmitted_date = col_date(format="%Y-%m-%d"),

    admitted_unplanned_0_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_1_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_2_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_3_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_4_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_5_date = col_date(format="%Y-%m-%d"),

    discharged_unplanned_0_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_1_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_2_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_3_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_4_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_5_date = col_date(format="%Y-%m-%d"),

    admitted_unplanned_infectious_0_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_infectious_1_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_infectious_2_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_infectious_3_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_infectious_4_date = col_date(format="%Y-%m-%d"),
    admitted_unplanned_infectious_5_date = col_date(format="%Y-%m-%d"),

    discharged_unplanned_infectious_0_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_infectious_1_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_infectious_2_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_infectious_3_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_infectious_4_date = col_date(format="%Y-%m-%d"),
    discharged_unplanned_infectious_5_date = col_date(format="%Y-%m-%d"),


    primary_care_probable_covid_1_date = col_date(format="%Y-%m-%d"),
    primary_care_probable_covid_2_date = col_date(format="%Y-%m-%d"),
    primary_care_probable_covid_3_date = col_date(format="%Y-%m-%d"),
    primary_care_probable_covid_4_date = col_date(format="%Y-%m-%d"),
    primary_care_probable_covid_5_date = col_date(format="%Y-%m-%d"),

    primary_care_suspected_covid_1_date = col_date(format="%Y-%m-%d"),
    primary_care_suspected_covid_2_date = col_date(format="%Y-%m-%d"),
    primary_care_suspected_covid_3_date = col_date(format="%Y-%m-%d"),
    primary_care_suspected_covid_4_date = col_date(format="%Y-%m-%d"),
    primary_care_suspected_covid_5_date = col_date(format="%Y-%m-%d"),


    prior_covid_vax_date = col_date(format="%Y-%m-%d"),
    covid_vax_1_date = col_date(format="%Y-%m-%d"),
    covid_vax_2_date = col_date(format="%Y-%m-%d"),
    covid_vax_3_date = col_date(format="%Y-%m-%d"),

    prior_covid_vax_pfizer_date = col_date(format="%Y-%m-%d"),
    covid_vax_pfizer_1_date = col_date(format="%Y-%m-%d"),
    covid_vax_pfizer_2_date = col_date(format="%Y-%m-%d"),
    covid_vax_pfizer_3_date = col_date(format="%Y-%m-%d"),

    prior_covid_vax_az_date = col_date(format="%Y-%m-%d"),
    covid_vax_az_1_date = col_date(format="%Y-%m-%d"),
    covid_vax_az_2_date = col_date(format="%Y-%m-%d"),
    covid_vax_az_3_date = col_date(format="%Y-%m-%d"),

    unknown_vaccine_brand = col_logical(),

    covid_test_1_date = col_date(format="%Y-%m-%d"),
    covid_test_2_date = col_date(format="%Y-%m-%d"),
    positive_test_1_date = col_date(format="%Y-%m-%d"),
    positive_test_2_date = col_date(format="%Y-%m-%d"),
    positive_test_3_date = col_date(format="%Y-%m-%d"),
    positive_test_4_date = col_date(format="%Y-%m-%d"),
    primary_care_covid_case_1_date = col_date(format="%Y-%m-%d"),
    primary_care_covid_case_2_date = col_date(format="%Y-%m-%d"),
    emergency_1_date = col_date(format="%Y-%m-%d"),
    emergency_2_date = col_date(format="%Y-%m-%d"),
    covidadmitted_1_date = col_date(format="%Y-%m-%d"),
    covidadmitted_2_date = col_date(format="%Y-%m-%d"),
    covidadmitted_3_date = col_date(format="%Y-%m-%d"),
    covidadmitted_4_date = col_date(format="%Y-%m-%d"),
    coviddeath_date = col_date(format="%Y-%m-%d"),
    death_date = col_date(format="%Y-%m-%d"),

    bmi = col_character(),

    chronic_cardiac_disease = col_logical(),
    heart_failure = col_logical(),
    other_heart_disease = col_logical(),

    dialysis = col_logical(),

    diabetes = col_logical(),
    chronic_liver_disease = col_logical(),

    current_copd = col_logical(),
    cystic_fibrosis = col_logical(),
    other_resp_conditions = col_logical(),

    lung_cancer = col_logical(),
    haematological_cancer = col_logical(),
    cancer_excl_lung_and_haem = col_logical(),

    chemo_or_radio = col_logical(),
    solid_organ_transplantation = col_logical(),
    bone_marrow_transplant = col_logical(),
    sickle_cell_disease = col_logical(),
    permanant_immunosuppression = col_logical(),
    temporary_immunosuppression = col_logical(),
    asplenia = col_logical(),
    dmards = col_logical(),

    dementia = col_logical(),
    other_neuro_conditions = col_logical(),
    LD_incl_DS_and_CP = col_logical(),
    psychosis_schiz_bipolar = col_logical(),
    flu_vaccine = col_logical(),
    shielded_ever = col_logical(),
    shielded = col_logical(),
    efi = col_double(),
    endoflife = col_logical()

  ),

  na = character() # more stable to convert to missing later
)

# parse NAs
data_extract <- data_extract0 %>%
  mutate(across(
    .cols = where(is.character),
    .fns = ~na_if(.x, "")
  )) %>%
  mutate(across(
    .cols = c(where(is.numeric), -ends_with("_id"), -all_of("efi")), #convert numeric+integer but not id variables
    .fns = ~na_if(.x, 0)
  )) %>%
  arrange(patient_id) %>%
  select(all_of((names(data_extract0))))


##  SECTION TO SORT OUT BAD DUMMY DATA ----
# this rearranges so events are in date order

data_dates_reordered_long <- data_extract %>%
  select(patient_id, matches("^(.*)_(\\d+)_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, event, date) %>%
  group_by(patient_id, event) %>%
  mutate(
    index = row_number(),
    name = paste0(event,"_",index,"_date")
  ) %>%
  ungroup() %>%
  select(
    patient_id, name, event, index, date
  )


data_dates_reordered_wide <- data_dates_reordered_long %>%
  arrange(name, patient_id) %>%
  pivot_wider(
    id_cols=c(patient_id),
    names_from = name,
    values_from = date
  )

data_extract_reordered <- left_join(
  data_extract %>% select(-matches("^(.*)_(\\d+)_date")),
  data_dates_reordered_wide,
  by="patient_id"
)


data_processed <- data_extract_reordered %>%
  mutate(

    start_date = as.Date(start_date), # i.e., this is interpreted later as [midnight at the _end of_ the start date] = [midnight at the _start of_ start date + 1], So that for example deaths on start_date+1 occur at t=1, not t=0.
    end_date = as.Date(gbl_vars$end_date),
    censor_date = pmin(end_date, death_date, na.rm=TRUE),

    sex = fct_case_when(
      sex == "F" ~ "Female",
      sex == "M" ~ "Male",
      #sex == "I" ~ "Inter-sex",
      #sex == "U" ~ "Unknown",
      TRUE ~ NA_character_
    ),

    ageband = cut(
      age,
      breaks=c(-Inf, 18, 50, 60, 70, 80, Inf),
      labels=c("under 18", "18-49", "50s", "60s", "70s", "80+"),
      right=FALSE
    ),

    # Fill in unknown ethnicity from GP records with ethnicity from SUS (secondary care)
    ethnicity_combined = if_else(ethnicity %in% c("", NA), ethnicity_6_sus, ethnicity),
    ethnicity_combined = fct_case_when(
      ethnicity_combined == "1" ~ "White",
      ethnicity_combined == "4" ~ "Black",
      ethnicity_combined == "3" ~ "South Asian",
      ethnicity_combined == "2" ~ "Mixed",
      ethnicity_combined == "5" ~ "Other",
      #TRUE ~ "Unknown",
      TRUE ~ NA_character_

    ),


    imd = na_if(imd, "0"),
    imd = fct_case_when(
      imd == 1 ~ "1 most deprived",
      imd == 2 ~ "2",
      imd == 3 ~ "3",
      imd == 4 ~ "4",
      imd == 5 ~ "5 least deprived",
      #TRUE ~ "Unknown",
      TRUE ~ NA_character_
    ),

    region = factor(region,
                    levels= c(
                      "East",
                      "East Midlands",
                      "London",
                      "North East",
                      "North West",
                      "South East",
                      "South West",
                      "West Midlands",
                      "Yorkshire and The Humber"
                    )
    ),
    stp = as.factor(stp),
    msoa = as.factor(msoa),
    care_home_type = as.factor(care_home_type),
    care_home_combined = care_home_tpp | care_home_code, # any carehome flag

    bmi = as.factor(bmi),

    any_immunosuppression = (permanant_immunosuppression | asplenia | dmards | solid_organ_transplantation | sickle_cell_disease | temporary_immunosuppression | bone_marrow_transplant | chemo_or_radio),

    multimorb =
      (bmi %in% c("Obese II (35-39.9)", "Obese III (40+)")) +
      (chronic_cardiac_disease | heart_failure | other_heart_disease) +
      (dialysis) +
      (diabetes) +
      (chronic_liver_disease)+
      (current_copd | other_resp_conditions)+
      (lung_cancer | haematological_cancer | cancer_excl_lung_and_haem)+
      (any_immunosuppression)+
      (dementia | other_neuro_conditions)+
      (LD_incl_DS_and_CP)+
      (psychosis_schiz_bipolar),
    multimorb = cut(multimorb, breaks = c(0, 1, 2, 3, 4, Inf), labels=c("0", "1", "2", "3", "4+"), right=FALSE),

    efi_cat = fct_case_when(
      is.na(efi) | (efi <= 0.12) ~ "None",
      efi <= 0.24 ~ "Mild",
      efi <= 0.36 ~ "Moderate",
      efi <= 1 ~ "Severe"
    ),

    cause_of_death = fct_case_when(
      !is.na(coviddeath_date) ~ "covid-related",
      !is.na(death_date) ~ "not covid-related",
      TRUE ~ NA_character_
    ),

    noncoviddeath_date = if_else(!is.na(death_date) & is.na(coviddeath_date), death_date, as.Date(NA_character_))

  ) %>%
  droplevels()

write_rds(data_processed, here::here("output", cohort, "data", "data_processed.rds"), compress="gz")


