
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
library('survival')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
} else{
  cohort <- args[[1]]
}

## create output directories ----
dir.create(here::here("output", cohort, "data"), showWarnings = FALSE, recursive=TRUE)

# Import processed data ----


data_cohorts <- read_rds(here::here("output", "data", "data_cohorts.rds"))
metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
data_all <- read_rds(here::here("output", "data", "data_all.rds"))

stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))

data_cohorts <- data_cohorts[data_cohorts[[cohort]],]
metadata <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort, ][1,]


# Generate different data formats ----

## one-row-per-patient data ----

data_fixed <- data_all %>%
  filter(
    patient_id %in% data_cohorts$patient_id # take only the patients from defined "cohort"
  ) %>%
  transmute(
    patient_id,
    age,
    ageband,
    sex,
    imd,
    #ethnicity,

    region,

    bmi,
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
  )


## print dataset size ----
cat(glue::glue("one-row-per-patient (time-independent) data size = ", nrow(data_fixed)), "\n  ")
cat(glue::glue("memory usage = ", format(object.size(data_fixed), units="GB", standard="SI")))

data_tte <- data_all  %>%
  filter(
    patient_id %in% data_cohorts$patient_id # take only the patients from defined "cohort"
  ) %>%
  transmute(
    patient_id,

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

    #outcome_date = positive_test_1_date, #change here for different outcomes.
    #outcome_date = .[[metadata[["outcome_var"]]]],
    lastfup_date = pmin(death_date, end_date, na.rm=TRUE),

    tte_enddate = tte(start_date, end_date, end_date),

    # consider using tte+0.5 to ensure that outcomes occurring on the same day as the start date or treatment date are dealt with in the correct way
    # -- see section 3.3 of the timedep vignette in survival package
    # not necessary when ties are handled appropriately (eg with tmerge)

    # time to last follow up day
    tte_lastfup = tte(start_date, lastfup_date, lastfup_date),

    # time to outcome
    #tte_outcome = tte(start_date, outcome_date, lastfup_date, na.censor=TRUE),
    #tte_outcome_Inf = if_else(is.na(tte_outcome), Inf, tte_outcome),
    #tte_outcome_censored = tte(start_date, outcome_date, lastfup_date, na.censor=FALSE),
    #ind_outcome = censor_indicator(tte_outcome, tte_lastfup),

    # time to test
    #tte_test = tte(start_date, test_1_date, lastfup_date, na.censor=TRUE),
    #tte_test_Inf = if_else(is.na(tte_test), Inf, tte_test),
    #tte_test_censored = tte(start_date, test_1_date, lastfup_date, na.censor=FALSE),
    #ind_test = censor_indicator(tte_test, tte_lastfup),

    # time to positive test
    tte_postest = tte(start_date, positive_test_1_date, lastfup_date, na.censor=TRUE),
    #tte_postest_Inf = if_else(is.na(tte_postest), Inf, tte_postest),
    #tte_postest_censored = tte(start_date, positive_test_1_date, lastfup_date, na.censor=FALSE),
    #ind_postest = censor_indicator(tte_postest, tte_lastfup),

    # time to test
    tte_covidadmitted = tte(start_date, covidadmitted_1_date, lastfup_date, na.censor=TRUE),
    #tte_covidadmitted_Inf = if_else(is.na(tte_covidadmitted), Inf, tte_covidadmitted),
    #tte_covidadmitted_censored = tte(start_date, covidadmitted_1_date, lastfup_date, na.censor=FALSE),
    #ind_covidadmitted = censor_indicator(tte_covidadmitted, tte_lastfup),

    #time to covid death
    tte_coviddeath = tte(start_date, coviddeath_date, lastfup_date, na.censor=TRUE),

    #time to death
    tte_death = tte(start_date, death_date, lastfup_date, na.censor=TRUE),

    tte_vaxany1 = tte(start_date, covid_vax_1_date, lastfup_date, na.censor=TRUE),
    #tte_vax1_Inf = if_else(is.na(tte_vax1), Inf, tte_vax1),
    #tte_vax1_censored = tte(start_date, covid_vax_1_date, lastfup_date, na.censor=FALSE),
    #ind_vax1 = censor_indicator(tte_vax1, tte_lastfup),

    tte_vaxany2 = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=TRUE),
    #tte_vax2_Inf = if_else(is.na(tte_vax2), Inf, tte_vax2),
    #tte_vax2_censored = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=FALSE),
    #ind_vax2 = censor_indicator(tte_vax2, tte_lastfup),

    tte_vaxpfizer1 = tte(start_date, covid_vax_pfizer_1_date, lastfup_date, na.censor=TRUE),
    #tte_vaxpfizer1_Inf = if_else(is.na(tte_vaxpfizer1), Inf, tte_vaxpfizer1),
    #tte_vaxpfizer1_censored = tte(start_date, covid_vax_pfizer_1_date, lastfup_date, na.censor=FALSE),
    #ind_vaxpfizer1 = censor_indicator(tte_vaxpfizer1, tte_lastfup),

    tte_vaxpfizer2 = tte(start_date, covid_vax_pfizer_2_date, lastfup_date, na.censor=TRUE),
    #tte_vaxpfizer2_Inf = if_else(is.na(tte_vaxpfizer2), Inf, tte_vaxpfizer2),
    #tte_vaxpfizer2_censored = tte(start_date, covid_vax_pfizer_2_date,  lastfup_date, na.censor=FALSE),
    #ind_vaxpfizer2 = censor_indicator(tte_vaxpfizer2, tte_lastfup),

    tte_vaxaz1 = tte(start_date, covid_vax_az_1_date, lastfup_date, na.censor=TRUE),
    #tte_vaxaz1_Inf = if_else(is.na(tte_vaxaz1), Inf, tte_vaxaz1),
    #tte_vaxaz1_censored = tte(start_date, covid_vax_az_1_date, lastfup_date, na.censor=FALSE),
    #ind_vaxaz1 = censor_indicator(tte_vaxaz1, tte_lastfup),

    tte_vaxaz2 = tte(start_date, covid_vax_az_2_date, lastfup_date, na.censor=TRUE),
    #tte_vaxaz2_Inf = if_else(is.na(tte_vaxaz2), Inf, tte_vaxaz2),
    #tte_vaxaz2_censored = tte(start_date, covid_vax_az_2_date,  lastfup_date, na.censor=FALSE),
    #ind_vaxaz2 = censor_indicator(tte_vaxaz2, tte_lastfup),


  )

stopifnot("vax1 time should not be same as vax2 time" = all(data_tte$tte_vaxany1 != data_tte$tte_vaxany2, na.rm=TRUE))

## print dataset size ----
cat(glue::glue("one-row-per-patient (tte) data size = ", nrow(data_tte)), "\n  ")
cat(glue::glue("memory usage = ", format(object.size(data_tte), units="GB", standard="SI")))

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

# initial call based on events and vaccination status
data_tte_cp0 <- tmerge(
  data1 = data_tte %>% select(-starts_with("ind_"), -ends_with("_date")),
  data2 = data_tte,
  id = patient_id,

  vaxany1_status = tdc(tte_vaxany1),
  vaxany2_status = tdc(tte_vaxany2),

  vaxpfizer1_status = tdc(tte_vaxpfizer1),
  vaxpfizer2_status = tdc(tte_vaxpfizer2),

  vaxaz1_status = tdc(tte_vaxaz1),
  vaxaz2_status = tdc(tte_vaxaz2),

  postest_status = tdc(tte_postest),
  covidadmitted_status = tdc(tte_covidadmitted),
  coviddeath_status = tdc(tte_coviddeath),
  death_status = tdc(tte_death),

  censored_status = tdc(tte_lastfup),

  vaxany1 = event(tte_vaxany1),
  vaxany2 = event(tte_vaxany2),
  vaxpfizer1 = event(tte_vaxpfizer1),
  vaxpfizer2 = event(tte_vaxpfizer2),
  vaxaz1 = event(tte_vaxaz1),
  vaxaz2 = event(tte_vaxaz2),
  postest = event(tte_postest),
  covidadmitted = event(tte_covidadmitted),
  coviddeath = event(tte_coviddeath),
  death = event(tte_death),
  censored = event(tte_lastfup),

  tstop = tte_enddate
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


data_probable_covid <- read_rds(here::here("output", "data", "data_long_pr_probable_covid_dates.rds")) %>%
  select(-date) %>%
  pivot_longer(
    cols=c(date_5before, date_10after),
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
    probable_covid_status = if_else(status=="date_5before", 1, 0)
  )

data_suspected_covid <- read_rds(here::here("output", "data", "data_long_pr_suspected_covid_dates.rds")) %>%
  select(-date) %>%
  pivot_longer(
    cols=c(date_5before, date_10after),
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
    suspected_covid_status = if_else(status=="date_5before", 1, 0)
  )

## Use follow option when fast option available for processing "X days around event date" for pt dataset

# data_probable_covid <- read_rds(here::here("output", "data", "data_long_pr_probable_covid_dates.rds")) %>%
#   inner_join(
#     data_tte %>% select(patient_id, start_date, lastfup_date),
#     .,
#     by =c("patient_id")
#   ) %>%
#   mutate(
#     tte = tte(start_date, date, lastfup_date, na.censor=TRUE)
#   )
#
#
# data_suspected_covid <- read_rds(here::here("output", "data", "data_long_pr_suspected_covid_dates.rds")) %>%
#   inner_join(
#     data_tte %>% select(patient_id, start_date, lastfup_date),
#     .,
#     by =c("patient_id")
#   ) %>%
#   mutate(
#     tte = tte(start_date, date, lastfup_date, na.censor=TRUE)
#   )


data_tte_cp <- data_tte_cp0 %>%
  tmerge(
    data1 = .,
    data2 = data_hospitalised,
    id = patient_id,
    hospital_status = tdc(tte, hosp_status),
    options = list(tdcstart = 0)
  ) %>%
  tmerge(
    data1 = .,
    data2 = data_probable_covid,
    id = patient_id,
    probable_covid_status = tdc(tte, probable_covid_status),
    options = list(tdcstart = 0)
  ) %>%
  tmerge(
    data1 = .,
    data2 = data_suspected_covid,
    id = patient_id,
    suspected_covid_status = tdc(tte, suspected_covid_status),
    options = list(tdcstart = 0)
  ) %>%
  # use this option when event date is enough and rolling indicator available
  # tmerge(
  #   data1 = .,
  #   data2 = data_probable_covid,
  #   id = patient_id,
  #   probable_covid = event(tte)
  # ) %>%
  # tmerge(
  #   data1 = .,
  #   data2 = data_suspected_covid,
  #   id = patient_id,
  #   probable_covid = event(tte)
  # ) %>%
arrange(
  patient_id, tstart
) %>%
mutate(
  twidth = tstop - tstart,
  vaxany_status = vaxany1_status + vaxany2_status,
  vaxpfizer_status = vaxpfizer1_status + vaxpfizer2_status,
  vaxaz_status = vaxaz1_status + vaxaz2_status,
)

# free up memory
rm(data_tte_cp0)
rm(data_hospitalised)
rm(data_suspected_covid)
rm(data_probable_covid)


stopifnot("tstart should be >= 0 in data_tte_cp" = data_tte_cp$tstart>=0)
stopifnot("tstop - tstart should be strictly > 0 in data_tte_cp" = data_tte_cp$tstop - data_tte_cp$tstart > 0)

### print dataset size ----
cat(glue::glue("one-row-per-patient-per-event data size = ", nrow(data_tte_cp)), "\n  ")
cat(glue::glue("memory usage = ", format(object.size(data_tte_cp), units="GB", standard="SI")))

## create person-time format dataset ----
# ie, one row per person per day (or per week or per month)
# this format has lots of redundancy but is necessary for MSMs

alltimes <- expand(data_tte, patient_id, times=full_seq(c(1, tte_enddate),1))

# do not use survSplit as this doesn't handle multiple events properly
# eg, a positive test will be expanded as if a tdc (eg c(0,0,1,1,1,..)) not an event (eg c(0,0,1,0,0,...))
# also, survSplit is slower!
data_tte_pt <- tmerge(
  data1 = data_tte_cp,
  data2 = alltimes,
  id = patient_id,
  alltimes = event(times, times)
) %>%
  arrange(patient_id, tstart) %>%
  group_by(patient_id) %>%
  mutate(

    # define time since vaccination
    timesincevaxany1 = cumsum(vaxany1_status),
    timesincevaxany2 = cumsum(vaxany2_status),
    timesincevaxpfizer1 = cumsum(vaxpfizer1_status),
    timesincevaxpfizer2 = cumsum(vaxpfizer2_status),
    timesincevaxaz1 = cumsum(vaxaz1_status),
    timesincevaxaz2 = cumsum(vaxaz2_status),
  ) %>%
  ungroup()

stopifnot("dummy 'alltimes' should be equal to tstop" = all(data_tte_pt$alltimes == data_tte_pt$tstop))


# remove unused columns
data_tte_pt <- data_tte_pt %>%
  select(
    -starts_with("tte_"),
    -ends_with("_date")
  )

### print dataset size ----
cat(glue::glue("one-row-per-patient-per-time-unit data size = ", nrow(data_tte_pt)), "\n  ")
cat(glue::glue("memory usage = ", format(object.size(data_tte_pt), units="GB", standard="SI")), "\n  ")

## Save processed tte data ----
write_rds(data_fixed, here::here("output", cohort, "data", glue::glue("data_wide_fixed.rds")), compress="gz")
write_rds(data_tte, here::here("output", cohort, "data", glue::glue("data_wide_tte.rds")), compress="gz")
write_rds(data_tte_cp, here::here("output", cohort, "data", glue::glue("data_cp.rds")), compress="gz")
write_rds(data_tte_pt, here::here("output", cohort, "data", glue::glue("data_pt.rds")), compress="gz")

