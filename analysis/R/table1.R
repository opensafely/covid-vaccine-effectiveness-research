
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
      timesincevaxany1<14 ~ "No Vaccine or\n<14 days post-vaccine",
      timesincevaxany1>=14 ~ ">=14 days post-vaccine",
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
gtsave(as_gt(tab_summary), here::here("output", cohort, "descr", "tables", "table1.html"))



## create person-time table ----
postvaxcuts <- c(0, 1, 4, 7, 14, 21)
pt_summary <- data_pt %>%
  mutate(
    timesincevax_pw = timesince_cut(timesincevaxany1, postvaxcuts, "Unvaccinated"),
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
  ) %>%
  ungroup()

pt_tab_summary <- pt_summary %>%
  gt() %>%
   cols_label(
     timesincevax_pw = "Time since first dose",

     postest_yearsatrisk = "Person-years at risk",
     covidadmitted_yearsatrisk = "Person-years at risk",
     coviddeath_yearsatrisk = "Person-years at risk",

     postest_n = "Events",
     covidadmitted_n = "Events",
     coviddeath_n = "Events",

     postest_rate = "Rate/year",
     covidadmitted_rate = "Rate/year",
     coviddeath_rate = "Rate/year",
   ) %>%
  tab_spanner(
    label = "Positive test",
    columns = starts_with("postest")
  ) %>%
  tab_spanner(
    label = "Covid-related admission",
    columns = starts_with("covidadmitted")
  ) %>%
  tab_spanner(
    label = "Covid-related death",
    columns = starts_with("coviddeath")
  ) %>%
  fmt_number(
    columns = ends_with(c("yearsatrisk")),
    decimals = 1
  ) %>%
  fmt_number(
    columns = ends_with(c("rate")),
    decimals = 2
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
