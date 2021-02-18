
# # # # # # # # # # # # # # # # # # # # #
# This script:
# takes a cohort name as defined in data_define_cohorts.R, and imported as an Arg
# creates 3 datasets for that cohort:
# 1 is one row per patient (wide format)
# 2 is one row per patient per event (eg `stset` format, where a new row is created everytime an event occurs or a covariate changes)
# 3 is one row per patient per day
# creates additional survival variables for use in models (eg time to event from study start date)
#
# The script should only be run via an action in the project.yaml only
# The script must be accompanied by one argument, the name of the cohort defined in data_define_cohorts.R
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
}

cohort <- args[[1]]



## create output directories ----
dir.create(here::here("output", "modeldata"), showWarnings = FALSE, recursive=TRUE)

# Import processed data ----


data_cohorts <- read_rds(here::here("output", "modeldata", "data_cohorts.rds"))
metadata_cohorts <- read_rds(here::here("output", "modeldata", "metadata_cohorts.rds"))
data_all <- read_rds(here::here("output", "data", "data_all.rds"))

stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))

data_cohorts <- data_cohorts[data_cohorts[[cohort]],]
metadata_cohorts <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort,]


# Generate different data formats ----

## one-row-per-patient data ----

data_tte <- data_all %>%
  filter(
    patient_id %in% data_cohorts$patient_id # take only the patients from "cohort"
  ) %>%
  transmute(
    patient_id,
    age,
    sex,
    imd,
    #ethnicity,

    region,

    chronic_cardiac_disease,
    current_copd,
    dementia,
    dialysis,
    solid_organ_transplantation,
    #bone_marrow_transplant,
    chemo_or_radio,
    sickle_cell_disease,
    permanant_immunosuppression,
    temporary_immunosuppression,
    asplenia,
    intel_dis_incl_downs_syndrome,
    psychosis_schiz_bipolar,
    lung_cancer,
    cancer_excl_lung_and_haem,
    haematological_cancer,

    start_date,
    end_date,

    covid_vax_1_date,
    covid_vax_2_date,
    covid_vax_pfizer_1_date,
    covid_vax_pfizer_2_date,
    covid_vax_az_1_date,
    covid_vax_az_2_date,

    positive_test_1_date,
    covidadmitted_1_date,
    coviddeath_date,
    death_date,

    outcome_date = positive_test_1_date, #change here for different outcomes.
    lastfup_date = pmin(death_date, end_date, outcome_date, na.rm=TRUE),

    # consider using tte+0.5 to ensure that outcomes occurring on the same day as the start date or treatment date are dealt with in the correct way
    # -- see section 3.3 of the timedep vignette in survival package
    # not necessary when ties are handled appropriately (eg with tmerge)

    tte_vax_maxfup = tte(start_date, lastfup_date, lastfup_date),

    tte_outcome = tte(start_date, outcome_date, lastfup_date, na.censor=TRUE),
    tte_outcome_censored = tte(start_date, outcome_date, lastfup_date, na.censor=FALSE),
    ind_outcome = censor_indicator(tte_outcome, tte_vax_maxfup),


    tte_vax1 = tte(start_date, covid_vax_1_date, lastfup_date, na.censor=TRUE),
    tte_vax1_Inf = if_else(is.na(tte_vax1), Inf, tte_vax1),
    tte_vax1_censored = tte(start_date, covid_vax_1_date, lastfup_date, na.censor=FALSE),

    tte_vax2 = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=TRUE),
    tte_vax2_Inf = if_else(is.na(tte_vax2), Inf, tte_vax2),
    tte_vax2_censored = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=FALSE),

    tte_vaxpfizer1 = tte(start_date, covid_vax_pfizer_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxpfizer1_Inf = if_else(is.na(tte_vaxpfizer1), Inf, tte_vaxpfizer1),
    tte_vaxpfizer1_censored = tte(start_date, covid_vax_pfizer_1_date, lastfup_date, na.censor=FALSE),

    tte_vaxpfizer2 = tte(start_date, covid_vax_pfizer_2_date, lastfup_date, na.censor=TRUE),
    tte_vaxpfizer2_Inf = if_else(is.na(tte_vaxpfizer2), Inf, tte_vaxpfizer2),
    tte_vaxpfizer2_censored = tte(start_date, covid_vax_pfizer_2_date,  lastfup_date, na.censor=FALSE),

    tte_vaxaz1 = tte(start_date, covid_vax_az_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxaz1_Inf = if_else(is.na(tte_vaxaz1), Inf, tte_vaxaz1),
    tte_vaxaz1_censored = tte(start_date, covid_vax_az_1_date, lastfup_date, na.censor=FALSE),

    tte_vaxaz2 = tte(start_date, covid_vax_az_2_date, lastfup_date, na.censor=TRUE),
    tte_vaxaz2_Inf = if_else(is.na(tte_vaxaz2), Inf, tte_vaxaz2),
    tte_vaxaz2_censored = tte(start_date, covid_vax_az_2_date,  lastfup_date, na.censor=FALSE),

    ind_vax1 = censor_indicator(tte_vax1, tte_vax_maxfup),
    ind_vax2 = censor_indicator(tte_vax2, tte_vax_maxfup),

    ind_vaxpfizer1 = censor_indicator(tte_vaxpfizer1, tte_vax_maxfup),
    ind_vaxpfizer2 = censor_indicator(tte_vaxpfizer2, tte_vax_maxfup),

    ind_vaxaz1 = censor_indicator(tte_vaxaz1, tte_vax_maxfup),
    ind_vaxaz2 = censor_indicator(tte_vaxaz2, tte_vax_maxfup),

    tte_death = tte(start_date, death_date, end_date, na.censor=TRUE),
  )

## print dataset size ----
cat(glue::glue("one-row-per-patient data size = ", nrow(data_tte)), "\n  ")


## convert time-to-event data from daily to weekly ----
## not currently needed as daily data runs fairly quickly

#choose units to discretise time
# 1 = day (i.e, no change)
# 7 = week
# round_val <- 1
# time_unit <- "day"
#
# # convert
# data_tte_rounded <- data_tte_daily %>%
#   mutate(
#     tte_maxfup = round_tte(tte_maxfup, round_val),
#     tte_outcome = round_tte(tte_outcome, round_val),
#     tte_outcome_censored = round_tte(tte_outcome_censored, round_val),
#     ind_outcome = censor_indicator(tte_outcome, tte_maxfup),
#
#     tte_vax1 = round_tte(tte_vax1, round_val),
#     tte_vax1_Inf = if_else(is.na(tte_vax1), Inf, tte_vax1),
#     tte_vax1_censored = round_tte(tte_vax1_censored, round_val),
#
#     tte_vax2 = round_tte(tte_vax2, round_val),
#     tte_vax2_Inf = if_else(is.na(tte_vax2), Inf, tte_vax2),
#     tte_vax2_censored = round_tte(tte_vax2_censored, round_val),
#
#     ind_vax1 = censor_indicator(tte_vax1, pmin(tte_maxfup, tte_vax2, na.rm=TRUE)),
#     ind_vax2 = censor_indicator(tte_vax2, tte_maxfup),
#
#     tte_death = round_tte(tte_death, round_val),
#   )


## create counting-process format dataset ----
# ie, one row per person per event
# every time an event occurs or a covariate changes, a new row is generated


data_tte_cp0 <- tmerge(
  data1 = data_tte %>% select(-starts_with("ind_"), -ends_with("_date")),
  data2 = data_tte,
  id = patient_id,

  vax1 = tdc(tte_vax1),
  vax2 = tdc(tte_vax2),
  timesincevax1 = cumtdc(tte_vax1),
  timesincevax2 = cumtdc(tte_vax2),

  vaxpfizer1 = tdc(tte_vaxpfizer1),
  vaxpfizer2 = tdc(tte_vaxpfizer2),
  timesincevaxpfizer1 = cumtdc(tte_vaxpfizer1),
  timesincevaxpfizer2 = cumtdc(tte_vaxpfizer2),

  vaxaz1 = tdc(tte_vaxaz1),
  vaxaz2 = tdc(tte_vaxaz2),
  timesincevaxaz1 = cumtdc(tte_vaxaz1),
  timesincevaxaz2 = cumtdc(tte_vaxaz2),

  outcome = event(tte_outcome),
  tstop = tte_vax_maxfup
)

stopifnot("tstart should be  >= 0 in data_tte_cp0" = data_tte_cp0$tstart>=0)
stopifnot("tstop - tstart should be strictly > 0 in data_tte_cp0" = data_tte_cp0$tstop - data_tte_cp0$tstart > 0)

# import hospitalisations data for time-updating "in-hospital" covariate
data_hospitalised <- read_rds(here::here("output", "data", "data_long_admission_dates.rds")) %>%
  pivot_longer(
    cols=c(admitted_date, discharged_date),
    names_to="status",
    values_to="date",
    values_drop_na = TRUE
  ) %>%
  inner_join(
    data_tte %>% select(patient_id, start_date, lastfup_date),
    .,
    by =c("patient_id")
  ) %>%
  mutate(
    tte = tte(start_date, date, lastfup_date, na.censor=TRUE),
    hosp_status = if_else(status=="admitted_date", 1, 0)
  )

data_tte_cp <- tmerge(
  data1 = data_tte_cp0,
  data2 = data_hospitalised,
  id = patient_id,
  hospital_status = tdc(tte, hosp_status),
  options = list(tdcstart = 0)
) %>%
arrange(
  patient_id, tstart
) %>%
mutate(
  twidth = tstop - tstart,
  vax_status = vax1 + vax2,
  vaxpfizer_status = vaxpfizer1 + vaxpfizer2,
  vaxaz_status = vaxaz1 + vaxaz2,
)

stopifnot("tstart should be  >= 0 in data_tte_cp" = data_tte_cp$tstart>=0)
stopifnot("tstop - tstart should be strictly > 0 in data_tte_cp" = data_tte_cp$tstop - data_tte_cp$tstart > 0)

### print dataset size ----
cat(glue::glue("one-row-per-patient-per-event data size = ", nrow(data_tte_cp)), "\n  ")


## create person-time format dataset ----
# ie, one row per person per day (or per week or per month)
# this format has lots of redundancy but is necessary for MSMs

data_tte_pt <-
  survSplit(
    formula = Surv(tstart, tstop, outcome) ~ .,
    data = data_tte_cp,
    cut = 0:300000 # cut at each time point! 300000 is plenty big enough =~1000*365 years in days
  ) %>%
  arrange(patient_id, tstart) %>%
  group_by(patient_id) %>%
  mutate(

    # so we can select all time-points where patient is at risk of vax AND vax has not occurred
    vax_history = lag(vax_status, 1, 0),
    vaxpfizer_history = lag(vaxpfizer_status, 1, 0),
    vaxaz_history = lag(vaxaz_status, 1, 0),

    # define time since vaccination
    timesincevax1 = cumsum(vax1),
    timesincevax2 = cumsum(vax2),
    timesincevaxpfizer1 = cumsum(vaxpfizer1),
    timesincevaxpfizer2 = cumsum(vaxpfizer2),
    timesincevaxaz1 = cumsum(vaxaz1),
    timesincevaxaz2 = cumsum(vaxaz2),
  ) %>%
  ungroup()


### print dataset size ----
cat(glue::glue("one-row-per-patient-per-time-unit data size = ", nrow(data_tte_pt)), "\n  ")

## Save processed tte data ----
write_rds(data_tte, here::here("output", "modeldata", glue::glue("data_wide_{cohort}.rds")))
write_rds(data_tte_cp, here::here("output", "modeldata", glue::glue("data_cp_{cohort}.rds")))
write_rds(data_tte_pt, here::here("output", "modeldata", glue::glue("data_pt_{cohort}.rds")))

