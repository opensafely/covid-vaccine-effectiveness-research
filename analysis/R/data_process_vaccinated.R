# Import libraries ----
library('tidyverse')
library('lubridate')
library('jsonlite')


source(here::here("lib", "utility_functions.R"))

# get global variables ----

# eventually this section will be replaced by something that imports metadata from the opensafely CLI,
# such as run dates and end dates for study period, etc
# for now, import globally defined repo variables from file:
gbl_vars <- jsonlite::fromJSON(
  txt="./lib/global-variables.json"
)
gbl_vars$run_date =date(file.info(here::here("metadata","generate_delivery_cohort.log"))$ctime)
#list2env(gbl_vars, globalenv())


# process ----

read_csv(
  here::here("output", "input_vaccinated.csv"),
  n_max=0,
  col_types = cols()
) %>%
names() %>%
print()


data_extract0 <- read_csv(
  here::here("output", "input_vaccinated.csv"),
  col_types = cols(

    # identifiers
    patient_id = col_integer(),
    practice_id = col_integer(),

    # demographic / administrative
    stp = col_character(),
    region = col_character(),
    imd = col_character(),
    care_home_type = col_character(),
    care_home = col_logical(),


    registered = col_logical(),
    registered_at_latest_date = col_logical(),
    has_follow_up_previous_year = col_logical(),
    has_died = col_logical(),

    age = col_integer(),
    sex = col_character(),
    ethnicity = col_character(),
    ethnicity_16 = col_character(),


    # clinical

    bmi = col_character(),
    chronic_cardiac_disease = col_logical(),
    current_copd = col_logical(),
    dmards = col_logical(),
    dialysis = col_logical(),
    solid_organ_transplantation = col_logical(),
    chemo_or_radio = col_logical(),
    intel_dis_incl_downs_syndrome = col_logical(),
    lung_cancer = col_logical(),
    cancer_excl_lung_and_haem = col_logical(),
    haematological_cancer = col_logical(),
    bone_marrow_transplant = col_logical(),
    cystic_fibrosis = col_logical(),
    sickle_cell_disease = col_logical(),
    permanant_immunosuppression = col_logical(),
    temporary_immunosuppression = col_logical(),
    psychosis_schiz_bipolar = col_logical(),
    asplenia = col_logical(),
    dementia = col_logical(),


    # dates

    first_SGSS_positive_test_date = col_date(format="%Y-%m-%d"),
    earliest_primary_care_covid_case_date = col_date(format="%Y-%m-%d"),

    covid_vacc_date = col_date(format="%Y-%m-%d"),
    covid_vacc_second_dose_date = col_date(format="%Y-%m-%d"),

    covid_vacc_pfizer_first_dose_date = col_date(format="%Y-%m-%d"),
    covid_vacc_pfizer_second_dose_date = col_date(format="%Y-%m-%d"),
    covid_vacc_pfizer_third_dose_date = col_date(format="%Y-%m-%d"),

    covid_vacc_oxford_first_dose_date = col_date(format="%Y-%m-%d"),
    covid_vacc_oxford_second_dose_date = col_date(format="%Y-%m-%d"),
    covid_vacc_oxford_third_dose_date = col_date(format="%Y-%m-%d"),

    post_vaccine_SGSS_positive_test_date = col_date(format="%Y-%m-%d"),
    post_vaccine_primary_care_covid_case_date = col_date(format="%Y-%m-%d"),
    post_vaccine_admitted_date = col_date(format="%Y-%m-%d"),
    coviddeath_date = col_date(format="%Y-%m-%d"),
    death_date = col_date(format="%Y-%m-%d")
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
    .cols = c(where(is.numeric), -ends_with("_id")), #convert numeric+integer but not id variables
    .fns = ~na_if(.x, 0)
  )) %>%
  arrange(patient_id) %>%
  select(all_of((names(data_extract0))))


data_vaccinated <- data_extract %>%
  mutate(

    start_date = as.Date(gbl_vars$start_date),
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

    ethnicity = fct_case_when(
      ethnicity == "4" ~ "Black",
      ethnicity == "2" ~ "Mixed",
      ethnicity == "3" ~ "South Asian",
      ethnicity == "1" ~ "White",
      ethnicity == "5" ~ "Other",
      #TRUE ~ "Unknown",
      TRUE ~ NA_character_

    ),


    imd = na_if(imd, "0"),
    imd = fct_case_when(
      imd == 1 ~ "1 least deprived",
      imd == 2 ~ "2",
      imd == 3 ~ "3",
      imd == 4 ~ "4",
      imd == 5 ~ "5 most deprived",
      #TRUE ~ "Unknown",
      TRUE ~ NA_character_
    ),

    cause_of_death = fct_case_when(
      !is.na(coviddeath_date) ~ "covid-related",
      !is.na(death_date) ~ "not covid-related",
      TRUE ~ NA_character_
    ),

    covid_vax_1_type = fct_case_when(
      !is.na(covid_vax_az_1_date) & is.na(covid_vax_pfizer_1_date) ~ "Ox-AZ",
      is.na(covid_vax_az_1_date) & !is.na(covid_vax_pfizer_1_date) ~ "P-B",
      !is.na(covid_vax_1_date) ~ "Unknown",
      TRUE ~ "Not vaccinated"
    ),



    tte_end = tte(covid_vax_1_date, end_date, end_date),

    tte_seconddose = tte(covid_vax_1_date, covid_vax_2_date, censor_date),
    tte_posSGSS = tte(covid_vax_1_date, positive_test_1_date, censor_date),
    tte_posPC = tte(covid_vax_1_date, primary_care_covid_case_1_date, censor_date),
    tte_admitted = tte(covid_vax_1_date, covidadmitted_1_date, censor_date),
    tte_coviddeath = tte(covid_vax_1_date, coviddeath_date, censor_date),
    tte_death = tte(covid_vax_1_date, death_date, censor_date),

    ind_seconddose = censor_indicator(covid_vax_2_date, censor_date),
    ind_posSGSS = censor_indicator(positive_test_1_date, censor_date),
    ind_posPC = censor_indicator(primary_care_covid_case_1_date, censor_date),
    ind_admitted = censor_indicator(covidadmitted_1_date, censor_date),
    ind_coviddeath = censor_indicator(coviddeath_date, censor_date),
    ind_death = censor_indicator(death_date, censor_date),

  ) %>%
  droplevels()



## create one-row-per-event datasets ----
# for vaccination

data_vax_dates <- local({

  data_vax_all <- data_vaccinated %>%
    select(patient_id, matches("covid\\_vax\\_\\d+\\_date")) %>%
    pivot_longer(
      cols = -patient_id,
      names_to = c(NA, "vax_index"),
      names_pattern = "^(.*)_(\\d+)_date",
      values_to = "date",
      values_drop_na = TRUE
    ) %>%
    arrange(patient_id, date)

  data_vax_pf <- data_vaccinated %>%
    select(patient_id, matches("covid\\_vax\\_pfizer\\_\\d+\\_date")) %>%
    pivot_longer(
      cols = -patient_id,
      names_to = c(NA, "vax_pf_index"),
      names_pattern = "^(.*)_(\\d+)_date",
      values_to = "date",
      values_drop_na = TRUE
    ) %>%
    arrange(patient_id, date)

  data_vax_az <- data_vaccinated %>%
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
        is.na(vax_az_index) & !is.na(vax_pf_index) ~ "Pf-BN",
        is.na(vax_az_index) & is.na(vax_pf_index) ~ "Unknown",
        !is.na(vax_az_index) & !is.na(vax_pf_index) ~ "Both",
        TRUE ~ NA_character_
      )
    ) %>%
    arrange(patient_id, date)

})


# output processed data to rds ----

dir.create(here::here("output", "data"), showWarnings = FALSE, recursive=TRUE)

write_rds(data_vax_dates, here::here("output", "data", "data_vaccinated_vax_dates.rds"))
write_rds(data_vaccinated, here::here("output", "data", "data_vaccinated.rds"))





