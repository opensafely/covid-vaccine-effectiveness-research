
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
  removeobs <- FALSE
} else {
  # use for actions
  cohort <- args[[1]]
  removeobs <- TRUE
}

## import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
#list2env(gbl_vars, globalenv())


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())


## Import processed data ----
data_cohort <- read_rds(here::here("output", cohort, "data", "data_cohort.rds"))
characteristics <- read_rds(here::here("output", "metadata", "baseline_characteristics.rds"))

data_fixed <- data_cohort %>%
  select(
    patient_id,
    all_of(names(characteristics))
  )
if(removeobs) rm(data_cohort)

tab_summary_baseline <- data_fixed %>%
  select(
    any_of(names(characteristics)),
  ) %>%
  tbl_summary(
    label=unname(characteristics)
  )  %>%
  modify_footnote(starts_with("stat_") ~ NA)

tab_summary_baseline$inputs$data <- NULL

## create output directories ----
dir.create(here::here("output", cohort, "descriptive", "tables"), showWarnings = FALSE, recursive=TRUE)
write_rds(tab_summary_baseline, here::here("output", cohort, "descriptive", "tables", "tbl_baseline.rds")) # save this to combine different cohorts using tbl_merge later
gtsave(as_gt(tab_summary_baseline), here::here("output", cohort, "descriptive", "tables", "table1.html"))
