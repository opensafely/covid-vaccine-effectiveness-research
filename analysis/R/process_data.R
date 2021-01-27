# Import libraries ----
library('tidyverse')
library('lubridate')
library('jsonlite')

# functions ----

fct_case_when <- function(...) {
  args <- as.list(match.call())
  levels <- sapply(args[-1], function(f) f[[3]])  # extract RHS of formula
  levels <- levels[!is.na(levels)]
  factor(dplyr::case_when(...), levels=levels)
}

censor <- function(event_date, censor_date, na.censor=TRUE){
  # censors event_date to on or before censor_date
  # if na.censor = TRUE then returns NA if event_date>censor_date, otherwise returns min(event_date, censor_date)
  if (na.censor)
    dplyr::if_else(event_date>censor_date, as.Date(NA_character_), as.Date(event_date))
  else
    dplyr::if_else(event_date>censor_date, as.Date(censor_date), as.Date(event_date))
}

censor_indicator <- function(event_date, censor_date){
  # returns 0 if event_date is censored by censor_date, or if event_date is NA. Otherwise 1
  dplyr::if_else((event_date>censor_date) | is.na(event_date), 0L, 1L)
}

tte <- function(origin_date, event_date, censor_date){
  # returns time to event date or time to censor date, which is earlier
  pmin(event_date-origin_date, censor_date-origin_date, na.rm=TRUE)
}



# get global variables ----

# eventually this section will be replaced by something that imports metadata from the opensafely CLI,
# such as run dates and end dates for study period, etc

# for now, we create it manually

vars_list = list(
  run_date = date(file.info(here::here("metadata","generate_delivery_cohort.log"))$ctime),
  start_date = "2020-12-07", # change this if you need to
  end_date = "2021-01-13"
)

jsonlite::write_json(vars_list, path=here::here("lib", "global-variables.json"), auto_unbox = TRUE,  pretty=TRUE)

# import in R using:
# vars_list <- jsonlite::fromJSON(txt=here::here("lib", "global-variables.json"))
# list2env(vars_list, globalenv())




# process ----

read_csv(
  here::here("output", "input.csv"),
  n_max=0,
  col_types = cols()
) %>%
names() %>%
print()


data_extract0 <- read_csv(
  here::here("output", "input.csv"),
  col_types = cols(

    # identifiers
    patient_id = col_integer(),
    practice_id = col_integer(),

    # demographic / administrative
    stp = col_character(),
    region = col_character(),
    imd = col_character(),
    care_home_type = col_character(),

    registered = col_logical(),
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
    .cols = where(is.numeric),
    .fns = ~na_if(.x, 0)
  ))

data_processed <- data_extract %>%
  mutate(
    end_date = as.Date(vars_list$end_date),

    sex = fct_case_when(
      sex == "F" ~ "Female",
      sex == "M" ~ "Male",
      sex == "I" ~ "Inter-sex",
      sex == "U" ~ "Unknown",
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
      TRUE ~ NA_character_
    ),


    imd = na_if(imd, "0"),
    imd = fct_case_when(
      imd == 1 ~ "1 least deprived",
      imd == 2 ~ "2",
      imd == 3 ~ "3",
      imd == 4 ~ "4",
      imd == 5 ~ "5 most deprived",
      TRUE ~ NA_character_
    ),

    vaccine_first_dose_type = fct_case_when(
      !is.na(covid_vacc_oxford_first_dose_date) & is.na(covid_vacc_pfizer_first_dose_date) ~ "Ox/AZ",
      is.na(covid_vacc_oxford_first_dose_date) & !is.na(covid_vacc_pfizer_first_dose_date) ~ "P/B",
      TRUE ~ "Not vaccinated"
    ),

    covid_vacc_second_dose_date = pmin(covid_vacc_oxford_second_dose_date, covid_vacc_pfizer_second_dose_date, na.rm=TRUE),

    censor_date = pmin(end_date, death_date, na.rm=TRUE),
    tte_end = tte(covid_vacc_date, end_date, end_date),

    # postvac_positive_test_date_SGSS_censored = censor(postvac_positive_test_date_SGSS, censor_date, na.censor=FALSE),
    # postvac_primary_care_covid_case_censored = censor(postvac_primary_care_covid_case, censor_date, na.censor=FALSE),
    # postvac_admitted_date_censored = censor(postvac_admitted_date, censor_date, na.censor=FALSE),
    # coviddeath_date_censored = censor(coviddeath_date, censor_date, na.censor=FALSE),
    # death_date_censored = censor(death_date, censor_date, na.censor=FALSE),

    tte_seconddose = tte(covid_vacc_date, covid_vacc_second_dose_date, censor_date),
    tte_posSGSS = tte(covid_vacc_date, post_vaccine_SGSS_positive_test_date, censor_date),
    tte_posPC = tte(covid_vacc_date, post_vaccine_primary_care_covid_case_date, censor_date),
    tte_admitted = tte(covid_vacc_date, post_vaccine_admitted_date, censor_date),
    tte_coviddeath = tte(covid_vacc_date, coviddeath_date, censor_date),
    tte_death = tte(covid_vacc_date, death_date, censor_date),

    ind_seconddose = censor_indicator(covid_vacc_second_dose_date, censor_date),
    ind_posSGSS = censor_indicator(post_vaccine_SGSS_positive_test_date, censor_date),
    ind_posPC = censor_indicator(post_vaccine_primary_care_covid_case_date, censor_date),
    ind_admitted = censor_indicator(post_vaccine_admitted_date, censor_date),
    ind_coviddeath = censor_indicator(coviddeath_date, censor_date),
    ind_death = censor_indicator(death_date, censor_date),

  )


data_vaccinated <- data_processed %>%
  filter(!is.na(covid_vacc_date))

# Output processed data ----


# Output summary .txt ----

options(width=200) # set output width for capture.output

dir.create(here::here("output", "data_summary"), showWarnings = FALSE, recursive=TRUE)

capture.output(skimr::skim_without_charts(data_extract), file = here::here("output", "data_summary", "summary_extract.txt"), split=FALSE)
capture.output(skimr::skim_without_charts(data_processed), file = here::here("output", "data_summary", "summary_processed.txt"), split=FALSE)
capture.output(skimr::skim_without_charts(data_vaccinated), file = here::here("output", "data_summary", "summary_vaccinated.txt"), split=FALSE)

capture.output(map(data_extract, class), file = here::here("output", "data_summary", "type_extract.txt"))
capture.output(map(data_processed, class), file = here::here("output", "data_summary", "type_processed.txt"))
capture.output(map(data_vaccinated, class), file = here::here("output", "data_summary", "type_vaccinated.txt"))


# output processed data to rds ----

dir.create(here::here("output", "data"), showWarnings = FALSE, recursive=TRUE)

write_rds(data_processed, here::here("output", "data", "data_processed.rds"))
write_rds(data_vaccinated, here::here("output", "data", "data_vaccinated.rds"))





