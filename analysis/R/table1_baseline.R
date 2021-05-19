
# # # # # # # # # # # # # # # # # # # # #
# This script:
# takes a cohort name as defined in data_define_cohorts.R, and imported as an Arg
# creates descriptive outputs on patient characteristics by vaccination status at 0, 28, and 56 days.
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by one argument,
# 1. the name of the cohort defined in data_define_cohorts.R
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')
library('gt')
library('gtsummary')

## Import custom user functions from lib

source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  delete <- FALSE
} else {
  # use for actions
  cohort <- args[[1]]
  delete <- TRUE
}

## import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
#list2env(gbl_vars, globalenv())


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "data", "list_formula.rds"))
list2env(list_formula, globalenv())


postvaxcuts <- c(0, 7, 14, 21, 28)


# Import metadata for cohort ----

data_cohorts <- read_rds(here::here("output", "data", "data_cohorts.rds"))
metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))

stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))

data_cohorts <- data_cohorts[data_cohorts[[cohort]],]

metadata <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort, ]


## Import processed data ----
data_all <- read_rds(here::here("output", "data", "data_all.rds"))


## choose and name characteristics to print ----

characteristics <- list(
  ageband ~ "Age",
  sex ~ "Sex",
  imd ~ "IMD",
  #region ~ "Region",
  ethnicity_combined ~ "Ethnicity",

  bmi ~ "Body Mass Index",

  heart_failure ~ "Heart failure",
  other_heart_disease ~ "Other heart disease",

  dialysis ~ "Dialysis",
  diabetes ~ "Diabetes",
  chronic_liver_disease ~ "Chronic liver disease",

  current_copd ~ "COPD",
  #cystic_fibrosis ~ "Cystic fibrosis",
  other_resp_conditions ~ "Other respiratory conditions",

  lung_cancer ~ "Lung Cancer",
  haematological_cancer ~ "Haematological cancer",
  cancer_excl_lung_and_haem ~ "Cancer excl. lung, haemo",

  #chemo_or_radio ~ "Chemo- or radio-therapy",
  #solid_organ_transplantation ~ "Solid organ transplant",
  #bone_marrow_transplant ~ "Bone marrow transplant",
  #sickle_cell_disease ~ "Sickle Cell Disease",
  #permanant_immunosuppression ~ "Permanent immunosuppression",
  #temporary_immunosuppression ~ "Temporary Immunosuppression",
  #asplenia ~ "Asplenia",
  #dmards ~ "DMARDS",

  any_immunosuppression ~ "Immunosuppressed",

  dementia ~ "Dementia",
  other_neuro_conditions ~ "Other neurological conditions",

  LD_incl_DS_and_CP ~ "Learning disabilities",
  psychosis_schiz_bipolar ~ "Serious mental illness",

  multimorb ~ "Morbidity count",
  efi_cat ~ "Frailty",

  shielded ~ "Shielding criteria met",

  flu_vaccine ~ "Flu vaccine in previous 5 years"

) %>%
  set_names(., map_chr(., all.vars))

# create pt data ----

data_fixed <- data_all %>%
  filter(
    patient_id %in% data_cohorts$patient_id # take only the patients from defined "cohort"
  ) %>%
  select(
    patient_id,
    age,
    all_of(names(characteristics))
  )

data_tte <- data_all %>%
  filter(
    patient_id %in% data_cohorts$patient_id # take only the patients from defined "cohort"
  ) %>%
  transmute(
    patient_id,

    start_date,
    end_date,

    #composite of death, deregisttration and end date
    lastfup_date = pmin(death_date, end_date, dereg_date, na.rm=TRUE),

    tte_enddate = tte(start_date, end_date, end_date),

    # time to last follow up day
    tte_lastfup = tte(start_date, lastfup_date, lastfup_date),

    # time to deregistration
    tte_dereg = tte(start_date, dereg_date, dereg_date),

    # time to test
    tte_covidtest = tte(start_date, covid_test_1_date, lastfup_date, na.censor=TRUE),

    # time to positive test
    tte_postest = tte(start_date, positive_test_1_date, lastfup_date, na.censor=TRUE),

    # time to admission
    tte_covidadmitted = tte(start_date, covidadmitted_1_date, lastfup_date, na.censor=TRUE),

    #time to covid death
    tte_coviddeath = tte(start_date, coviddeath_date, lastfup_date, na.censor=TRUE),
    tte_noncoviddeath = tte(start_date, noncoviddeath_date, lastfup_date, na.censor=TRUE),

    #time to death
    tte_death = tte(start_date, death_date, lastfup_date, na.censor=TRUE),

    tte_vaxany1 = tte(start_date, covid_vax_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxany2 = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=TRUE),

    ttecensored_vaxany1 = tte(start_date, covid_vax_1_date, lastfup_date, na.censor=FALSE),
    ind_vaxany1 = censor_indicator(covid_vax_1_date, lastfup_date),

    tte_vaxpfizer1 = tte(start_date, covid_vax_pfizer_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxpfizer2 = tte(start_date, covid_vax_pfizer_2_date, lastfup_date, na.censor=TRUE),

    tte_vaxaz1 = tte(start_date, covid_vax_az_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxaz2 = tte(start_date, covid_vax_az_2_date, lastfup_date, na.censor=TRUE),
  )


if(delete) rm(data_all)




# create baseline table ----

# ie, one row per person per snapshot date
data_tab_baseline <- data_fixed %>%
  mutate(
    agecohort = cut(
      age,
      breaks=c(-Inf, 70, 80, Inf),
      labels=c("under 70", "70-79", "80+"),
      right=FALSE
    ),
    ageband = cut(
      age,
      breaks=c(-Inf, 70, 75, 80, 85, 90, 95, Inf),
      labels=c("under 70", "70-74", "75-79", "80-84", "85-89", "90-94", "95+"),
      right=FALSE
    ),
  ) %>%
  droplevels()# %>%
# mutate(across(
#   .cols = where(is.logical),
#   .fns = ~if_else(.x, "yes", "no")
# ))



tab_summary_baseline <- data_tab_baseline %>%
  select(
    any_of(names(characteristics)),
    agecohort,
    age
  ) %>%
  mutate(
    ageband=age
  ) %>% select (-age) %>%
  tbl_summary(
    by=agecohort,
    label=unname(characteristics)
  )  %>%
  modify_footnote(starts_with("stat_") ~ NA)


## create output directories ----
dir.create(here::here("output", cohort, "descr", "tables"), showWarnings = FALSE, recursive=TRUE)

gtsave(as_gt(tab_summary_baseline), here::here("output", cohort, "descr", "tables", "table1_baseline.html"))
