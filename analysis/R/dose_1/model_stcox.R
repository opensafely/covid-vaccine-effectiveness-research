
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits a sequence of vaccine effectiveness "trials" every day from the study start date to the end of recruitment, with different adjustment sets
# uses cox model with time-dependent treatment effects
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by 5 arguments:
# 1. the name of the cohort
# 2. the stratification variable. Use "all" if no stratification
# 3. the duration of time from positive test over which to exclude vaccinations from the exposure. This changes the causal estimand, but allows estimation of covid-19 specific mortality
# 4. the name of the outcome
# 5. the name of the brand (currently "any", "az",or "pfizer")
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('survival')
library('splines')

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
  strata_var <- "all"
  recentpostest_period <- as.numeric("0")
  brand <- "any"
  outcome <- "covidadmitted"

} else {
  removeobs <- TRUE
  cohort <- args[[1]]
  strata_var <- args[[2]]
  recentpostest_period <- as.numeric(args[[3]])
  brand <- args[[4]]
  outcome <- args[[5]]
}


# reweight censored deaths or not?
# ideally yes, but often very few events so censoring models are not stable
reweight_death <- read_rds(here("output", "metadata", "reweight_death.rds")) == 1

## if changing treatment strategy as per Miguel's suggestion
exclude_recentpostest <- (recentpostest_period >0)

### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())

## if outcome is positive test, remove time-varying positive test info from covariate set
if(outcome=="postest" | exclude_recentpostest){
  formula_remove_postest <- as.formula(". ~ . - timesince_postesttdc_pw")
} else{
  formula_remove_postest <- as.formula(". ~ .")
}

formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ", strata_var))


# create output directories ----
fs::dir_create(here("output", cohort, strata_var, recentpostest_period, brand, outcome))

##  Create big loop over all strata

strata <- read_rds(here("output", "metadata", "list_strata.rds"))[[strata_var]]

for(stratum in strata){

  cat("  \n")
  cat(stratum, "  \n")
  cat("  \n")



  #test function:
  # N <- NA
  # testdat <- tibble(
  #   patid = as.integer(c(1,2,3,4,5,6,7,8,9,10,11,12)),
  #   ttevax =              c(5,1,2,N,1,3,4,1,N,N,N,N),
  #   ttecensor =         c(6,6,6,6,6,6,6,6,6,6,6,6)
  # )
  #
  # samples <- sample_nonoutcomesbytime(testdat$ttevax, testdat$ttecensor, testdat$patid, 6)
  # samples %>% View()



  # Import processed data ----
  data_fixed <- read_rds(here("output", cohort, "data", glue("data_fixed.rds")))


  ## read and process person-time dataset -- do this _within_ loop so that it can be deleted just before models are run, to reduce RAM use
  data_pt_sub <- read_rds(here("output", cohort, "data", glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
    mutate(
      all = factor("all",levels=c("all")),
      # trial_treatment = if_else(
      #   is.na(tte_vaxany1),
      #   0L,
      #   (tte_vax == trial_day)*1L
      # ), # is this the same as vaxany1?
    ) %>%
    filter(
      .[[glue("{outcome}_status")]] == 0, # follow up ends at (day after) occurrence of outcome, ie where status not >0
      lastfup_status == 0, # follow up ends at (day after) occurrence of censoring event (derived from lastfup = min(end_date, death, dereg))
      vaxany1_status == .[[glue("vax{brand}1_status")]], # if brand-specific, follow up ends at (day after) occurrence of competing vaccination, ie where vax{competingbrand}_status not >0
      vaxany2_status == 0, # censor at second dose
      .[[glue("vax{brand}_atrisk")]] == 1, # select follow-up time where vax brand is being administered

    ) %>%
    left_join(data_fixed, by="patient_id") %>%
    filter(
      .[[strata_var]] == stratum # select patients in current stratum
    ) %>%
    mutate(
      timesincevax_pw = timesince_cut(vaxany1_timesince, postvaxcuts, "pre-vax"),
      outcome = .[[outcome]],
    ) %>%
    mutate( # this step converts logical to integer so that model coefficients print nicely in gtsummary methods
      across(where(is.logical), ~.x*1L)
    ) %>%
    mutate(
      recentpostest = (replace_na(between(postest_timesince, 1, recentpostest_period), FALSE) & exclude_recentpostest),
      vaxany1_atrisk = (vaxany1_status==0 & lastfup_status==0 & vaxany_atrisk==1 & (!recentpostest)),
      vaxpfizer1_atrisk = (vaxany1_status==0 & lastfup_status==0 & vaxpfizer_atrisk==1 & (!recentpostest)),
      vaxaz1_atrisk = (vaxany1_status==0 & lastfup_status==0 & vaxaz_atrisk==1 & (!recentpostest)),
      death_atrisk = (death_status==0 & lastfup_status==0),
    ) %>%
    mutate(
      vax_atrisk = .[[glue("vax{brand}1_atrisk")]]
    ) %>%
    select(
      "patient_id",
      "all",
      "tstart", "tstart",
      "outcome",
      "timesincevax_pw",
      any_of(all.vars(formula_all_rhsvars)),
      "recentpostest",
      "vaxany1_atrisk",
      "vaxpfizer1_atrisk",
      "vaxaz1_atrisk",
      "death_atrisk",
      "vax_atrisk",
      "vaxany1",
      "vaxpfizer1",
      "vaxaz1",
      "vaxany1_status",
      "vaxpfizer1_status",
      "vaxaz1_status",
      "vaxany1_timesince",
      "vaxpfizer1_timesince",
      "vaxaz1_timesince",
      "vaxanyday1"
    )


  ## sequential trial analysis is as follows:
  # each daily trial includes all n people who were vaccinated on that day (treated=1) and
  # a random sample of n controls (treated=0) who:
  # - had not been vaccinated on or before that day (still at risk of treatment);
  # - had not experienced the outcome (still at risk of outcome);
  # - had not already been selected as a control in a previous trial
  # for each trial, all covariates, including time-dependent covariates, are chosen as at the recruitment date and do not subsequently vary through follow-up
  # within the construct of the model, there are no time-dependent variables, only time-dependent treatment effects (modelled as piecewise constant hazards)


  # function to get sample non-treated without replacement over time
  sample_nonoutcomesbytime <- function(ttevax, ttecensor, id, max_trial_day=NULL){
    # for each time point:
    # TRUE if outcome occurs
    # TRUE with probability of `n/sum(event==FALSE & not-already-selected)` if outcome has not occurred
    # based on `id` to ensure consistency of samples

    # `ttevax` is an integer giving the event time for treatment. NA if no treatment before outcome / censoring
    # `ttecensor` is an integer giving the time to end of followup/censoring. should not be any NAs
    # `id` is an identifier with the following properties:
    # - a) consistent between cohort extracts
    # - b) unique
    # - c) completely randomly assigned (no correlation with practice ID, age, registration date, etc etc) which should be true as based on hash of true IDs
    # - d) is an integer strictly greater than zero
    # `max_trial_day` is maximum trial day (ie last recruitment day). select controls up to and including this time


    # set max trial day
    if(is.null(max_trial_day)) tmax <- max(ttevax, na.rm=TRUE) else(tmax = max_trial_day)
    times <- seq(1,tmax)

    # set candidate control ids
    candidate0ids <- id

    dat <- tidyr::expand_grid(
      id=id,
      treated=c(0,1)
    ) %>%
      mutate(
        trial_day=NA_real_,
        #weight=NA_real_
      )

    for(t in times){

      # sample people
      # treated samples for trial i
      trial_ids1 <- id[(ttevax %in% t)]
      n_treated <- length(trial_ids1)
      # candidate control samples for trial i (anyone who hasn't been treated yet (ttevax>t), censored yet (ttecensor>t), and anyone who hasn't already been selected as a control (candidate0ids from t-1))
      candidate0ids <- id[ (ttecensor>t) & ((ttevax > t) | is.na(ttevax)) & (id %in% candidate0ids)]
      # control samples for trial i - select first n candidates according to ranked id
      trial_ids0 <- candidate0ids[dplyr::dense_rank(candidate0ids)<=n_treated]

      if(length(trial_ids0) != n_treated) {
        warning("not enough remaining untreated candidates at t=",t,". Outputting samples up to t=",t-1)
        break
      }

      # n untreated / uncensored at time t
      # n_noevent <- sum(ttevax>t)
      # sample weight for controls at time t
      # weight0 <- n_noevent/n_treated

      dati <- tibble::tibble(
        id = c(trial_ids1, trial_ids0),
        treated = c(rep(1L,n_treated), rep(0L,n_treated)),
        trial_dayt = t,
        #weightt = c(rep(weight0,n_treated), rep(1,n_treated)),
      )

      # remove already sampled indivuduals from list of candidate samples
      candidate0ids <- candidate0ids[!(candidate0ids %in% dati$id)]

      dat <- left_join(dat, dati, by=c("id", "treated")) %>%
        mutate(
          trial_day=coalesce(trial_day, trial_dayt),
          #weight=coalesce(weight, weightt),
        ) %>%
        select(
          -trial_dayt,
          #-weightt
        )
    }

    dat
  }

  # candidates for sample selection, and their event times
  data_candidates <- data_pt_sub %>%
    group_by(patient_id) %>%
    summarise(
      tte_vax = tstop[match(1,vaxany1)], # actual vaccination day
      tte_outcome = tstop[match(1,outcome)], # outcome day
      tte_censor = max(tstop), # last follow up / censor / outcome day for this particular outcome / brand
      #ind_vax = (!is.na(tte_vax))*1L, # treated before last follow up / outcome?
      #ind_outcome = (!is.na(tte_outcome))*1L # experienced outcome before last follow up?
    ) %>%
    ungroup()

  # choose treated and their controls
  data_samples <- sample_nonoutcomesbytime(data_candidates$tte_vax, data_candidates$tte_censor, data_candidates$patient_id)
  data_samples <- data_samples %>% filter(!is.na(trial_day)) %>%
    rename(patient_id=id) %>%
    left_join(data_candidates, by=c("patient_id"))

  # print number of treated/controls per trial
  table(data_samples$trial_day, data_samples$treated)

  # max trial date
  max_trial_day <- max(data_samples$trial_day, na.rm=TRUE)
  cat("max trial day is ", max_trial_day)

  # one row per patient per post-vaccination split time
  postvax_time <- data_samples %>%
    uncount(weights = length(postvaxcuts), .id="id_postvax") %>%
    mutate(
      fup_day = postvaxcuts[id_postvax],
      timesincerecruitment_pw = timesince_cut(fup_day+1, postvaxcuts)
    ) %>%
    droplevels() %>%
    select(patient_id, treated, trial_day, fup_day, timesincerecruitment_pw)

  # add post-treatment time + outcome time for treated
  data_st1 <- tmerge(
    data1 = data_samples %>% filter(treated==1, !is.na(trial_day)),
    data2 = data_samples %>% filter(treated==1, !is.na(trial_day)),
    id = patient_id,
    tstart = trial_day-1,
    tstop = pmin(tte_censor, tte_outcome, na.rm=TRUE),
    ind_outcome = event(tte_outcome)
  ) %>%
    tmerge( # create treatment timescale variables
      data1 = .,
      data2 = postvax_time %>% filter(treated==1),
      id = patient_id,
      timesincerecruitment_pw = tdc(fup_day-1+trial_day, timesincerecruitment_pw)
    )


  # add post-treatment time + outcome time for controls
  data_st0 <- tmerge(
    data1 = data_samples %>% filter(treated==0, !is.na(trial_day)),
    data2 = data_samples %>% filter(treated==0, !is.na(trial_day)),
    id = patient_id,
    tstart = trial_day-1,
    tstop = pmin(tte_censor, tte_outcome, na.rm=TRUE),
    ind_outcome = event(tte_outcome)
  ) %>%
    tmerge( # create treatment timescale variables
      data1 = .,
      data2 = postvax_time %>% filter(treated==0),
      id = patient_id,
      timesincerecruitment_pw = tdc(fup_day-1+trial_day, timesincerecruitment_pw)
    )


  # combine all data
  data_st <- bind_rows(data_st1, data_st0) %>%
    left_join(
      # add baseline info on day of recruitment
      data_pt_sub %>% select(-tstart),
      by=c("patient_id", "trial_day" = "tstop")
    ) %>%
    mutate(
      fup_day = tstart,
      tstart=tstart-trial_day+1,
      tstop=tstop-trial_day+1
    ) %>%
    select(-starts_with("tte"))
  if(removeobs) rm(data_samples, data_pt_sub, data_fixed, data_st0, data_st1)

  # outcome frequency
  table(data_st$timesincerecruitment_pw, data_st$treated, data_st$ind_outcome)


  ### print dataset size ----
  cat(glue("data_st data size = ", nrow(data_st)), "\n  ")
  cat(glue("data_st patient size = ", n_distinct(data_st$patient_id)), "\n  ")
  cat(glue("memory usage = ", format(object.size(data_st), units="GB", standard="SI", digits=3L)), "\n  ")


  # define model formulae

  # unadjusted
  formula_vaxonly <- Surv(tstart, tstop, ind_outcome) ~ treated:strata(timesincerecruitment_pw)

  # space - time adjustments
  formula_spacetime <- . ~ . + strata(region) * ns(trial_day, 3)
  formula_spacetime <- . ~ . + strata(region) + strata(trial_day)

  formula0_pw <- formula_vaxonly
  formula1_pw <- formula_vaxonly %>% update(formula_spacetime)
  formula2_pw <- formula_vaxonly %>% update(formula_spacetime) %>% update(formula_demog)
  formula3_pw <- formula_vaxonly %>% update(formula_spacetime) %>% update(formula_demog) %>% update(formula_comorbs)
  formula4_pw <- formula_vaxonly %>% update(formula_spacetime) %>% update(formula_demog) %>% update(formula_comorbs) %>% update(formula_timedependent) %>% update(formula_remove_postest)


  model_descr = c(
    "Unadjusted" = "0",
    "Adjusting for time" = "1",
    "Adjusting for time + demographics" = "2",
    "Adjusting for time + demographics + clinical" = "3",
    "Adjusting for time + demographics + clinical + time-dependent" = "4"
  )

  # Sequential trial models ----

  opt_control <- coxph.control(iter.max = 30)

  cox_model <- function(number, formula_cox){
    # fit a time-dependent cox model and output summary functions
    coxmod <- coxph(
      formula = formula_cox,
      data = data_st,
      #robust = TRUE,
      id = patient_id,
      na.action = "na.fail",
      control = opt_control
    )

    print(warnings())
    # logoutput(
    #   glue("model{number} data size = ", coxmod$n),
    #   glue("model{number} memory usage = ", format(object.size(coxmod), units="GB", standard="SI", digits=3L)),
    #   glue("convergence status: ", coxmod$info[["convergence"]])
    # )

    tidy <-
      broom.helpers::tidy_plus_plus(
        coxmod,
        exponentiate = FALSE
      ) %>%
      add_column(
        model = number,
        .before=1
      )

    glance <-
      broom::glance(coxmod) %>%
      add_column(
        model = number,
        convergence = coxmod$info[["convergence"]],
        ram = format(object.size(coxmod), units="GB", standard="SI", digits=3L),
        .before = 1
      )

    coxmod$data <- NULL
    write_rds(coxmod, here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue("stcox_model{number}.rds")), compress="gz")

    lst(glance, tidy)
  }


  summary0 <- cox_model(0, formula0_pw)
  summary1 <- cox_model(1, formula1_pw)
  summary2 <- cox_model(2, formula2_pw)
  summary3 <- cox_model(3, formula3_pw)
  summary4 <- cox_model(4, formula4_pw)


  # combine results
  model_glance <-
    bind_rows(summary0$glance, summary1$glance, summary2$glance, summary3$glance, summary4$glance) %>%
    mutate(
      model_descr = fct_recode(as.character(model), !!!model_descr),
      outcome = outcome
    )
  write_csv(model_glance, here::here("output", cohort, strata_var, recentpostest_period, brand, outcome,  glue("stcox_glance.csv")))

  model_tidy <- bind_rows(summary0$tidy, summary1$tidy, summary2$tidy, summary3$tidy, summary4$tidy) %>%
    mutate(
      model_descr = fct_recode(as.character(model), !!!model_descr),
      outcome = outcome
    )
  write_csv(model_tidy, here::here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue("stcox_tidy.csv")))
  write_rds(model_tidy, here::here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue("stcox_tidy.rds")))

}
