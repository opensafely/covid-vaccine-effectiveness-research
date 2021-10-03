
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits some marginal structural models for vaccine effectiveness, with different adjustment sets
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by seven arguments:
# 1. the name of the cohort
# 2. the stratification variable. Use "all" if no stratification
# 3. the duration of time from positive test over which to exclude vaccinations from the exposure. This changes the causal estimand, but allows estimation of covid-19 specific mortality
# 4. the name of the outcome
# 5. the name of the brand (currently "any", "az",or "pfizer")
# 6. the sample size for the vaccination models (a completely random sample of participants)
# 7. the sample size for those who did not experience the outcome for the main MSM models (all those who did experience an outcome are included)
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('survival')
library('splines')
library('parglm')
library('gtsummary')
library('gt')
library("sandwich")
library("lmtest")

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
  ipw_sample_random_n <- 20000 # vax models use less follow up time because median time to vaccination (=outcome) is ~ 30 days
} else {
  removeobs <- TRUE
  cohort <- args[[1]]
  strata_var <- args[[2]]
  recentpostest_period <- as.numeric(args[[3]])
  ipw_sample_random_n <- as.integer(args[[4]])
}

outcome<-"death"

### define parglm optimisation parameters ----

parglmparams <- parglm.control(
  method = "LINPACK",
  nthreads = 8,
  maxit = 40 # default = 25
)


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

characteristics <- read_rds(here("output", "metadata", "baseline_characteristics.rds"))
characteristics$age <- `age, degree = 2` ~ "Age"
characteristics[[strata_var]] <- NULL


# create output directories ----
fs::dir_create(here("output", cohort, strata_var, recentpostest_period, "combined"))


# function to calculate weights for treatment model ----
## if exposure is any vaccine, then create model for vaccination by any brand + model for death for censoring weights
## if exposure is pfizer vaccine, then create model for vaccination by pfizer + model for az and model for death for censoring weights
## if exposure is az vaccine, then create model for vaccination by az + model for pfizer and model death for censoring weights
get_baseline_HR <- function(
  data,
  event,
  event_status,
  event_atrisk,

  sample_type,
  sample_amount,

  ipw_formula_fxd,

  stratum
){

  stopifnot(sample_type %in% c("random_n"))

  name <- str_remove(event_atrisk, "_atrisk")

  data_atrisk <- data %>%
    mutate(
      event = data[[event]],
      event_status = data[[event_status]],
      event_atrisk = data[[event_atrisk]],
    ) %>%
    filter(event_atrisk)

    data_sample <- data_atrisk %>%
      group_by(patient_id) %>%
      summarise() %>%
      ungroup() %>%
      transmute(
        patient_id,
        sample_event = sample_random_n(patient_id, sample_amount),
        sample_weights_event = sample_event*1L,
      )

  data_atrisk_sample <- data_atrisk %>%
    left_join(data_sample, by="patient_id") %>%
    filter(sample_event)

  rm("data_sample")

  #apply jeffrey's prior to fitted model
  #library('brglm2')
  #event_model <- update(event_model, method = "brglmFit", type = "MPL_Jeffreys")

  ### without time-updating covariates ----

  cat("  \n")
  cat(glue("{event}_fxd  \n"))
  event_model_fxd <- parglm(
    formula = ipw_formula_fxd,
    data = data_atrisk_sample,
    family = binomial,
    weights = sample_weights_event,
    control = parglmparams,
    na.action = "na.fail",
    model = FALSE
  )

  #event_model_fxd$data <- NULL

  cat(glue("{event}_fxd data size = ", length(event_model_fxd$y)), "\n")
  cat(glue("memory usage = ", format(object.size(event_model_fxd), units="GB", standard="SI", digits=3L)), "\n")
  cat("warnings: ", "\n")
  print(warnings())

  #write_rds(data_atrisk, here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue("data_atrisk_{event}.rds")), compress="gz")
  write_rds(event_model_fxd, here("output", cohort, strata_var, recentpostest_period, "combined", glue("modelvax_{name}_{stratum}_fxd.rds")), compress="gz")
  write_rds(ipw_formula_fxd, here("output", cohort, strata_var, recentpostest_period, "combined", glue("modelvax_formula{outcome}_{outcome}_{name}_{stratum}_fxd.rds")), compress="gz")


  rm("data_atrisk_sample")
  event_model_fxd

}



broom_model_summary <- function(model, cluster, stratum) {

  covar_labels <- unname(characteristics)

  tbl_reg <- broom.helpers::tidy_plus_plus(
    model = model,
    tidy_fun = partial(tidy_plr, cluster = cluster),
    include = -contains("ns(tstop"),
    variable_labels = covar_labels
  ) %>%
    add_column(
      strata=stratum,
      .before=1
    )

}

#broom_model_summary(model_vaxany1, model_vaxany1$data$patient_id)


gt_from_broom <- function(broom_obj, title){

  gt_data <- broom_obj %>%
    filter(
      !str_detect(variable,fixed("ns(tstop")),
      !str_detect(variable,fixed("region")),
      !is.na(term)
    ) %>%
    group_by(var_label) %>%
    mutate(
      characteristic = if_else(row_number()==1, var_label, ""),
      df = n(),
      label = if_else(df!=1, label, ""),
    ) %>%
    ungroup() %>%
    transmute(
      characteristic,
      label,
      or,
      or.ll,
      or.ul,
      p.value
    ) %>%
    gt(
      #groupname_col="var_label"
    ) %>%
    cols_label(
      characteristic = "Characteristic",
      or = "HR",
      or.ll = "95% CI",
      p.value = "P value",
    ) %>%
    fmt_number(
      columns = starts_with(c("or")),
      decimals = 2
    ) %>%
    fmt(
      columns = all_of("p.value"),
      fns = function(x){gtsummary::style_pvalue(x, digits=3)}
    ) %>%
    cols_merge_range("or.ll", "or.ul", sep = "--", autohide = TRUE) %>%
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
      columns = "characteristic"
    )


  gt_data

}

forest_from_broom <- function(broom_obj, title){

  #jtools::plot_summs(ipwvaxany1)
  #modelsummary::modelplot(ipwvaxany1, coef_omit = 'Interc|tstop', conf.type="wald", exponentiate=TRUE)
  #sjPlot::plot_model(ipwvaxany1)
  #all these methods use broom::tidy to get the coefficients. but tidy.glm only uses profile CIs, not Wald. (yTHO??)
  #profile CIs will take forever on large datasets.
  #so need to write custom function for plotting wald CIs. grr


  plot_data <- broom_obj %>%
    filter(
      !str_detect(variable,fixed("ns(tstop")),
      !str_detect(variable,fixed("region")),
      !is.na(term)
    ) %>%
    mutate(
      var_label = if_else(var_class=="integer", "", var_label),
      label = if_else(reference_row %in% TRUE, paste0(label, " (ref)"),label),
      or = if_else(reference_row %in% TRUE, 1, or),
      variable = fct_inorder(variable),
      variable_card = as.numeric(variable)%%2,
    ) %>%
    group_by(variable) %>%
    mutate(
      variable_card = if_else(row_number()!=1, 0, variable_card),
      level = fct_rev(fct_inorder(paste(variable, label, sep="__"))),
      level_label = label
    ) %>%
    ungroup() %>%
    droplevels()

  var_lookup <- plot_data$var_label
  names(var_lookup) <- plot_data$variable

  level_lookup <- plot_data$level
  names(level_lookup) <- plot_data$level_label

  ggplot(plot_data) +
    geom_point(aes(x=or, y=level)) +
    geom_linerange(aes(xmin=or.ll, xmax=or.ul, y=level)) +
    geom_vline(aes(xintercept=1), colour='black', alpha=0.8)+
    facet_grid(rows=vars(variable), scales="free_y", switch="y", space="free_y", labeller = labeller(variable = var_lookup))+
    scale_x_log10(breaks=c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5))+
    scale_y_discrete(breaks=level_lookup, labels=names(level_lookup))+
    geom_rect(aes(alpha = variable_card), xmin = -Inf,xmax = Inf, ymin = -Inf, ymax = Inf, fill='grey', colour="transparent") +
    scale_alpha_continuous(range=c(0,0.3), guide=FALSE)+
    labs(
      y="",
      x="Hazard ratio",
      colour=NULL,
      title=title
      #subtitle=cohort_descr
    ) +
    theme_minimal() +
    theme(
      strip.placement = "outside",
      strip.background = element_rect(fill="transparent", colour="transparent"),
      strip.text.y.left = element_text(angle = 0, hjust=1),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.spacing = unit(0, "lines")
    )
}





##  Create big loop over all strata

strata <- read_rds(here("output", "metadata", "list_strata.rds"))[[strata_var]]

for(stratum in strata){
  for(brand in c("any","pfizer", "az")){

  cat("  \n")
  cat(stratum, "  \n")
  cat("  \n")

  # Import processed data ----
  data_fixed <- read_rds(here("output", cohort, "data", glue("data_fixed.rds")))

  ## read and process person-time dataset -- do this _within_ loop so that it can be deleted just before models are run, to reduce RAM use
  data_pt_sub <- read_rds(here("output", cohort, "data", glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
    mutate(all = factor("all",levels=c("all"))) %>%
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
    )

  if(removeobs) rm(data_fixed)


  ### print dataset size ----
  cat(glue("data_pt_sub data size = ", nrow(data_pt_sub)), "\n  ")
  cat(glue("data_pt_sub patient size = ", n_distinct(data_pt_sub$patient_id)), "\n  ")
  cat(glue("memory usage = ", format(object.size(data_pt_sub), units="GB", standard="SI", digits=3L)), "\n  ")


    if(brand=="any"){
      # IPW model for any vaccination ----

      ipw_formula_fxd = update(vaxany1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var)
      model_vaxany1 <- get_baseline_HR(
        data_pt_sub, "vaxany1", "vaxany1_status", "vaxany1_atrisk",
        sample_type="random_n", sample_amount=ipw_sample_random_n,
        ipw_formula_fxd = ipw_formula_fxd,
        stratum = stratum
      )
      assign(as.character(model_vaxany1$call$data), model_vaxany1$data)
      broom_vaxany1 <- broom_model_summary(model_vaxany1, model_vaxany1$data$patient_id, stratum)
      write_csv(broom_vaxany1, here("output", cohort, strata_var, recentpostest_period, "combined", glue("broom_vaxany1_{stratum}_fxd.csv")))

      rm(model_vaxany1)
      plot_vaxany1 <- forest_from_broom(broom_vaxany1, "Predicting vaccination by any brand")
      ggsave(
        here("output", cohort, strata_var, recentpostest_period, "combined", glue("plot_vaxany1_{stratum}_fxd.svg")),
        plot_vaxany1,
        units="cm", width=20, height=25
      )
    }

  if(brand=="pfizer"){

    ipw_formula_fxd = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var)
    model_vaxpfizer1 <- get_baseline_HR(
      data_pt_sub, "vaxpfizer1", "vaxpfizer1_status", "vaxpfizer1_atrisk",
      sample_type="random_n", sample_amount=ipw_sample_random_n, # select no more than n non-outcome samples
      ipw_formula_fxd = ipw_formula_fxd,
      stratum = stratum
    )


    assign(as.character(model_vaxpfizer1$call$data), model_vaxpfizer1$data)
    broom_vaxpfizer1 <- broom_model_summary(model_vaxpfizer1, model_vaxpfizer1$data$patient_id, stratum)
    write_csv(broom_vaxpfizer1, here("output", cohort, strata_var, recentpostest_period, "combined", glue("broom_vaxpfizer1_{stratum}_fxd.csv")))

    rm(model_vaxpfizer1)
    plot_vaxpfizer1 <- forest_from_broom(broom_vaxpfizer1, "Predicting vaccination by pfizer")
    ggsave(
      here("output", cohort, strata_var, recentpostest_period, "combined", glue("plot_vaxpfizer1_{stratum}_fxd.svg")),
      plot_vaxpfizer1,
      units="cm", width=20, height=25
    )
  }

  if(brand=="az"){
    ipw_formula_fxd = update(vaxaz1 ~ 1, formula_demog) %>% update(formula_comorbs) %>% update(formula_secular_region) %>% update(formula_remove_strata_var)
    model_vaxaz1 <- get_baseline_HR(
      data_pt_sub, "vaxaz1", "vaxaz1_status", "vaxaz1_atrisk",
      sample_type="random_n", sample_amount=ipw_sample_random_n,
      ipw_formula_fxd = ipw_formula_fxd,
      stratum = stratum
    )

    assign(as.character(model_vaxaz1$call$data), model_vaxaz1$data)
    broom_vaxaz1 <- broom_model_summary(model_vaxaz1, model_vaxaz1$data$patient_id, stratum)
    write_csv(broom_vaxaz1, here("output", cohort, strata_var, recentpostest_period, "combined", glue("broom_vaxaz1_{stratum}_fxd.csv")))

    rm(model_vaxaz1)
    plot_vaxaz1 <- forest_from_broom(broom_vaxaz1, "Predicting vaccination by AZ")
    ggsave(
      here("output", cohort, strata_var, recentpostest_period, "combined", glue("plot_vaxaz1_{stratum}_fxd.svg")),
      plot_vaxaz1,
      units="cm", width=20, height=25
    )
  }

  }
  #if(removeobs) rm(data_pt_sub)
}


