
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# checks that there are no separation issues between covariates and outcomes
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by 2 arguments,
# 1. the name of the cohort defined in data_define_cohorts.R
# 2. the stratification variable. Use "all" if no stratification
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('glue')
library('gt')
library('gtsummary')

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
  strata_var <- "all"
  sample_nonoutcomeprop <- 0.1
} else {
  cohort <- args[[1]]
  strata_var <- args[[2]]
  sample_nonoutcomeprop <- as.numeric(args[[3]])
  removeobs <- TRUE

}

# Import processed data ----

data_tte <- read_rds(here::here("output", cohort, "data", "data_tte.rds"))

# calculate non-outcome sample weights

data_samples <- data_tte  %>%
  transmute(
    patient_id,
    sample_postest = sample_nonoutcomes(tte_postest, patient_id, sample_nonoutcomeprop),
    sample_emergency = sample_nonoutcomes(tte_emergency, patient_id, sample_nonoutcomeprop),
    sample_covidadmitted = sample_nonoutcomes(tte_covidadmitted, patient_id, sample_nonoutcomeprop),
    sample_coviddeath= sample_nonoutcomes(tte_coviddeath, patient_id, sample_nonoutcomeprop),
    sample_noncoviddeath = sample_nonoutcomes(tte_noncoviddeath, patient_id, sample_nonoutcomeprop),
    sample_death = sample_nonoutcomes(tte_death, patient_id, sample_nonoutcomeprop),

    sample_weights_postest = sample_weights(tte_postest, sample_postest),
    sample_weights_emergency = sample_weights(tte_emergency, sample_emergency),
    sample_weights_covidadmitted = sample_weights(tte_covidadmitted, sample_covidadmitted),
    sample_weights_coviddeath = sample_weights(tte_coviddeath, sample_coviddeath),
    sample_weights_noncoviddeath = sample_weights(tte_noncoviddeath, sample_noncoviddeath),
    sample_weights_death = sample_weights(tte_death, sample_death),
  )

write_rds(data_samples, here::here("output", cohort, "data", "data_samples.rds"), compress="gz")
