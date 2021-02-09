# Import libraries ----
library('tidyverse')
library('lubridate')
library('jsonlite')
library('survival')

source(here::here("lib", "utility_functions.R"))

vars_list = list(
  run_date = date(file.info(here::here("metadata","generate_delivery_cohort.log"))$ctime),
  start_date = "2020-12-07",
  end_date = "2021-01-13"
)


# process ----

read_csv(
  here::here("output", "input_over80s.csv"),
  n_max=0,
  col_types = cols()
) %>%
names() %>%
print()


data_extract0 <- read_csv(
  here::here("output", "input_over80s.csv"),
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


    registered_at_latest_date = col_logical(),
    has_follow_up_previous_year = col_logical(),

    age = col_integer(),
    sex = col_character(),
    #ethnicity = col_character(),
    #ethnicity_16 = col_character(),

    # dates

    prior_positive_test_date = col_date(format="%Y-%m-%d"),
    prior_primary_care_covid_case_date = col_date(format="%Y-%m-%d"),

    admitted_1_date = col_date(format="%Y-%m-%d"),
    admitted_2_date = col_date(format="%Y-%m-%d"),
    admitted_3_date = col_date(format="%Y-%m-%d"),
    admitted_4_date = col_date(format="%Y-%m-%d"),
    admitted_5_date = col_date(format="%Y-%m-%d"),

    discharged_1_date = col_date(format="%Y-%m-%d"),
    discharged_2_date = col_date(format="%Y-%m-%d"),
    discharged_3_date = col_date(format="%Y-%m-%d"),
    discharged_4_date = col_date(format="%Y-%m-%d"),
    discharged_5_date = col_date(format="%Y-%m-%d"),

    covid_vax_1_date = col_date(format="%Y-%m-%d"),
    covid_vax_2_date = col_date(format="%Y-%m-%d"),
    covid_vax_3_date = col_date(format="%Y-%m-%d"),
    covid_vax_4_date = col_date(format="%Y-%m-%d"),

    covid_vax_pfizer_1_date = col_date(format="%Y-%m-%d"),
    covid_vax_pfizer_2_date = col_date(format="%Y-%m-%d"),
    covid_vax_pfizer_3_date = col_date(format="%Y-%m-%d"),
    covid_vax_pfizer_4_date = col_date(format="%Y-%m-%d"),

    covid_vax_az_1_date = col_date(format="%Y-%m-%d"),
    covid_vax_az_2_date = col_date(format="%Y-%m-%d"),
    covid_vax_az_3_date = col_date(format="%Y-%m-%d"),
    covid_vax_az_4_date = col_date(format="%Y-%m-%d"),

    post_vax_positive_test_date = col_date(format="%Y-%m-%d"),
    post_vax_primary_care_covid_case_date = col_date(format="%Y-%m-%d"),
    post_vax_admitted_date = col_date(format="%Y-%m-%d"),
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
  )) %>%
  arrange(patient_id) %>%
  select(all_of((names(data_extract0))))



##  SECTION TO SORT OUT BAD DUMMY DATA ----
# this rearranges so events are in date order

data_dates_reordered <- data_extract %>%
  select(patient_id, matches("^(.*)_(\\d+)_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", NA),
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
    patient_id, name, date
  ) %>%
  pivot_wider(
    id_cols=c(patient_id),
    names_from=name,
    values_from = date
  )


data_extract_reordered <- left_join(
  data_extract %>% select(-matches("^(.*)_(\\d+)_date")),
  data_dates_reordered,
  by="patient_id"
)




data_processed <- data_extract_reordered %>%
  mutate(

    start_date = as.Date(vars_list$start_date),
    end_date = as.Date(vars_list$end_date),
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

    # ethnicity = fct_case_when(
    #   ethnicity == "4" ~ "Black",
    #   ethnicity == "2" ~ "Mixed",
    #   ethnicity == "3" ~ "South Asian",
    #   ethnicity == "1" ~ "White",
    #   ethnicity == "5" ~ "Other",
    #   #TRUE ~ "Unknown",
    #   TRUE ~ NA_character_
    #
    # ),


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

  ) %>%
  droplevels() %>%
  filter(
    !is.na(age),
    !is.na(sex),
  )



# output processed data to rds ----

dir.create(here::here("output", "data"), showWarnings = FALSE, recursive=TRUE)

write_rds(data_processed, here::here("output", "data", "data_over80s.rds"))







