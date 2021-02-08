

sink(file = "./output/cox.txt", split = FALSE)

# Import libraries ----
library('tidyverse')
library('lubridate')
library('jsonlite')
library('survival')


vars_list = list(
  run_date = date(file.info(here::here("metadata","generate_delivery_cohort.log"))$ctime),
  start_date = "2020-12-07", # change this if you need to
  end_date = "2022-01-13"
)



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
  dplyr::if_else((event_date>censor_date) | is.na(event_date), FALSE, TRUE)
}

tte <- function(origin_date, event_date, censor_date, na.censor=FALSE){
  # returns time to event date or time to censor date, which is earlier

  if (na.censor)
    event_date-origin_date
  else
    pmin(event_date-origin_date, censor_date-origin_date, na.rm=TRUE)
}

# process ----

read_csv(
  here::here("output", "input_doses.csv"),
  n_max=0,
  col_types = cols()
) %>%
names() %>%
print()


data_extract0 <- read_csv(
  here::here("output", "input_doses.csv"),
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
    #ethnicity = col_character(),
    #ethnicity_16 = col_character(),

    # dates

    earliest_positive_test_date = col_date(format="%Y-%m-%d"),
    earliest_primary_care_covid_case_date = col_date(format="%Y-%m-%d"),

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

    covid_vacc_1_date = col_date(format="%Y-%m-%d"),
    covid_vacc_2_date = col_date(format="%Y-%m-%d"),
    covid_vacc_3_date = col_date(format="%Y-%m-%d"),
    covid_vacc_4_date = col_date(format="%Y-%m-%d"),

    covid_vacc_pfizer_1_date = col_date(format="%Y-%m-%d"),
    covid_vacc_pfizer_2_date = col_date(format="%Y-%m-%d"),
    covid_vacc_pfizer_3_date = col_date(format="%Y-%m-%d"),
    covid_vacc_pfizer_4_date = col_date(format="%Y-%m-%d"),

    covid_vacc_oxford_1_date = col_date(format="%Y-%m-%d"),
    covid_vacc_oxford_2_date = col_date(format="%Y-%m-%d"),
    covid_vacc_oxford_3_date = col_date(format="%Y-%m-%d"),
    covid_vacc_oxford_4_date = col_date(format="%Y-%m-%d"),

    post_vaccine_positive_test_date = col_date(format="%Y-%m-%d"),
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
  )) %>%
  arrange(patient_id) %>%
  select(all_of((names(data_extract0))))


data_vaccinated0 <- data_extract %>%
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



##  SECTION TO SORT OUT BAD DUMMY DATA ----
# this rearranges so events are in date order

data_dates_multi <- data_vaccinated0 %>%
  select(patient_id, matches("^(.*)_(\\d+)_date"), -registered_at_latest_date) %>%
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


data_vaccinated<- left_join(
  data_vaccinated0 %>% select(-matches("^(.*)_(\\d+)_date")),
  data_dates_multi,
  by="patient_id"
)




data_baseline <- data_vaccinated %>%
  transmute(
    patient_id,
    age,
    sex,
    imd,
  )


## one-row-per-patient data

data_time <- data_vaccinated %>%
  transmute(
    patient_id,
    age,
    sex,
    imd,

    start_date,
    end_date,
    outcome_date = post_vaccine_positive_test_date, #change here for different outcomes
    censor_date = pmin(outcome_date, death_date, end_date, na.rm=TRUE),

    tte_censor = as.numeric(tte(start_date, censor_date, censor_date)),
    tte_outcome = as.numeric(tte(start_date, outcome_date, censor_date, na.censor=TRUE)),
    tte_outcome_censored = as.numeric(tte(start_date, outcome_date, censor_date, na.censor=FALSE)),
    ind_outcome = censor_indicator(outcome_date, censor_date),

    tte_vax1 = as.numeric(tte(start_date, covid_vacc_1_date, pmin(censor_date, outcome_date, na.rm=TRUE), na.censor=TRUE)),
    tte_vax1_censored = as.numeric(tte(start_date, covid_vacc_1_date, censor_date, na.censor=FALSE)),
    ind_vax1 = censor_indicator(covid_vacc_1_date, pmin(censor_date, outcome_date, na.rm=TRUE)),

    #st_vacc1_inf = if_else(is.na(st_vacc1) | !ind_vacc1, Inf, as.numeric(st_vacc1)),
    #death = tte(start_date, death_date, censor_date, na.censor=TRUE),
  )



print("one-row-per-patient tt()")

coxmod_tt <- coxph(
  Surv(tte_outcome_censored, ind_outcome) ~ tt(tte_vax1_censored) + age + sex + cluster(patient_id),
  data = data_time,
  tt = function(x, t, ...){
    vax_status <- fct_case_when(
       t <= x ~ 'unvaccinated',
      (x < t) & (t <= x+10) ~ '(0,10]',
      (x+10 < t) & (t <= x+21) ~ '(10,21]',
      (x+21 < t) ~ '(21,Inf)',
      TRUE ~ NA_character_
    )
    vax_status
  }
)
summary(coxmod_tt)


## PH model with only time-varying vax, no time-varying coefficients

data_tm0 <- tmerge(
  data1 = data_time %>% select(patient_id, sex, age),
  data2 = data_time,
  id = patient_id,
  vacc1 = tdc(tte_vax1),
  outcome = event(tte_outcome),
  tstop = as.numeric(tte_censor)
) %>%
  group_by(patient_id) #%>%
  #filter(cumsum(lag(outcome, 1, 0)) == 0) #remove any observations after first occurrence of outcome



coxmod_ph <- coxph(
  Surv(tstart, tstop, outcome) ~vacc1 + age + sex + cluster(patient_id),
  data = data_tm0, x=TRUE
)
summary(coxmod_ph)

zp <- cox.zph(coxmod_ph, transform= "km", terms=FALSE)

#plot(zp[1])
# if there's a NA/NAN/Inf warning, then there may be observations in the dataset _after_ the outcome has occurred
# OR...




## use tmerge method

data_tm <- tmerge(
  data1=data_time %>% select(patient_id, sex, age, tte_vax1_censored),
  data2=data_time,
  id=patient_id,
  vacc1 = tdc(tte_vax1),
  vacc2 = tdc(tte_vax1+10),
  vacc3 = tdc(tte_vax1+21),
  outcome = event(tte_outcome),
  tstop = tte_censor
) %>%
group_by(patient_id) %>%
filter(cumsum(lag(outcome, 1, 0)) == 0) %>% #remove any observations after first occurrence of outcome
mutate(
  vacc = vacc1 + vacc2 + vacc3
)

print("mergedata v1, use data")

coxmod_tm1 <- coxph(
  Surv(tstart, tstop, outcome) ~ as.factor(vacc) + age + sex + cluster(patient_id),
  data = data_tm
)
summary(coxmod_tm1)

print("mergedata v2, use tt()")

coxmod_tm2 <- coxph(
  Surv(tstart, tstop, outcome) ~ tt(tte_vax1_censored) + age + sex + cluster(patient_id),
  data = data_tm,
  tt = function(x, t, ...){
    vax_status <- fct_case_when(
      t <= x ~ 'unvaccinated',
      (x < t) & (t <= x+10) ~ '(0,10]',
      (x+10 < t) & (t <= x+21) ~ '(10,21]',
      (x+21 < t) ~ '(21,Inf)',
      TRUE ~ NA_character_
    )
    vax_status
  }
)
summary(coxmod_tm2)


sink()

