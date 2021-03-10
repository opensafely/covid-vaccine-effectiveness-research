
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

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))

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


## Import processed data ----


data_fixed <- read_rds(here::here("output", cohort, "data", glue::glue("data_wide_fixed.rds")))

data_cp <- read_rds(here::here("output", cohort, "data", glue::glue("data_cp.rds")))

# create snapshot data ----

## choose snapshot times ----
snapshot_days <- c(0, 28, 56)

## create snapshop format dataset ----
# ie, one row per person per snapshot date

snapshot_days_expand <- expand(data_cp, patient_id, study_day=snapshot_days)

data_ss <- tmerge(
  data1 = data_cp,
  data2 = snapshot_days_expand,
  id = patient_id,
  snapshot = event(study_day+1)
) %>%
select(-starts_with("tte_"), -ends_with("_date")) %>%
filter(snapshot==1) %>%
mutate(snapshot_day = tstop-1) %>%
arrange(snapshot_day, patient_id) %>%
left_join(data_fixed, by = "patient_id")


# create tables ----


## overall ----



data_tab <- data_ss %>%
  mutate(
    date = factor(as.Date(gbl_vars$start_date) + snapshot_day),
    snapshot_day = paste0("day ", snapshot_day),
    vaxany_status=case_when(
      vaxany_status==0 ~ "Unvaccinated",
      vaxany_status>0 ~ "Vaccinated",
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
    Participants = "1"

  ) %>%
  droplevels()# %>%
 # mutate(across(
 #   .cols = where(is.logical),
 #   .fns = ~if_else(.x, "yes", "no")
 # ))

library('gtsummary')

tab_summary <- data_tab %>% transmute(
  ageband, sex, imd, region, ethnicity,
  bmi,
  dialysis,
  chronic_cardiac_disease,
  current_copd,
  dementia,
  dialysis,
  solid_organ_transplantation,
  #bone_marrow_transplant,
  chemo_or_radio,
  #sickle_cell_disease,
  permanant_immunosuppression,
  #temporary_immunosuppression,
  asplenia,
  intel_dis_incl_downs_syndrome,
  psychosis_schiz_bipolar,
  lung_cancer,
  cancer_excl_lung_and_haem,
  haematological_cancer,
  flu_vaccine,

  postest_status,
  covidadmitted_status,
  coviddeath_status,
  death_status,
  snapshot_day, vaxany_status
) %>%
group_split(snapshot_day) %>%
map(
  ~tbl_summary(
    .x %>% select(-snapshot_day),
    by=vaxany_status,
    label=list(
      ageband ~ "Age",
      sex ~ "Sex",
      imd ~ "IMD",
      region ~ "Region",
      ethnicity ~ "Ethnicity",
      bmi ~ "Body Mass Index",
      dialysis ~ "Dialysis",
      chronic_cardiac_disease ~ "Chronic cardiac disease",
      current_copd ~ "COPD",
      dementia ~ "Dementia",
      solid_organ_transplantation ~ "Solid organ transplant",
      #bone_marrow_transplant ~ "",
      chemo_or_radio ~ "Chemo- or radio-therapy",
      #sickle_cell_disease ~ "",
      permanant_immunosuppression ~ "Permanent Immunosuppression",
      #temporary_immunosuppression ~ "",
      asplenia ~ "Aplenia",
      intel_dis_incl_downs_syndrome ~ "Intellectual disability incl. Downs'",
      psychosis_schiz_bipolar ~ "Psychosis, Schizophrenia, Bipolar",
      lung_cancer ~ "Lung Cancer",
      haematological_cancer ~ "Haemoatological cancer",
      cancer_excl_lung_and_haem ~ "Cancer (excluding lung, haemo)",

      flu_vaccine ~ "Flu vaccine in previous 5 years",

      postest_status ~ "Positive test status",
      covidadmitted_status ~ "Covid-related admission",
      coviddeath_status ~ "Covid-related death",
      death_status ~ "Any death"
    )
  ) %>%
  modify_footnote(starts_with("stat_") ~ NA)
) %>%
tbl_merge(tab_spanner=c("Day 0", "Day 28", "Day 56"))


## create output directories ----
dir.create(here::here("output", cohort, "descr", "tables"), showWarnings = FALSE, recursive=TRUE)

#gt::gtsave(as_gt(tab_summary), here::here("output", cohort, "descr", "tables", "table1.png"))
#gt::gtsave(as_gt(tab_summary), here::here("output", cohort, "descr", "tables", "table1.rtf"))
gt::gtsave(as_gt(tab_summary), here::here("output", cohort, "descr", "tables", "table1.html"))



#library('modelsummary')
# data_tab %>%
#   datasummary(
#     Participants +
#       ageband + sex + imd + region + ethnicity +
#
#       bmi +
#       dialysis +
#       chronic_cardiac_disease +
#       current_copd +
#       dementia +
#       dialysis +
#       solid_organ_transplantation +
#       #bone_marrow_transplant,
#       chemo_or_radio +
#       #sickle_cell_disease +
#       permanant_immunosuppression +
#       #temporary_immunosuppression +
#       asplenia +
#       intel_dis_incl_downs_syndrome +
#       psychosis_schiz_bipolar +
#       lung_cancer +
#       cancer_excl_lung_and_haem +
#       haematological_cancer +
#       flu_vaccine +
#
#       postest_status +
#       covidadmitted_status +
#       coviddeath_status +
#       death_status
#
#     ~ day * vaxany_status *
#       ( N + (`%`=Percent(denom="col"))) *
#       DropEmpty(which="col"),
#     data = .,
#     fmt = 1,
#     #output = "gt"
#     output = here::here("output", cohort, "descr", "table1.md")
#   )
