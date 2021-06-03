
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits some marginal structural models for vaccine effectiveness, with different adjustment sets
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by four arguments,
# 1. the name of the cohort defined in data_define_cohorts.R
# 2. the name of the outcome defined in data_define_cohorts.R
# 3. the name of the brand (currently "az" or "pfizer")
# 4. the stratification variable. Use "all" if no stratification
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('glue')
library('survival')
library('splines')
library('parglm')
library('gtsummary')
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
  outcome <- "postest"
  brand <- "any"
  strata_var <- "all"
} else {
  cohort <- args[[1]]
  outcome <- args[[2]]
  brand <- args[[3]]
  strata_var <- args[[4]]
  removeobs <- TRUE

}


### define parglm optimisation parameters ----

parglmparams <- parglm.control(
  method = "LINPACK",
  nthreads = 8,
  maxit = 40 # default = 25
)

### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())

## if outcome is positive test, remove time-varying positive test info from covariate set
if(outcome=="postest"){
  formula_remove_postest <- as.formula(". ~ . - timesince_postesttdc_pw")
} else{
  formula_remove_postest <- as.formula(". ~ .")
}

formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ", strata_var))

# Import processed data ----

data_fixed <- read_rds(here::here("output", cohort, "data", glue("data_fixed.rds")))

data_pt <- read_rds(here::here("output", cohort, "data", glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
  filter(
    .[[glue("{outcome}_status")]] == 0, # follow up ends at (day after) occurrence of outcome, ie where status not >0
    lastfup_status == 0, # follow up ends at (day after) occurrence of censoring event (derived from lastfup = min(end_date, death, dereg))
    vaxany1_status == .[[glue("vax{brand}1_status")]], # if brand-specific, follow up ends at (day after) occurrence of competing vaccination, ie where vax{competingbrand}_status not >0
    .[[glue("sample_{outcome}")]] > 0 # select all patients who experienced the outcome, and a proportion (determined in data_stset action) of those who don't
  ) %>%
  mutate(
    all = factor("all",levels=c("all")),
    timesincevax_pw = timesince_cut(timesincevaxany1, postvaxcuts, "pre-vax"),
    sample_weights = .[[glue("sample_weights_{outcome}")]],
    outcome = .[[outcome]],
  ) %>%
  left_join(
    data_fixed, by="patient_id"
  ) %>%
  mutate( # this step converts logical to integer so that model coefficients print nicely in gtsummary methods
    across(
      where(is.logical),
      ~.x*1L
    )
  ) %>%
  mutate(
    vaxany1_atrisk = (vaxany1_status==0 & lastfup_status==0),
    vaxpfizer1_atrisk = (vaxany1_status==0 & lastfup_status==0 & vaxpfizer_atrisk==1),
    vaxaz1_atrisk = (vaxany1_status==0 & lastfup_status==0 & vaxaz_atrisk==1),
    death_atrisk = (death_status==0 & lastfup_status==0),
  )


### print dataset size ----
cat(glue("data_pt data size = ", nrow(data_pt)), "\n  ")
cat(glue("memory usage = ", format(object.size(data_pt), units="GB", standard="SI", digits=3L)), "\n  ")



# function to calculate weights for treatment model ----
## if exposure is any vaccine, then create model for vaccination by any brand + model for death for censoring weights
## if exposure is pfizer vaccine, then create model for vaccination by pfizer + model for az and model for death for censoring weights
## if exposure is az vaccine, then create model for vaccination by az + model for pfizer and model death for censoring weights
get_ipw_weights <- function(
  data,
  event,
  event_status,
  event_atrisk,

  ipw_formula,
  ipw_formula_fxd
){

  name <- str_remove(event_atrisk, "_atrisk")

  data_atrisk <- data %>%
    mutate(
      event = data[[event]],
      event_status = data[[event_status]],
      event_atrisk = data[[event_atrisk]],
    ) %>%
    filter(
      event_atrisk==1,
    )


  cat("check separation \n")
  data_atrisk %>%
  select(all.vars(ipw_formula)) %>%
  tbl_summary(
    by=as.character(ipw_formula[2]),
    missing = "ifany"
  ) %>%
  as_gt() %>%
  gtsave(
    filename = glue("sepcheck_{name}.html"),
    path=here::here("output", cohort, outcome, brand, strata_var, stratum)
  )

  ### with time-updating covariates
  cat("  \n")
  cat(glue("{event}  \n"))

  event_model <- parglm(
    formula = ipw_formula,
    data = data_atrisk,
    family = binomial,
    weights = sample_weights,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  #event_model$data <- NULL

  cat(glue("{event} data size = ", length(event_model$y)), "\n")
  cat(glue("memory usage = ", format(object.size(event_model), units="GB", standard="SI", digits=3L)), "\n")
  cat("warnings: ", "\n")
  print(warnings())

  ### without time-updating covariates ----

  cat("  \n")
  cat(glue("{event}_fxd  \n"))
  event_model_fxd <- parglm(
    formula = ipw_formula_fxd,
    data = data_atrisk,
    family = binomial,
    weights = sample_weights,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  #event_model_fxd$data <- NULL

  cat(glue("{event}_fxd data size = ", length(event_model_fxd$y)), "\n")
  cat(glue("memory usage = ", format(object.size(event_model_fxd), units="GB", standard="SI", digits=3L)), "\n")
  cat("warnings: ", "\n")
  print(warnings())

  data_atrisk %>%
    summarise(
      obs = n(),
      patients = n_distinct(patient_id),
      events = sum(event),
      rate = events/patients,
      incidence_rate = events/obs
  ) %>%
  write_csv(path=here::here("output", cohort, outcome, brand, strata_var, stratum, glue("summary_{name}.csv")))

  #write_rds(data_atrisk, here::here("output", cohort, outcome, brand, strata_var, stratum, glue("data_atrisk_{event}.rds")), compress="gz")
  write_rds(event_model, here::here("output", cohort, outcome, brand, strata_var, stratum, glue("model_{name}.rds")), compress="gz")
  write_rds(ipw_formula, here::here("output", cohort, outcome, brand, strata_var, stratum, glue("model_formula_{name}.rds")), compress="gz")

  ## output models ----


  # tab_summary <- gt_model_summary(event_model, data_atrisk$patient_id)
  # gtsave(tab_summary %>% as_gt(), here::here("output", cohort, outcome, brand, strata_var, stratum, glue("tab_{event}.html")))
  # write_csv(tab_summary$table_body, here::here("output", cohort, outcome, brand, strata_var, stratum, glue("tab_{event}.csv")))
  #
  # ##output forest plot
  # plot_summary <- forest_from_gt(tab_summary, title)
  # ggsave(
  #   here::here("output", cohort, outcome, brand, strata_var, stratum, glue("plot_{event}.svg")),
  #   plot_summary,
  #   units="cm", width=20, height=25
  # )
  #
  # plot_region_trends <- interactions::interact_plot(
  #   event_model,
  #   pred=tstop, modx=region, data=data_atrisk,
  #   colors="Set1", vary.lty=FALSE,
  #   x.label=glue("Days since {as.Date(gbl_vars$start_date)+1}"),
  #   y.label=glue("Death rate (mean-centered)")
  # )
  # ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, glue("plot_{event}_region_trends.svg")), plot_region_trends, width=20, height=15, units="cm")



  ## get predictions from model ----


  weights <- data_atrisk %>%
    transmute(
      patient_id,
      tstart, tstop,
      event,
      event_status,
      # get predicted probabilities from ipw models
      pred_event=predict(event_model, type="response"),
      pred_event_fxd=predict(event_model_fxd, type="response"),
      sample_weights
    ) %>%
    arrange(patient_id, tstop) %>%
    group_by(patient_id) %>%
    mutate(
      probevent_realised = case_when(
        event!=1L ~ 1 - pred_event,
        event==1L ~ pred_event,
        TRUE ~ NA_real_
      ),
      # cumulative product of status probabilities
      cmlprobevent_realised = cumprod(probevent_realised),
      # inverse probability weights
      ipweight = 1/cmlprobevent_realised,

      #same but for time-independent model

      # get probability of occurrence of realised event status (non-time varying model)
      probevent_realised_fxd = case_when(
        event!=1L ~ 1 - pred_event_fxd,
        event==1L ~ pred_event_fxd,
        TRUE ~ NA_real_
      ),
      # cumulative product of status probabilities
      cmlprobevent_realised_fxd = cumprod(probevent_realised_fxd),
      # inverse probability weights
      ipweight_fxd = 1/cmlprobevent_realised_fxd,

      # stabilised inverse probability weights
      ipweight_stbl = cmlprobevent_realised_fxd/cmlprobevent_realised,
    ) %>%
    ungroup()


  stopifnot("probs should all be non-null" = all(!is.na(weights$probevent_realised)))
  stopifnot("probs (fxd) should all be non-null" = all(!is.na(weights$probevent_realised_fxd)))

  weights_out <- weights %>%
    select(
      patient_id, tstart, tstop,
      ipweight_stbl
    )

  weights_out[[glue("ipweight_stbl_{name}")]] <- weights_out$ipweight_stbl
  weights_out$ipweight_stbl <- NULL

  return(weights_out)
}



##  Create big loop over all strata

strata <- read_rds(here::here("output", "metadata", "list_strata.rds"))[[strata_var]]

for(stratum in strata){

  cat("  \n")
  cat(stratum, "  \n")
  cat("  \n")

  # create output directories ----
  dir.create(here::here("output", cohort, outcome, brand, strata_var, stratum), showWarnings = FALSE, recursive=TRUE)

  # subset data
  data_pt_sub <- data_pt %>%
    filter(.[[strata_var]] == stratum)

  if(brand=="any"){

    # IPW model for any vaccination ----
    weights_vaxany1 <- get_ipw_weights(
      data_pt_sub, "vaxany1", "vaxany1_status", "vaxany1_atrisk",
      ipw_formula =     update(vaxany1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var),
      ipw_formula_fxd = update(vaxany1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var)
    )
  }
  if(brand!="any"){

    # IPW model for pfizer / az vaccination ----
    # these models are shared across brands (one is treatment model, one is censoring model)
    # these could be separated out and run only once, but it complicates the remaining workflow so leaving as is
    weights_vaxpfizer1 <- get_ipw_weights(
      data_pt_sub, "vaxpfizer1", "vaxpfizer1_status", "vaxpfizer1_atrisk",
      ipw_formula =     update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var),
      ipw_formula_fxd = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var)
    )
    weights_vaxaz1 <- get_ipw_weights(
      data_pt_sub, "vaxaz1", "vaxaz1_status", "vaxaz1_atrisk",
      ipw_formula =     update(vaxaz1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var),
      ipw_formula_fxd = update(vaxaz1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var)
    )
  }

  # IPW model for death ----

  ## if outcome is not death, then need to account for censoring by any cause death
  if(!(outcome %in% c("death", "coviddeath", "noncoviddeath"))){
    weights_death <- get_ipw_weights(
      data_pt_sub, "death", "death_status", "death_atrisk",
      ipw_formula =     update(death ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var),
      ipw_formula_fxd = update(death ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_remove_strata_var)
    )
  }
  ## if outcome is covid death, then need to account for censoring by non-covid deaths
  if(outcome=="coviddeath"){
    weights_death <- get_ipw_weights(
      data_pt_sub, "noncoviddeath", "noncoviddeath_status", "death_atrisk",
      ipw_formula =     update(noncoviddeath ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var),
      ipw_formula_fxd = update(noncoviddeath ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_remove_strata_var)
    )
  }
  ## if outcome is noncovid death, then need to account for censoring by covid deaths
  if(outcome=="noncoviddeath"){
    weights_death <- get_ipw_weights(
      data_pt_sub, "coviddeath", "coviddeath_status", "death_atrisk",
      ipw_formula =     update(coviddeath ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var),
      ipw_formula_fxd = update(coviddeath ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_remove_strata_var)
    )
  }
  ## if outcome is death, then no accounting for censoring by death is needed
  if(outcome=="death"){
    weights_death <- data_pt_sub %>%
      filter(death_atrisk) %>%
      transmute(
        patient_id, tstart, tstop,
        ipweight_stbl_death=1,
      )
  }

  if(brand=="any"){
    data_weights <- data_pt_sub %>%
      left_join(weights_vaxany1, by=c("patient_id", "tstart", "tstop")) %>%
      left_join(weights_death, by=c("patient_id", "tstart", "tstop")) %>%
      group_by(patient_id) %>%
      fill( # after event has occurred, fill ip weight with last value carried forward (ie where all treatment probs are = 1 and so cumulative product of prob is last value)
        ipweight_stbl_vaxany1,
        ipweight_stbl_death
      ) %>%
      replace_na(list( # weight is 1 if patient is not yet at risk
        ipweight_stbl_vaxany1 = 1,
        ipweight_stbl_death = 1
      )) %>%
      ungroup() %>%
      mutate(
        ipweight_stbl = ipweight_stbl_vaxany1 * ipweight_stbl_death,
        ipweight_stbl_sample = ipweight_stbl * sample_weights,
      )
  }
  if(brand != "any"){

    data_weights <- data_pt_sub %>%
      left_join(weights_vaxpfizer1, by=c("patient_id", "tstart", "tstop")) %>%
      left_join(weights_vaxaz1, by=c("patient_id", "tstart", "tstop")) %>%
      left_join(weights_death, by=c("patient_id", "tstart", "tstop")) %>%
      group_by(patient_id) %>%
      fill( # after event has occurred, fill ip weight with last value carried forward (ie where all treatment probs are = 1 and so cumulative product of prob is last value)
        ipweight_stbl_vaxpfizer1,
        ipweight_stbl_vaxaz1,
        ipweight_stbl_death
      ) %>%
      replace_na(list( # weight is 1 if patient is not yet at risk
        ipweight_stbl_vaxpfizer1 = 1,
        ipweight_stbl_vaxaz1 = 1,
        ipweight_stbl_death = 1
      )) %>%
      ungroup() %>%
      mutate(
        ## COMBINE WEIGHTS
        # take product of all weights
        ipweight_stbl = ipweight_stbl_vaxpfizer1 * ipweight_stbl_vaxaz1 * ipweight_stbl_death,
        ipweight_stbl_sample = ipweight_stbl * sample_weights,
      )
  }



  ## report weights ----
  summarise_weights <-
    data_weights %>%
    select(starts_with("ipweight")) %>%
    map(redacted_summary_num) %>%
    enframe()

  capture.output(
    walk2(summarise_weights$value, summarise_weights$name, print_num),
    file = here::here("output", cohort, outcome, brand, strata_var, stratum, "weights_table.txt"),
    append=FALSE
  )

  ## save weights
  weight_histogram <- ggplot(data_weights) +
    geom_histogram(aes(x=ipweight_stbl)) +
    #scale_x_log10(breaks=c(1/8,1/6,1/4,1/3,1/2,1/1.5,1,1.5,2,3,4,6,8), limits=c(1/8, 8))+
    theme_bw()

  ggsave(here::here("output", cohort, outcome, brand, strata_var, stratum, "weights_histogram.svg"), weight_histogram)
  if(removeobs) rm(weight_histogram)

  ## output weight distribution file ----
  data_weights <- data_weights %>%
    select(
      "patient_id",
      "tstart", "tstop",
      any_of(all.vars(formula_all_rhsvars)),
      "sample_weights",
      "ipweight_stbl",
      "ipweight_stbl_sample",
      "outcome",
    )
  cat("  \n")
  cat(glue("data_weights data size = ", nrow(data_weights)), "  \n")
  cat(glue("memory usage = ", format(object.size(data_weights), units="GB", standard="SI", digits=3L)), "  \n")

  write_rds(data_weights, here::here("output", cohort, outcome, brand, strata_var, stratum, glue("data_weights.rds")), compress="gz")




  # MSM model ----

  # do not use time-dependent covariates as these are accounted for with the weights
  # use cluster standard errors
  # use quasibinomial to suppress "non-integer #successes in a binomial glm!" warning (not possible with parglm)
  # use interaction with time terms?

  ### model 0 - unadjusted vaccination effect model ----
  ## no adjustment variables
  # cat("  \n")
  # cat("msmmod0 \n")
  # msmmod0_par <- parglm(
  #   formula = formula_1 %>% update(formula_exposure) %>% update(formula_remove_strata_var),
  #   data = data_weights,
  #   family = binomial,
  #   weights = sample_weights,
  #   control = parglmparams,
  #   na.action = "na.fail",
  #   model = FALSE
  # )
  #
  # msmmod0_par$data <- NULL
  # print(jtools::summ(msmmod0_par, digits =3))
  #
  # cat(glue("msmmod0_par data size = ", length(msmmod0_par$y)), "\n")
  # cat(glue("memory usage = ", format(object.size(msmmod0_par), units="GB", standard="SI", digits=3L)), "\n")
  # write_rds(msmmod0_par, here::here("output", cohort, outcome, brand, strata_var, stratum, "model0.rds"), compress="gz")
  # if(removeobs) rm(msmmod0_par)

  ### model 1 - adjusted vaccination effect model and region/time only ----
  cat("  \n")
  cat("msmmod1 \n")
  msmmod1_par <- parglm(
    formula = formula_1 %>% update(formula_exposure) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
    data = data_weights,
    family = binomial,
    weights = sample_weights,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  msmmod1_par$data <- NULL
  print(jtools::summ(msmmod1_par, digits =3))
  cat("warnings: ", "\n")
  print(warnings())

  cat(glue("msmmod1_par data size = ", length(msmmod1_par$y)), "\n")
  cat(glue("memory usage = ", format(object.size(msmmod1_par), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(msmmod1_par, here::here("output", cohort, outcome, brand, strata_var, stratum,"model1.rds"), compress="gz")
  if(removeobs) rm(msmmod1_par)



  ### model 2 - baseline, comorbs, secular trend adjusted vaccination effect model ----
  cat("  \n")
  cat("msmmod2 \n")
  msmmod2_par <- parglm(
    formula = formula_1 %>% update(formula_exposure) %>% update(formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
    data = data_weights,
    family = binomial,
    weights = sample_weights,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )
  msmmod2_par$data <- NULL
  print(jtools::summ(msmmod2_par, digits =3))
  cat("warnings: ", "\n")
  print(warnings())

  cat(glue("msmmod2_par data size = ", length(msmmod2_par$y)), "\n")
  cat(glue("memory usage = ", format(object.size(msmmod2_par), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(msmmod2_par, here::here("output", cohort, outcome, brand, strata_var, stratum, "model2.rds"), compress="gz")

  if(removeobs) rm(msmmod2_par)


  ### model 3 - baseline, comorbs, secular trends and time-varying (but not reweighted) adjusted vaccination effect model ----
  cat("  \n")
  cat("msmmod3 \n")
  msmmod3_par <- parglm(
    formula = formula_1 %>% update(formula_exposure) %>% update(formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_timedependent) %>% update(formula_remove_postest) %>% update(formula_remove_strata_var),
    data = data_weights,
    family = binomial,
    weights = sample_weights,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )
  msmmod3_par$data <- NULL
  print(jtools::summ(msmmod3_par, digits =3))
  cat("warnings: ", "\n")
  print(warnings())

  cat(glue("msmmod3_par data size = ", length(msmmod3_par$y)), "\n")
  cat(glue("memory usage = ", format(object.size(msmmod3_par), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(msmmod3_par, here::here("output", cohort, outcome, brand, strata_var, stratum, "model3.rds"), compress="gz")
  if(removeobs) rm(msmmod3_par)



  ### model 4 - baseline, comorbs, secular trend adjusted vaccination effect model + IP-weighted + do not use time-dependent covariates ----
  cat("  \n")
  cat("msmmod4 \n")
  msmmod4_par <- parglm(
    formula = formula_1 %>% update(formula_exposure)  %>% update(formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var),
    data = data_weights,
    weights = ipweight_stbl_sample,
    family = binomial,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )
  msmmod4_par$data <- NULL
  print(jtools::summ(msmmod4_par, digits =3))
  cat("warnings: ", "\n")
  print(warnings())

  cat(glue("msmmod4_par data size = ", length(msmmod4_par$y)), "\n")
  cat(glue("memory usage = ", format(object.size(msmmod4_par), units="GB", standard="SI", digits=3L)), "\n")
  write_rds(msmmod4_par, here::here("output", cohort, outcome, brand, strata_var, stratum, "model4.rds"), compress="gz")
  if(removeobs) rm(msmmod4_par)


  ## print warnings
  cat("warnings: ", "\n")
  print(warnings())
  cat("  \n")
  print(gc(reset=TRUE))


  data_weights %>%
    summarise(
      obs = n(),
      patients = n_distinct(patient_id),
      outcomes = sum(outcome),
      incidence_prop = outcomes/patients,
      incidence_rate = outcomes/obs
    ) %>%
    write_csv(path=here::here("output", cohort, outcome, brand, strata_var, stratum, glue("summary_substantive.csv")))


}


