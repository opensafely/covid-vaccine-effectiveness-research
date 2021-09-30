
# # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('gt')
library('gtsummary')

## Import custom user functions from lib
source(here("lib", "utility_functions.R"))
source(here("lib", "redaction_functions.R"))
source(here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"
  sample_nonoutcomeprop <- 0.1
} else {
  cohort <- args[[1]]
  sample_nonoutcomeprop <- as.numeric(args[[2]])
  removeobs <- TRUE

}

# Import processed data ----

data_tte <- read_rds(here("output", cohort, "data", "data_tte.rds"))

# calculate non-outcome sample weights

data_samples <- data_tte  %>%
  transmute(
    patient_id,
    sample_postest = sample_nonoutcomes_prop(!is.na(tte_postest), patient_id, sample_nonoutcomeprop),
    sample_emergency = sample_nonoutcomes_prop(!is.na(tte_emergency), patient_id, sample_nonoutcomeprop),
    sample_covidadmitted = sample_nonoutcomes_prop(!is.na(tte_covidadmitted), patient_id, sample_nonoutcomeprop),
    sample_coviddeath= sample_nonoutcomes_prop(!is.na(tte_coviddeath), patient_id, sample_nonoutcomeprop),
    sample_noncoviddeath = sample_nonoutcomes_prop(!is.na(tte_noncoviddeath), patient_id, sample_nonoutcomeprop),
    sample_death = sample_nonoutcomes_prop(!is.na(tte_death), patient_id, sample_nonoutcomeprop),

    sample_weights_postest = sample_weights(!is.na(tte_postest), sample_postest),
    sample_weights_emergency = sample_weights(!is.na(tte_emergency), sample_emergency),
    sample_weights_covidadmitted = sample_weights(!is.na(tte_covidadmitted), sample_covidadmitted),
    sample_weights_coviddeath = sample_weights(!is.na(tte_coviddeath), sample_coviddeath),
    sample_weights_noncoviddeath = sample_weights(!is.na(tte_noncoviddeath), sample_noncoviddeath),
    sample_weights_death = sample_weights(!is.na(tte_death), sample_death),
  )

write_rds(data_samples, here("output", cohort, "data", "data_samples.rds"), compress="gz")
