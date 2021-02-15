
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data
# creates additional survival variables for use in models (eg time to event from study start date)
# fits 3 models for vaccine effectiveness, with 3 different adjustment sets
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "survival_functions.R"))

## create output directories ----
dir.create(here::here("output", "modeldata", "over80s"), showWarnings = FALSE, recursive=TRUE)


## Import processed data ----

data_all <- read_rds(here::here("output", "data", "data_all.rds"))


# Generate different data formats ----

## one-row-per-patient data ----

data_tte_daily <- data_all %>%
  filter(
    age>=80,
    is.na(care_home_type),
    is.na(prior_positive_test_date)
  ) %>%
  transmute(
    patient_id,
    age,
    sex,
    imd,
    #ethnicity,

    chronic_cardiac_disease,
    current_copd,
    dementia,
    dialysis,


    start_date,
    end_date,
    covid_vax_1_date,
    covid_vax_2_date,
    positive_test_1_date,
    coviddeath_date,
    death_date,

    outcome_date = positive_test_1_date, #change here for different outcomes.
    lastfup_date = pmin(death_date, end_date, outcome_date, na.rm=TRUE),

    # consider using tte+0.5 to ensure that outcomes occurring on the same day as the start date or treatment date are dealt with in the correct way
    # -- see section 3.3 of the timedep vignette in survival package
    # not necessary when ties are handled appropriately (eg with tmerge)

    tte_maxfup = tte(start_date, lastfup_date, lastfup_date),
    tte_outcome = tte(start_date, outcome_date, lastfup_date, na.censor=TRUE),
    tte_outcome_censored = tte(start_date, outcome_date, lastfup_date, na.censor=FALSE),
    ind_outcome = censor_indicator(tte_outcome, tte_maxfup),

    tte_vax1 = tte(start_date, covid_vax_1_date, pmin(lastfup_date, covid_vax_2_date, na.rm=TRUE), na.censor=TRUE),
    tte_vax1_Inf = if_else(is.na(tte_vax1), Inf, tte_vax1),
    tte_vax1_censored = tte(start_date, covid_vax_1_date, pmin(lastfup_date, covid_vax_2_date, na.rm=TRUE), na.censor=FALSE),

    tte_vax2 = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=TRUE),
    tte_vax2_Inf = if_else(is.na(tte_vax2), Inf, tte_vax2),
    tte_vax2_censored = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=FALSE),

    ind_vax1 = censor_indicator(tte_vax1, pmin(tte_maxfup, tte_vax2, na.rm=TRUE)),
    ind_vax2 = censor_indicator(tte_vax2, tte_maxfup),

    tte_death = tte(start_date, death_date, end_date, na.censor=TRUE),
  )




## convert time-to-event data from daily to weekly ----

#choose units to discretise time
# 7 = week
# 1 = day (i.e, no change)
round_val <- 7
time_unit <- "week"

# convert
data_tte_rounded <- data_tte_daily %>%
  mutate(
    tte_maxfup = round_tte(tte_maxfup, round_val),
    tte_outcome = round_tte(tte_outcome, round_val),
    tte_outcome_censored = round_tte(tte_outcome_censored, round_val),
    ind_outcome = censor_indicator(tte_outcome, tte_maxfup),

    tte_vax1 = round_tte(tte_vax1, round_val),
    tte_vax1_Inf = if_else(is.na(tte_vax1), Inf, tte_vax1),
    tte_vax1_censored = round_tte(tte_vax1_censored, round_val),

    tte_vax2 = round_tte(tte_vax2, round_val),
    tte_vax2_Inf = if_else(is.na(tte_vax2), Inf, tte_vax2),
    tte_vax2_censored = round_tte(tte_vax2_censored, round_val),

    ind_vax1 = censor_indicator(tte_vax1, pmin(tte_maxfup, tte_vax2, na.rm=TRUE)),
    ind_vax2 = censor_indicator(tte_vax2, tte_maxfup),

    tte_death = round_tte(tte_death, round_val),
  )


## create counting-process format dataset ----
# ie, one row per person per event
# every time an event occurs or a covariate changes, a new row is generated

data_tte_cp <- tmerge(
  data1 = data_tte_rounded %>% select(-starts_with("ind_"), -ends_with("_date")),
  data2 = data_tte_rounded,
  id = patient_id,
  vax1 = tdc(tte_vax1),
  vax2 = tdc(tte_vax2),
  outcome = event(tte_outcome),
  tstop = tte_maxfup
) %>%
arrange(
  patient_id, tstart
) %>%
mutate(
  twidth = tstop - tstart,
  vax_status = vax1+vax2
)

## create person-time format dataset ----
# ie, one row per person per day (or per week or per month)
# this format has lots of redundancy but is necessary for inverse-probability weighting

data_tte_pt <-
  survSplit(
    formula = Surv(tstart, tstop, outcome) ~ .,
    data = data_tte_cp,
    cut = 0:300000 # cut at each time point! 20000 is plenty big enough =~1000*365 years in days
  )


# output data ----

## print data sizes ----
cat(glue::glue("one-row-per-patient data size = ", nrow(data_tte_rounded)))
cat(glue::glue("one-row-per-patient-per-event data size = ", nrow(data_tte_cp)))
cat(glue::glue("one-row-per-patient-per-time-unit data size = ", nrow(data_tte_pt)))


## Save processed tte data ----
write_rds(data_tte_rounded, here::here("output", "modeldata", glue::glue("data_tte_{time_unit}_over80s.rds")))
write_rds(data_tte_cp, here::here("output", "modeldata", glue::glue("data_tte_{time_unit}_cp_over80s.rds")))
write_rds(data_tte_pt, here::here("output", "modeldata", glue::glue("data_tte_{time_unit}_pt_over80s.rds")))

