
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

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
} else {
  # use for actions
  cohort <- args[[1]]
}

## import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
#list2env(gbl_vars, globalenv())


## create output directories ----
dir.create(here::here("output", cohort, "descr"), showWarnings = FALSE, recursive=TRUE)


## Import processed data ----


data_fixed <- read_rds(here::here("output", cohort, "data", glue::glue("data_wide_fixed.rds")))

data_cp <- read_rds(here::here("output", cohort, "data", glue::glue("data_cp.rds")))

# create snapshot data ----

## choose snapshot times ----
snapshots <- c(0, 28, 56)

## create snapshop format dataset ----
# ie, one row per person per snapshot date

snapshottimes <- expand(data_cp, patient_id, time=snapshots)

data_ss <- tmerge(
  data1 = data_cp,
  data2 = snapshottimes,
  id = patient_id,
  snapshot = event(time+1)
) %>%
select(-starts_with("tte_"), -ends_with("_date")) %>%
filter(snapshot==1) %>%
mutate(day = tstop-1) %>%
arrange(day, patient_id) %>%
left_join(data_fixed, by = "patient_id")


# create tables ----


## overall ----

library(modelsummary)

data_tab <- data_ss %>%
  mutate(
    date = factor(as.Date(gbl_vars$start_date) + day),
    day = paste0("day ", day),
    vaxany_status=case_when(
      vaxany_status==0 ~ "Not vaccinated",
      vaxany_status==1 ~ "One dose",
      vaxany_status==2 ~ "Two doses",
      TRUE ~ NA_character_
    ),

    ageband = cut(
      age,
      breaks=c(-Inf, 80, 85, 90, 95, Inf),
      labels=c("under 80", "80-84", "85-89", "90-94", "95+"),
      right=FALSE
    ),

    postest_status = postest_status==1,
    covidadmitted_status = covidadmitted_status==1,
    coviddeath_status = coviddeath_status==1,
    death_status = death_status==1,

  ) %>%
  droplevels() %>%
  mutate(across(
    .cols = where(is.logical),
    .fns = ~if_else(.x, "yes", "no")
  ))


data_tab %>%
  datasummary(
    ageband + sex + imd + region + #ethnicity +

      bmi +
      dialysis +
      chronic_cardiac_disease +
      current_copd +
      dementia +
      dialysis +
      solid_organ_transplantation +
      #bone_marrow_transplant,
      chemo_or_radio +
      sickle_cell_disease +
      permanant_immunosuppression +
      temporary_immunosuppression +
      asplenia +
      intel_dis_incl_downs_syndrome +
      psychosis_schiz_bipolar +
      lung_cancer +
      cancer_excl_lung_and_haem +
      haematological_cancer +

      postest_status +
      covidadmitted_status +
      coviddeath_status +
      death_status

    ~ day * vaxany_status *
      ( N + (`%`=Percent(denom="col"))) *
      DropEmpty(which="col"),
    data = .,
    fmt = 1,
    #output = "gt"
    output = here::here("output", cohort, "descr", "table1.md")
  )
#
data_tab %>%
  datasummary(
    ageband + sex + imd + region + #ethnicity +

      bmi +
      dialysis +
      chronic_cardiac_disease +
      current_copd +
      dementia +
      dialysis +
      solid_organ_transplantation +
      #bone_marrow_transplant,
      chemo_or_radio +
      sickle_cell_disease +
      permanant_immunosuppression +
      temporary_immunosuppression +
      asplenia +
      intel_dis_incl_downs_syndrome +
      psychosis_schiz_bipolar +
      lung_cancer +
      cancer_excl_lung_and_haem +
      haematological_cancer +

      Heading("Positive test", nearData=FALSE)*Factor(postest_status) +
      covidadmitted_status +
      coviddeath_status +
      Heading("Death", nearData=TRUE)*death_status

    ~ day * vaxany_status *
      ( N + (`%`=Percent(denom="col"))) *
      DropEmpty(which="col"),
    data = .,
    fmt = 1,
    output = here::here("output", cohort, "descr", "table1.png")
  )
#
#
