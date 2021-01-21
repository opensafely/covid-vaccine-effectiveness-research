# Import libraries ----
library('tidyverse')
library('lubridate')

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





# process ----

read_csv(
  here::here("output", "input_delivery.csv"),
  n_max=0,
  col_types = cols()
) %>%
names() %>%
print()


data_delivery0 <- read_csv(
  here::here("output", "input_delivery.csv"),
  col_types = cols(

    # identifiers
    patient_id = col_integer(),
    practice_id = col_integer(),

    # demographic / administrative
    stp = col_character(),
    region = col_character(),
    index_of_multiple_deprivation = col_integer(),
    imd = col_character(),
    care_home_type = col_character(),

    has_follow_up = col_logical(),
    registered = col_logical(),
    has_died = col_logical(),

    age = col_integer(),
    ageband = col_character(),
    sex = col_character(),
    ethnicity = col_character(),
    ethnicity_16 = col_character(),


    # clinical

    bmi = col_double(),
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
    adrenaline_pen = col_logical(),

    # dates
    covid_vacc_date = col_date(format="%Y-%m-%d"),
    covid_vacc_second_dose_date = col_date(format="%Y-%m-%d"),
    covid_vacc_pfizer_date = col_date(format="%Y-%m-%d"),
    covid_vacc_oxford_date = col_date(format="%Y-%m-%d"),
    first_positive_test_date_SGSS = col_date(format="%Y-%m-%d"),
    earliest_primary_care_covid_case = col_date(format="%Y-%m-%d"),
    postvac_primary_care_covid_case = col_date(format="%Y-%m-%d"),
    postvac_positive_test_date_SGSS = col_date(format="%Y-%m-%d"),
    postvac_admitted_date = col_date(format="%Y-%m-%d"),
    coviddeath_date = col_date(format="%Y-%m-%d"),
    death_date = col_date(format="%Y-%m-%d")
  ),
  na = character() # more stable to convert to missing later
)

# parse NAs

data_delivery <- data_delivery0 %>%
  mutate(across(
    .cols = where(is.character),
    .fns = ~na_if(.x, "")
  )) %>%
  mutate(across(
    .cols = where(is.numeric),
    .fns = ~na_if(.x, 0)
  ))


data_processed <- data_delivery %>%
  mutate(
    end_date = as.Date("2021-01-18"),

    sex = fct_case_when(
      sex == "F" ~ "Female",
      sex == "M" ~ "Male",
      sex == "I" ~ "Inter-sex",
      sex == "U" ~ "Unknown",
      TRUE ~ NA_character_
    ),

    ethnicity = fct_recode(ethnicity,
      `White` = "1",
      `Mixed` = "2",
      `South Asian` = "3",
      `Black` = "4",
      `Other` = "5"
    ) %>% fct_relevel(c("Black", "Mixed", "South Asian", "White", "Other")),

    imd = fct_recode(na_if(imd, 0),
      `1 least deprived` = "1",
      `2` = "2",
      `3` = "3",
      `4` = "4",
      `5 most deprived` = "5",
    ) %>% fct_relevel(c("1 least deprived", "2", "3", "4", "5 most deprived")),

    vaccine_type = case_when(
      !is.na(covid_vacc_oxford_date) & is.na(covid_vacc_pfizer_date) ~ "Oxford/AZ",
      is.na(covid_vacc_oxford_date) & !is.na(covid_vacc_pfizer_date) ~ "Pfizer",
      !is.na(covid_vacc_oxford_date) & !is.na(covid_vacc_pfizer_date) ~ "Oxford/AZ and Pfizer",
      is.na(covid_vacc_oxford_date) & is.na(covid_vacc_pfizer_date) ~ "Not vaccinated",
      TRUE ~ NA_character_
    ),

    censor_date = pmin(end_date, death_date, na.rm=TRUE),
    tte_end = tte(covid_vacc_date, end_date, end_date),

    postvac_positive_test_date_SGSS_censored = censor(postvac_positive_test_date_SGSS, censor_date, na.censor=FALSE),
    postvac_primary_care_covid_case_censored = censor(postvac_primary_care_covid_case, censor_date, na.censor=FALSE),
    postvac_admitted_date_censored = censor(postvac_admitted_date, censor_date, na.censor=FALSE),
    coviddeath_date_censored = censor(coviddeath_date, censor_date, na.censor=FALSE),
    death_date_censored = censor(death_date, censor_date, na.censor=FALSE),

    tte_posSGSS = tte(covid_vacc_date, postvac_positive_test_date_SGSS, censor_date),
    tte_posPC = tte(covid_vacc_date, postvac_primary_care_covid_case, censor_date),
    tte_admitted = tte(covid_vacc_date, postvac_admitted_date, censor_date),
    tte_coviddeath = tte(covid_vacc_date, coviddeath_date, censor_date),
    tte_death = tte(covid_vacc_date, death_date_censored, censor_date),

    ind_posSGSS = censor_indicator(postvac_positive_test_date_SGSS, censor_date),
    ind_posPC = censor_indicator(postvac_primary_care_covid_case, censor_date),
    ind_admitted = censor_indicator(postvac_admitted_date, censor_date),
    ind_coviddeath = censor_indicator(coviddeath_date, censor_date),
    ind_death = censor_indicator(death_date, censor_date),

  )

# Output processed data ----


# Output summary .txt ----

dir.create(here::here("output", "data_summary"), showWarnings = FALSE, recursive=TRUE)

# capture.output(skimr::skim_without_charts(data_delivery), file = here::here("output", "data_summary", "summary_delivery.txt"))
# capture.output(skimr::skim_without_charts(data_processed), file = here::here("output", "data_summary", "summary_processed.txt"))
capture.output(Hmisc::describe(data_delivery), file = here::here("output", "data_summary", "summary_delivery.txt"))
capture.output(Hmisc::describe(data_processed), file = here::here("output", "data_summary", "summary_processed.txt"))

capture.output(map(data_delivery, class), file = here::here("output", "data_summary", "type_delivery.txt"))
capture.output(map(data_processed, class), file = here::here("output", "data_summary", "type_processed.txt"))


# output processed data to rds ----

dir.create(here::here("output", "data"), showWarnings = FALSE, recursive=TRUE)

write_rds(data_processed, here::here("output", "data", "data_processed.rds"))


