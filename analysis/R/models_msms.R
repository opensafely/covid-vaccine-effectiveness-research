
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

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  outcome <- "postest"
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

### post vax time periods ----

postvaxcuts <- c(0, 3, 7, 14, 21) # use if coded as days
#postvaxcuts <- c(0, 1, 2, 3) # use if coded as weeks

### knot points for calendar time splines ----

knots <- c(21)

## define outcomes, exposures, and covariates ----

formula_demog <- . ~ . + age + I(age*age) + sex + imd
formula_exposure <- . ~ . + timesincevax_pw
formula_comorbs <- . ~ . +
  chronic_cardiac_disease + current_copd + dementia + dialysis +
  solid_organ_transplantation + chemo_or_radio + sickle_cell_disease +
  permanant_immunosuppression + temporary_immunosuppression + asplenia +
  intel_dis_incl_downs_syndrome + psychosis_schiz_bipolar +
  lung_cancer + cancer_excl_lung_and_haem + haematological_cancer
formula_secular <- . ~ . + ns(tstop, knots=knots)
formula_secular_region <- . ~ . + ns(tstop, knots=knots)*region
formula_timedependent <- . ~ . + hospital_status # consider adding local infection rates

# create output directories ----
dir.create(here::here("output", cohort, outcome, "models"), showWarnings = FALSE, recursive=TRUE)

# Import processed data ----

data_pt <- read_rds(here::here("output", cohort, "data", glue::glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
  #fastDummies::dummy_cols(select_columns="region") %>%
  filter(
    tstop <= .[[glue::glue("tte_{outcome}")]] | is.na(.[[glue::glue("tte_{outcome}")]]) # follow up ends at occurrence of outcome
  ) %>%
  mutate(
    timesincevax_pw = timesince2_cut(timesincevax1, timesincevax2, postvaxcuts, "pre-vax"),
    outcome = .[[outcome]]
  )


# IPW model ----

# consider:
# piecewise period effects with eg as.factor(tstop)
# polynomial splines, eg, t + I(t^2) + I(t^3)
# using GAMs for getting spline effect of calendar time, with library('mgcv')
# localised infection rates (then can ignore calendar time?)

# tests:
# test that model complexity/DoF for vax1 and vax2 is the same (eg same factor levels for predictors)
# test that no first and second vax occur on the same day (or week or whatever time period is)

## models for first and second vaccination ----

data_pt_atriskvax1 <- data_pt %>% filter(vax_history==0)
data_pt_atriskvax2 <- data_pt %>% filter(vax_history==1)

#update(vax1 ~ 1, formula_demog) %>% update(formula_secular_region) %>% update(formula_timedependent)
### with time-updating covariates

cat("ipwvax1 \n")
ipwvax1 <- parglm(
  formula = update(vax1 ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_timedependent),
  data = data_pt_atriskvax1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)
jtools::summ(ipwvax1)

cat("ipwvax2 \n")
ipwvax2 <- parglm(
  formula = update(vax2 ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_timedependent),
  data = data_pt_atriskvax2,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)
jtools::summ(ipwvax2)

### without time-updating covariates ----
# exclude time-updating covariates _except_ variables derived from calendar time itself (eg poly(calendar_time,2))
# used for stabilised ip weights


cat("ipwvax1_fxd \n")
ipwvax1_fxd <- parglm(
  formula = update(vax1 ~ 1, formula_demog) %>% update(formula_secular_region),
  data = data_pt_atriskvax1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)
jtools::summ(ipwvax1_fxd)

cat("ipwvax2_fxd \n")
ipwvax2_fxd <- parglm(
  formula = update(vax2 ~ 1, formula_demog) %>% update(formula_secular_region),
  data = data_pt_atriskvax2,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)
jtools::summ(ipwvax2_fxd)

## get predictions from model ----

data_predvax1 <- data_pt_atriskvax1 %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    predvax1=predict(ipwvax1, type="response"),
    predvax1_fxd=predict(ipwvax1_fxd, type="response"),
  )

data_predvax2 <- data_pt_atriskvax2 %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    predvax2=predict(ipwvax2, type="response"),
    predvax2_fxd=predict(ipwvax2_fxd, type="response"),
  )


data_weights <- data_pt %>%
  left_join(data_predvax1, by=c("patient_id", "tstart", "tstop")) %>%
  left_join(data_predvax2, by=c("patient_id", "tstart", "tstop")) %>%
  group_by(patient_id) %>%
  mutate(

    predvax1 = if_else(vax_history==1L, 1, predvax1),
    predvax2 = if_else(vax_history==0L, 0, predvax2),
    predvax2 = if_else(vax_history==2L, 1, predvax2),

    # get probability of occurrence of realised vaccination status
    probstatus = case_when(
      vax_status==0L ~ 1-predvax1,
      vax_status==1L ~ 1-predvax2,
      vax_status==2L ~ predvax2,
      TRUE ~ NA_real_
    ),

    # cumulative product of status probabilities
    cmlprobstatus = cumprod(probstatus),

    # inverse probability weights
    ipweight = 1/cmlprobstatus,

    # ipweight_clipped = case_when(
    #   ipweight>quantile(ipweight,0.75, na.rm=TRUE) ~ quantile(ipweight,0.75, na.rm=TRUE),
    #   ipweight<quantile(ipweight,0.25, na.RM=TRUE) ~ quantile(ipweight,0.25, na.rm=TRUE),
    #   TRUE ~ ipweight
    # ),

    #same but for time-independent model

    predvax1_fxd = if_else(vax_history==1L, 1, predvax1_fxd),
    predvax2_fxd = if_else(vax_history==0L, 0, predvax2_fxd),
    predvax2_fxd = if_else(vax_history==2L, 1, predvax2_fxd),

    probstatus_fxd = case_when(
      vax_status==0L ~ 1-predvax1_fxd,
      vax_status==1L ~ 1-predvax2_fxd,
      vax_status==2L ~ predvax2_fxd,
      TRUE ~ NA_real_
    ),

    cmlprobstatus_fxd = cumprod(probstatus_fxd),

    # stabilised inverse probability weights
    ipweight_stbl = cmlprobstatus_fxd*ipweight,

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
  file = here::here("output", "models", "msm", cohort, "weights.txt"),
  append=FALSE
)

## save weights
weight_histogram <- ggplot(data_weights) +
  geom_histogram(aes(x=ipweight_stbl)) +
  theme_bw()

weights_scatter <- ggplot(data_weights) +
  geom_point(aes(x=ipweight, y=ipweight_stbl)) +
  theme_bw()

ggsave(here::here("output", cohort, outcome, "models", "histogram_weights.svg"), weight_histogram)
write_rds(data_weights, here::here("output", cohort, outcome, "models", glue::glue("data_weights.rds")), compress="gz")

# MSM model ----

# do not use time-dependent covariates as these are accounted for with the weights
# use cluster standard errors
# use quasibinomial to suppress "non-integer #successes in a binomial glm!" warning
# use interaction with time terms?

### model 0 - unadjusted vaccination effect model ----
## no adjustment variables

cat("msmmod0 \n")
msmmod0 <- parglm(
  formula = update(outcome ~ 1, formula_exposure),
  data = data_weights,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)

jtools::summ(msmmod0)

### model 1 - minimally adjusted vaccination effect model, baseline demographics only ----
cat("msmmod1 \n")
msmmod1 <- parglm(
  formula = update(outcome ~ 1, formula_demog) %>% update(formula_exposure),
  data = data_weights,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)

jtools::summ(msmmod1)

### model 2 - baseline, comorbs, adjusted vaccination effect model ----
cat("msmmod2 \n")
msmmod2 <- parglm(
  formula = update(outcome ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure),
  data = data_weights,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)

jtools::summ(msmmod2)

### model 3 - baseline, comorbs, secular trend adjusted vaccination effect model ----
cat("msmmod3 \n")
msmmod3 <- parglm(
  formula = update(outcome ~ 1, formula_demog) %>% update(formula_secular_region) %>% update(formula_comorbs) %>% update(formula_exposure),
  data = data_weights,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)

jtools::summ(msmmod3)

#test<-model.frame(update(outcome ~ 1, formula_demog) %>% update(formula_secular_region) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(. ~ .+ipweight_stbl), data=data_weights)


### model 4 - baseline, comorbs, secular trend adjusted vaccination effect model + IP-weighted ----
cat("msmmod4 \n")
msmmod4 <- parglm(
  formula = update(outcome ~ 1, formula_demog) %>% update(formula_secular_region) %>% update(formula_comorbs) %>% update(formula_exposure),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)

jtools::summ(msmmod4)


### model 5 - secular trend adjusted vaccination effect model + IP-weighted ----
cat("msmmod5 \n")
msmmod5 <- parglm(
  formula = update(outcome ~ 1, formula_secular_region) %>% update(formula_exposure),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail",
  model = FALSE
)

jtools::summ(msmmod5)


## Save models as rds ----

write_rds(ipwvax1, here::here("output", cohort, outcome, "models", "model_vax1.rds"), compress="gz")
write_rds(ipwvax2, here::here("output", cohort, outcome, "models", "model_vax2.rds"), compress="gz")
write_rds(ipwvax1_fxd, here::here("output", cohort, outcome, "models", "model_vax1_fxd.rds"), compress="gz")
write_rds(ipwvax2_fxd, here::here("output", cohort, outcome, "models", "model_vax2_fxd.rds"), compress="gz")
write_rds(msmmod0, here::here("output", cohort, outcome, "models", "model0.rds"), compress="gz")
write_rds(msmmod1, here::here("output", cohort, outcome, "models", "model1.rds"), compress="gz")
write_rds(msmmod2, here::here("output", cohort, outcome, "models", "model2.rds"), compress="gz")
write_rds(msmmod3, here::here("output", cohort, outcome, "models", "model3.rds"), compress="gz")
write_rds(msmmod4, here::here("output", cohort, outcome, "models", "model4.rds"), compress="gz")
write_rds(msmmod5, here::here("output", cohort, outcome, "models", "model5.rds"), compress="gz")

