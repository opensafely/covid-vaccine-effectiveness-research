
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits some marginal structural models for vaccine effectiveness, with different adjustment sets
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by two arguments,
# 1. the name of the cohort defined in data_define_cohorts.R
# 2. the name of the outcome defined in data_define_cohorts.R
# 3. the name of the brand (currently "az" or "pfizer")
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('survival')
library('splines')
library('parglm')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)

cohort <- args[[1]]
outcome <- args[[2]]
brand <- args[[3]]
subgroup <- args[[4]]

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  outcome <- "postest"
  brand <- "pfizer"
  subgroup <- "sex"
}



# Import metadata for cohort ----

metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
metadata <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort & metadata_cohorts[["outcome"]]==outcome, ]


stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))

## define model hyper-parameters and characteristics ----

### model names ----

list2env(metadata, globalenv())

## or equivalently:
# cohort <- metadata_cohorts$cohort
# cohort_descr <- metadata_cohorts$cohort_descr
# outcome <- metadata_cohorts$outcome
# outcome_descr <- metadata_cohorts$outcome_descr

### define parglm optimisation parameters ----

parglmparams <- parglm.control(
  method = "LINPACK",
  nthreads = 8
)

### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "data", "list_formula.rds"))
list2env(list_formula, globalenv())

exposure_subgroup_interaction <- as.formula(paste0(". ~ .+ ",all.vars(formula_exposure)[2],"*",subgroup))

### post vax time periods ----

postvaxcuts <- c(0, 3, 7, 14, 21) # use if coded as days
#postvaxcuts <- c(0, 1, 2, 3) # use if coded as weeks

### knot points for calendar time splines ----

knots <- c(21)


# create output directories ----
dir.create(here::here("output", cohort, outcome, brand, subgroup, "dose1"), showWarnings = FALSE, recursive=TRUE)

# Import processed data ----

data_fixed <- read_rds(here::here("output", cohort, "data", glue::glue("data_wide_fixed.rds")))

data_pt <- read_rds(here::here("output", cohort, "data", glue::glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
  filter(
    .[[glue::glue("{outcome}_status")]] == 0, # follow up ends at (day after) occurrence of outcome, ie where status not >0
    censored_status == 0, # follow up ends at (day after) occurrence of censoring event (derived from lastfup = min(end_date, death))
    death_status ==0, # follow up ends at (day after) occurrence of death
    vaxany_status == .[[glue::glue("vax{brand}_status")]], # follow up ends at (day after) occurrence of competing vaccination, ie where vax{competingbrand}_status not >0
  ) %>%
  mutate(
    timesincevax_pw = timesince_cut(timesincevaxany1, postvaxcuts, "pre-vax"),
    outcome = .[[outcome]],
  ) %>%
  rename(
    vax_status=vaxany_status,
    vax1 = vaxany1,
    timesincevax1 = timesincevaxany1,
  ) %>%
  left_join(
    data_fixed, by="patient_id"
  )


# IPW model for vaccination ----

# tests:
# test that model complexity/DoF for vax1 and vax2 is the same (eg same factor levels for predictors)
# test that no first and second vax occur on the same day (or week or whatever time period is)

## models for first and second vaccination ----

data_pt_atriskvax1 <- data_pt %>% filter(vax_status==0)

### with time-updating covariates
cat("ipwvax1 \n")
ipwvax1 <- read_rds(here::here("output", cohort, outcome, brand, "dose1", "model_vax1.rds"))
jtools::summ(ipwvax1)

ipwvax1

### without time-updating covariates ----
# exclude time-updating covariates _except_ variables derived from calendar time itself (eg ns(calendar_time,3))
# used for stabilised ip weights


cat("ipwvax1_fxd \n")
ipwvax1_fxd <- read_rds(here::here("output", cohort, outcome, brand, "dose1", "model_vax1_fxd.rds"))
jtools::summ(ipwvax1_fxd)

## get predictions from model ----

data_predvax1 <- data_pt_atriskvax1 %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    predvax1=predict(ipwvax1, type="response"),
    predvax1_fxd=predict(ipwvax1_fxd, type="response"),
  )

# IPW model for death ----

## models death ----

data_pt_atriskdeath <- data_pt %>% filter(death_status==0)

### with time-updating covariates

cat("ipwdeath \n")
ipwdeath <- parglm(
  formula = update(death ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(exposure_subgroup_interaction) %>% update(formula_secular_region) %>% update(formula_timedependent),
  data = data_pt_atriskdeath,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)
jtools::summ(ipwdeath)

### without time-updating covariates ----

cat("ipwdeath_fxd \n")
ipwdeath_fxd <- parglm(
  formula = update(death ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(exposure_subgroup_interaction) %>% update(formula_secular_region),
  data = data_pt_atriskdeath,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)
jtools::summ(ipwdeath_fxd)


## get predictions from model ----

data_predvax1 <- data_pt_atriskvax1 %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    predvax1=predict(ipwvax1, type="response"),
    predvax1_fxd=predict(ipwvax1_fxd, type="response"),
  )

data_preddeath <- data_pt_atriskdeath %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    preddeath=predict(ipwdeath, type="response"),
    preddeath_fxd=predict(ipwdeath_fxd, type="response"),
  )

data_weights <- data_pt %>%
  left_join(data_predvax1, by=c("patient_id", "tstart", "tstop")) %>%
  left_join(data_preddeath, by=c("patient_id", "tstart", "tstop")) %>%
  group_by(patient_id) %>%
  mutate(

    # get probability of occurrence of realised vaccination status
    probvax_realised = case_when(
      vax_status==0L & vax1!=1 ~ 1 - predvax1,
      vax_status==0L & vax1==1 ~ predvax1,
      vax_status>0L ~ 1, # if already vaccinated, by definition prob of vaccine is = 1
      TRUE ~ NA_real_
    ),
    # cumulative product of status probabilities
    cmlprobvax_realised = cumprod(probvax_realised),
    # inverse probability weights
    ipweightvax = 1/cmlprobvax_realised,

    #same but for time-independent model

    # get probability of occurrence of realised vaccination status (non-time varying model)
    probvax_realised_fxd = case_when(
      vax_status==0L & vax1!=1 ~ 1 - predvax1_fxd,
      vax_status==0L & vax1==1 ~ predvax1_fxd,
      vax_status>0L ~ 1,
      TRUE ~ NA_real_
    ),
    # cumulative product of status probabilities
    cmlprobvax_realised_fxd = cumprod(probvax_realised_fxd),
    # inverse probability weights
    ipweightvax_fxd = 1/cmlprobvax_realised_fxd,

    # stabilised inverse probability weights
    ipweightvax_stbl = cmlprobvax_realised_fxd/cmlprobvax_realised,



    # death censoring
    probdeath_realised = case_when(
      death_status==0L & death!=1 ~ 1 - preddeath,
      death_status==0L & death==1 ~ preddeath,
      death_status==1L ~ 1,
      TRUE ~ NA_real_
    ),
    # cumulative product of status probabilities
    cmlprobdeath_realised = cumprod(probdeath_realised),
    # inverse probability weights
    ipweightdeath = 1/cmlprobdeath_realised,

    # deathcensoring (fixed)
    probdeath_realised_fxd = case_when(
      death_status==0L & death!=1 ~ 1 - preddeath_fxd,
      death_status==0L & death==1 ~ preddeath_fxd,
      death_status==1L ~ 1,
      TRUE ~ NA_real_
    ),
    # cumulative product of status probabilities
    cmlprobdeath_realised_fxd = cumprod(probdeath_realised_fxd),
    # inverse probability weights
    ipweightdeath_fxd = 1/cmlprobdeath_realised_fxd,


    # stabilised inverse probability weights
    ipweightdeath_stbl = cmlprobdeath_realised_fxd/cmlprobdeath_realised,

    ipweight_stbl = ipweightvax_stbl*ipweightdeath_stbl

  ) %>%
  ungroup()

## output weight distribution file ----

summarise_weights <-
  data_weights %>%
  select(starts_with("ipweight")) %>%
  map(redacted_summary_num) %>%
  enframe()

capture.output(
  walk2(summarise_weights$value, summarise_weights$name, print_num),
  file = here::here("output", cohort, outcome, brand, subgroup, "dose1",  "weights.txt"),
  append=FALSE
)

## save weights
weight_histogram <- ggplot(data_weights) +
  geom_histogram(aes(x=ipweight_stbl)) +
  theme_bw()

ggsave(here::here("output", cohort, outcome, brand, subgroup, "dose1", "histogram_weights.svg"), weight_histogram)


data_weights <- data_weights %>%
  select(
    any_of(all.vars(formula_all_rhsvars)),
    "ipweight_stbl",
    "outcome",
  )

write_rds(data_weights, here::here("output", cohort, outcome, brand, subgroup, "dose1", glue::glue("data_weights.rds")), compress="gz")

# MSM model ----

# do not use time-dependent covariates as these are accounted for with the weights
# use cluster standard errors
# use quasibinomial to suppress "non-integer #successes in a binomial glm!" warning
# use interaction with time terms?

### model 0 - unadjusted vaccination effect model ----
## no adjustment variables

cat("msmmod0 \n")
msmmod0 <- parglm(
  formula = update(outcome ~ 1, exposure_subgroup_interaction),
  data = data_weights,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)

msmmod0 <- glm(
  formula = update(outcome ~ 1, exposure_subgroup_interaction),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = list(maxit = 1),
  na.action = "na.fail",
  model = FALSE,
  start = coefficients(msmmod4_par)
)

jtools::summ(msmmod0)

### model 1 - minimally adjusted vaccination effect model, baseline demographics only ----
cat("msmmod1 \n")
msmmod1 <- parglm(
  formula = update(outcome ~ 1, formula_demog) %>% update(exposure_subgroup_interaction),
  data = data_weights,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)

msmmod1 <- glm(
  formula = update(outcome ~ 1, formula_demog) %>% update(exposure_subgroup_interaction),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = list(maxit = 1),
  na.action = "na.fail",
  model = FALSE,
  start = coefficients(msmmod4_par)
)

jtools::summ(msmmod1)

### model 2 - baseline, comorbs, adjusted vaccination effect model ----
# cat("msmmod2 \n")
# msmmod2 <- parglm(
#   formula = update(outcome ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(exposure_subgroup_interaction),
#   data = data_weights,
#   family = binomial,
#   control = parglmparams,
#   na.action = "na.fail",
#   model = FALSE
# )
#
# jtools::summ(msmmod2)

### model 3 - baseline, comorbs, secular trend adjusted vaccination effect model ----
# cat("msmmod3 \n")
# msmmod3 <- parglm(
#   formula = update(outcome ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(exposure_subgroup_interaction),
#   data = data_weights,
#   family = binomial,
#   control = parglmparams,
#   na.action = "na.fail",
#   model = FALSE
# )
#
# jtools::summ(msmmod3)


### model 4 - baseline, comorbs, secular trend adjusted vaccination effect model + IP-weighted ----
cat("msmmod4 \n")
msmmod4 <- parglm(
  formula = update(outcome ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(exposure_subgroup_interaction),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)


msmmod4 <- glm(
  formula = update(outcome ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(exposure_subgroup_interaction),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = list(maxit = 1),
  na.action = "na.fail",
  model = FALSE,
  start = coefficients(msmmod4_par)
)

jtools::summ(msmmod4)


### model 5 - secular trend adjusted vaccination effect model + IP-weighted ----
# cat("msmmod5 \n")
# msmmod5 <- parglm(
#   formula = update(outcome ~ 1, formula_secular_region) %>% update(exposure_subgroup_interaction),
#   data = data_weights,
#   weights = ipweight_stbl,
#   family = binomial,
#   control = parglmparams,
#   na.action = "na.fail",
#   model = FALSE
# )
#
# jtools::summ(msmmod5)


## Save models as rds ----

write_rds(ipwvax1, here::here("output", cohort, outcome, brand, subgroup, "dose1", "model_vax1.rds"), compress="gz")
write_rds(ipwvax1_fxd, here::here("output", cohort, outcome, brand, subgroup, "dose1", "model_vax1_fxd.rds"), compress="gz")
write_rds(msmmod0, here::here("output", cohort, outcome, brand, subgroup, "dose1", "model0.rds"), compress="gz")
write_rds(msmmod1, here::here("output", cohort, outcome, brand, subgroup, "dose1", "model1.rds"), compress="gz")
#write_rds(msmmod2, here::here("output", cohort, outcome, brand, subgroup, "dose1", "model2.rds"), compress="gz")
#write_rds(msmmod3, here::here("output", cohort, outcome, brand, subgroup, "dose1", "model3.rds"), compress="gz")
write_rds(msmmod4, here::here("output", cohort, outcome, brand, subgroup, "dose1", "model4.rds"), compress="gz")
#write_rds(msmmod5, here::here("output", cohort, outcome, brand, "dose1", "model5.rds"), compress="gz")

