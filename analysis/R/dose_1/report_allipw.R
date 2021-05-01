
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports reported MSM estimates for ALL outcomes
# calculates robust CIs taking into account patient-level clustering
# outputs forest plots for the primary vaccine-outcome relationship
# outputs plots showing model-estimated spatio-temporal trends
#
# The script should only be run via an action in the project.yaml only
# The script must be accompanied by four arguments: cohort, brand, and stratum
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')
library('splines')
library('parglm')
library('gtsummary')
library("sandwich")
library("lmtest")
library('gt')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)



if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"
  brand <- "any"
  strata_var <- "all"
} else{
  removeobs <- TRUE
  cohort <- args[[1]]
  brand <- args[[2]]
  strata_var <- args[[3]]
}



# import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)


# Import metadata for cohort ----
## these are created in data_define_cohorts.R script

metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))
metadata_cohorts <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort, ]

list2env(metadata_cohorts, globalenv())

# Import metadata for outcomes ----
## these are created in data_define_cohorts.R script

metadata_outcomes <- read_rds(here::here("output", "data", "metadata_outcomes.rds"))


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "data", "list_formula.rds"))
list2env(list_formula, globalenv())

formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))


strata <- read_rds(here::here("output", "data", "list_strata.rds"))[[strata_var]]
summary_list <- vector("list", length(strata))
names(summary_list) <- strata

# import models ----

if(brand=="any"){


  gts <-
    metadata_outcomes %>%
    filter(outcome %in% c(
      "postest",
      "covidadmitted",
      "coviddeath",
      "noncoviddeath",
      "death"
    )) %>%
    mutate(
      outcome = fct_inorder(outcome),
      outcome_descr = fct_inorder(outcome_descr),
      gt = map(outcome, ~read_rds(here::here("output", cohort, .x, brand, strata_var, "all", glue::glue("gt_vaxany1.rds"))))
    )

  gt_vax <- tbl_merge(gts$gt)
  gtsave(gt_vax %>% as_gt(), here::here("output", cohort, "tab_vaxany1.html"))
}

if(brand!="any"){
  gts <-
    metadata_outcomes %>%
    filter(outcome %in% c(
      "postest",
      "covidadmitted",
      "coviddeath",
      "noncoviddeath",
      "death"
    )) %>%
    mutate(
      outcome = fct_inorder(outcome),
      outcome_descr = fct_inorder(outcome_descr),
      gt = map(outcome, ~read_rds(here::here("output", cohort, .x, brand, strata_var, "all", glue::glue("gt_vax{brand}1.rds"))))
    )

  gt_vax <- tbl_merge(gts$gt)
  gtsave(gt_vax %>% as_gt(), here::here("output", cohort, glue::glue("gt_vax{brand}1.html")))
}

