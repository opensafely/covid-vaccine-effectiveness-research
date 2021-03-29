
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
#data_cp <- read_rds(here::here("output", cohort, "data", glue::glue("data_cp.rds")))
data_pt <- read_rds(here::here("output", cohort, "data", glue::glue("data_pt.rds")))

# create snapshot data ----

## choose snapshot times ----
snapshot_days <- c(0, 28, 56)

## create snapshop format dataset ----
# ie, one row per person per snapshot date
data_ss <- data_pt %>%
  filter(tstart %in% snapshot_days) %>%
  mutate(snapshot_day = tstart) %>%
  arrange(snapshot_day, patient_id) %>%
  left_join(data_fixed, by = "patient_id")


# create tables ----


data_tab <- data_ss %>%
  mutate(
    date = factor(as.Date(gbl_vars$start_date) + snapshot_day),
    snapshot_day = paste0("day ", snapshot_day),
    vaxany_status=fct_case_when(
      timesincevaxany1<=0 ~ "Unvaccinated",
      timesincevaxany1>0 ~ "Vaccinated",
      TRUE ~ NA_character_
    ),

    ageband = cut(
      age,
      breaks=c(-Inf, 70, 75, 80, 85, 90, 95, Inf),
      labels=c("under 70", "70-74", "75-79", "80-84", "85-89", "90-94", "95+"),
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



tab_summary <- data_tab %>% transmute(
  ageband, sex, imd, region, ethnicity,
  bmi,

  chronic_cardiac_disease,
  heart_failure,
  other_heart_disease,

  dialysis,
  diabetes,
  chronic_liver_disease,

  current_copd,
  cystic_fibrosis,
  other_resp_conditions,

  lung_cancer,
  haematological_cancer,
  cancer_excl_lung_and_haem,

  chemo_or_radio,
  solid_organ_transplantation,
  #bone_marrow_transplant,
  #sickle_cell_disease,
  permanant_immunosuppression,
  #temporary_immunosuppression,
  asplenia,
  dmards,

  dementia,
  other_neuro_conditions,
  LD_incl_DS_and_CP,
  psychosis_schiz_bipolar,
  flu_vaccine,

  snapshot_day, vaxany_status
) %>%
group_split(snapshot_day) %>%
map(
  ~tbl_summary(
    .x %>% mutate(vaxany_status=droplevels(vaxany_status)) %>% select(-snapshot_day),
    by=vaxany_status,
    label=list(
      ageband ~ "Age",
      sex ~ "Sex",
      imd ~ "IMD",
      region ~ "Region",
      ethnicity ~ "Ethnicity",

      bmi ~ "Body Mass Index",

      chronic_cardiac_disease ~ "Chronic cardiac disease",
      heart_failure ~ "Heart failure",
      other_heart_disease ~ "Other heart disease",

      dialysis ~ "Dialysis",
      diabetes ~ "Diabetes",
      chronic_liver_disease ~ "Chronic liver disease",

      current_copd ~ "COPD",

      cystic_fibrosis ~ "Cystic fibrosis",
      other_resp_conditions ~ "Other respiratory conditions",
      lung_cancer ~ "Lung Cancer",
      haematological_cancer ~ "Haematological cancer",
      cancer_excl_lung_and_haem ~ "Cancer excl. lung, haemo",

      chemo_or_radio ~ "Chemo- or radio-therapy",
      solid_organ_transplantation ~ "Solid organ transplant",
      #bone_marrow_transplant ~ "Bone marrow transplant",
      #sickle_cell_disease ~ "Sickle Cell Disease",
      permanant_immunosuppression ~ "Permanent immunosuppression",
      #temporary_immunosuppression ~ "Temporary Immunosuppression",
      asplenia ~ "Asplenia",
      dmards ~ "DMARDS",

      dementia ~ "Dementia",
      other_neuro_conditions ~ "Other neurological conditions",

      LD_incl_DS_and_CP ~ "Learning disability incl. DS and CP",
      psychosis_schiz_bipolar ~ "Psychosis, Schizophrenia, Bipolar",

      flu_vaccine ~ "Flu vaccine in previous 5 years"

    )
  ) %>%
  modify_footnote(starts_with("stat_") ~ NA)
) %>%
tbl_merge(tab_spanner=c("Day 0", "Day 28", "Day 56"))


## create output directories ----
dir.create(here::here("output", cohort, "descr", "tables"), showWarnings = FALSE, recursive=TRUE)

#gt::gtsave(as_gt(tab_summary), here::here("output", cohort, "descr", "tables", "table1.png"))
#gt::gtsave(as_gt(tab_summary), here::here("output", cohort, "descr", "tables", "table1.rtf"))
gtsave(as_gt(tab_summary), here::here("output", cohort, "descr", "tables", "table1.html"))



## create person-time table ----



pt_summary_total <- data_pt %>%
  summarise(
    postest_yearsatrisk=sum(postest_status==0)/365.25,
    postest_n=sum(postest),
    postest_rate=postest_n/postest_yearsatrisk,

    covidadmitted_yearsatrisk=sum(covidadmitted_status==0)/365.25,
    covidadmitted_n=sum(covidadmitted),
    covidadmitted_rate=covidadmitted_n/covidadmitted_yearsatrisk,

    coviddeath_yearsatrisk=sum(coviddeath_status==0)/365.25,
    coviddeath_n=sum(coviddeath),
    coviddeath_rate=coviddeath_n/coviddeath_yearsatrisk,

    noncoviddeath_yearsatrisk=sum(noncoviddeath_status==0)/365.25,
    noncoviddeath_n=sum(noncoviddeath),
    noncoviddeath_rate=noncoviddeath_n/noncoviddeath_yearsatrisk,

    death_yearsatrisk=sum(death_status==0)/365.25,
    death_n=sum(death),
    death_rate=death_n/death_yearsatrisk,
  )

pt_summary <- function(data, timesince, postvaxcuts){

  unredacted <- data %>%
  mutate(
    timesincevax = data[[timesince]],
    timesincevax_pw = timesince_cut(timesincevax, postvaxcuts, "Unvaccinated"),
  ) %>%
  group_by(timesincevax_pw) %>%
  summarise(
    postest_yearsatrisk=sum(postest_status==0)/365.25,
    postest_n=sum(postest),
    postest_rate=postest_n/postest_yearsatrisk,

    covidadmitted_yearsatrisk=sum(covidadmitted_status==0)/365.25,
    covidadmitted_n=sum(covidadmitted),
    covidadmitted_rate=covidadmitted_n/covidadmitted_yearsatrisk,

    coviddeath_yearsatrisk=sum(coviddeath_status==0)/365.25,
    coviddeath_n=sum(coviddeath),
    coviddeath_rate=coviddeath_n/coviddeath_yearsatrisk,

    noncoviddeath_yearsatrisk=sum(noncoviddeath_status==0)/365.25,
    noncoviddeath_n=sum(noncoviddeath),
    noncoviddeath_rate=noncoviddeath_n/noncoviddeath_yearsatrisk,

    death_yearsatrisk=sum(death_status==0)/365.25,
    death_n=sum(death),
    death_rate=death_n/death_yearsatrisk,
  ) %>%
  ungroup()

  redacted <- unredacted %>%
    mutate(
      postest_rate = redactor2(postest_n, 5, postest_rate),
      covidadmitted_rate = redactor2(covidadmitted_n, 5, covidadmitted_rate),
      coviddeath_rate = redactor2(coviddeath_n, 5, coviddeath_rate),
      noncoviddeath_rate = redactor2(noncoviddeath_n, 5, noncoviddeath_rate),
      death_rate = redactor2(death_n, 5, death_rate),

      postest_n = redactor2(postest_n, 5),
      covidadmitted_n = redactor2(covidadmitted_n, 5),
      coviddeath_n = redactor2(coviddeath_n, 5),
      noncoviddeath_n = redactor2(noncoviddeath_n, 5),
      death_n = redactor2(death_n, 5)
    )

  redacted
}

postvaxcuts <- c(0, 1, 4, 7, 14, 21)

pt_summary_any <- pt_summary(data_pt, "timesincevaxany1", postvaxcuts)
pt_summary_pfizer <- pt_summary(data_pt, "timesincevaxpfizer1", postvaxcuts)
pt_summary_az <- pt_summary(data_pt, "timesincevaxaz1", postvaxcuts)

pt_tab_summary <- pt_summary_any %>%
  gt() %>%
   cols_label(
     timesincevax_pw = "Time since first dose",

     postest_yearsatrisk = "Person-years at risk",
     covidadmitted_yearsatrisk = "Person-years at risk",
     coviddeath_yearsatrisk = "Person-years at risk",
     noncoviddeath_yearsatrisk = "Person-years at risk",
     death_yearsatrisk = "Person-years at risk",

     postest_n = "Events",
     covidadmitted_n = "Events",
     coviddeath_n = "Events",
     noncoviddeath_n = "Events",
     death_n = "Events",

     postest_rate = "Rate/year",
     covidadmitted_rate = "Rate/year",
     coviddeath_rate = "Rate/year",
     noncoviddeath_rate = "Rate/year",
     death_rate = "Rate/year"
   ) %>%
  tab_spanner(
    label = "Positive test",
    columns = starts_with("postest")
  ) %>%
  tab_spanner(
    label = "COVID-related admission",
    columns = starts_with("covidadmitted")
  ) %>%
  tab_spanner(
    label = "COVID-related death",
    columns = starts_with("coviddeath")
  ) %>%
  tab_spanner(
    label = "Non-COVID-related death",
    columns = starts_with("noncoviddeath")
  ) %>%
  tab_spanner(
    label = "Any death",
    columns = starts_with("death")
  ) %>%
  fmt_number(
    columns = ends_with(c("yearsatrisk")),
    decimals = 0
  ) %>%
  fmt_number(
    columns = ends_with(c("rate")),
    decimals = 3
  ) %>%
  fmt_missing(
    everything(),
    missing_text="--"
  ) %>%
  cols_align(
    align = "right",
    columns = everything()
  ) %>%
  cols_align(
    align = "left",
    columns = "timesincevax_pw"
  )

gtsave(pt_tab_summary, here::here("output", cohort, "descr", "tables", "table_pt.html"))


## note:
# the follow poisson model gives the same results eg for postest
# glm(
#   formula = postest_n ~ timesincevax_pw + offset(log(postest_daysatrisk)),
#   family=poisson,
#   data=pt_summary
# )

# and the following pyears call gives the same results
# pyears(
#  Surv(time=tstart, time2=tstop, event=postest) ~ timesincevax_pw,
#  data=data_pt %>% filter(postest_status==0),
#  data.frame = TRUE
#)
