
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports fitted IPW models
# calculates robust CIs taking into account patient-level clustering
# outputs forest plots for these models
#
# The script should only be run via an action in the project.yaml only
# The script must be accompanied by four arguments: cohort, outcome, brand, and stratum
# # # # # # # # # # # # # # # # # # # # #


# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')
library('splines')
library('parglm')
library('gtsummary')
library('gt')
library("sandwich")
library("lmtest")

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)

cohort <- args[[1]]
outcome <- args[[2]]
brand <- args[[3]]
strata_var <- args[[4]]

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  outcome <- "postest"
  brand <- "az"
  strata_var <- "all"
}



# import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)


# Import metadata for cohort ----

metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))
metadata_cohorts <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort, ]

list2env(metadata_cohorts, globalenv())

# Import metadata for outcome ----

metadata_outcomes <- read_rds(here::here("output", "data", "metadata_outcomes.rds"))
stopifnot("outcome does not exist" = (outcome %in% metadata_outcomes[["outcome"]]))
metadata_outcomes <- metadata_outcomes[metadata_outcomes[["outcome"]]==outcome, ]

list2env(metadata_outcomes, globalenv())

## define model hyper-parameters and characteristics ----

### model names ----


## or equivalently:
# cohort <- metadata_cohorts$cohort
# cohort_descr <- metadata_cohorts$cohort_descr
# outcome <- metadata_cohorts$outcome
# outcome_descr <- metadata_cohorts$outcome_descr

### post vax time periods ----

postvaxcuts <- c(0, 1, 4, 7, 14, 21) # use if coded as days
#postvaxcuts <- c(0, 1, 2, 3) # use if coded as weeks

### knot points for calendar time splines ----
#knots <- c(21, 28)

### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "data", "list_formula.rds"))
list2env(list_formula, globalenv())

formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))

##  Create big loop over all categories

strata <- read_rds(here::here("output", cohort, outcome, brand, strata_var, "strata_vector.rds"))
summary_list <- vector("list", length(strata))
names(summary_list) <- strata





## table and plot functions

gt_model_summary <- function(model, cluster) {


  tbl_regression(
    x = model,
    pvalue_fun = ~style_pvalue(.x, digits=3),
    tidy_fun = partial(tidy_plr, cluster = cluster),
    include = -contains("ns"),
    label = list(
      age ~ "Age",
      `I(age * age)` ~ "Age-squared",
      sex ~ "Sex",
      imd ~ "Deprivation",
      ethnicity ~ "Ethnicity",
      region ~ "Region",
      chronic_cardiac_disease ~ "Chronic cardiac disease",
      current_copd ~ "Current COPD",
      dementia ~ "Dementia",
      dialysis ~ "Dialysis",
      diabetes ~ "Diabetes",
      chemo_or_radio ~ "Chemo- or radio-therapy",
      permanant_immunosuppression ~ "Permanent immunosuppression",
      asplenia ~ "Asplenia",
      dmards ~ "DMARDS",
      psychosis_schiz_bipolar ~ "Pyschosis, Schiz., biploar",
      # LD_incl_DS_and_CP ~ "Learning disability, incl. DS and CP",
      lung_cancer ~ "Lung cancer",
      haematological_cancer ~ "Haematological cancer",
      cancer_excl_lung_and_haem ~ "Other cancers",
      flu_vaccine ~ "Flu vaccine last 5 years",
      hospital_status ~ "In-hospital",
      timesince_probable_covid_pw ~ "Time since probable COVID",
      timesince_suspected_covid_pw ~ "Time since suspected COVID"
    )
  )

}

forest_from_gt <- function(gt_obj){

  #all these methods use broom to get the coefficients. but tidy.glm only uses profile CIs, not Wald. (yTHO??)
  #profile CIs will take forever on large datasets.
  #so need to write custom function for plotting wald CIs. grr
  #jtools::plot_summs(ipwvaxany1)
  #modelsummary::modelplot(ipwvaxany1, coef_omit = 'Interc|tstop', conf.type="wald", exponentiate=TRUE)
  #sjPlot::plot_model(ipwvaxany1)

  gt_obj %>%
  as_gt() %>%
  .$`_data` %>%
    filter(
      !str_detect(variable,"ns"),
      !is.na(term)
    ) %>%
    mutate(
      label = if_else(row_type=="label", "", label),
      var_label = fct_inorder(var_label)
    ) %>%
    group_by(var_label) %>%
    mutate(
      label=fct_rev(fct_inorder(label))
    ) %>%
    ungroup() %>%
    droplevels() %>%
    ggplot() +
    geom_point(aes(x=or, y=label)) +
    geom_linerange(aes(xmin=or.ll, xmax=or.ul, y=label)) +
    facet_grid(rows=vars(var_label), scales="free_y", switch="y", space="free_y")+
    scale_x_log10(breaks=c(0.03125, 0.0625, 0.125, 0.25, 0.5, 1, 2, 4))+
    labs(
      y="Hazard ratio",
      x="",
      colour=NULL#,
      #title=glue::glue("{outcome_descr} by time since first {brand} vaccine"),
      #subtitle=cohort_descr
    ) +
    theme_minimal() +
    theme(
      strip.placement = "outside",
      strip.background = element_rect(fill="transparent", colour="transparent"),
      strip.text.y.left = element_text(angle = 0, hjust=1)
    )
}



for(stratum in strata){

  # import models ----
  if(brand=="any"){

    data_pt_atriskvaxany1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwvaxany1.rds"))
    ipwvaxany1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "model_ipwvaxany1.rds"))

    ## output model coefficients

    tab_ipwvaxany1 <- gt_model_summary(ipwvaxany1, data_pt_atriskvaxany1$patient_id)
    gtsave(tab_ipwvaxany1 %>% as_gt(), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwvaxany1.html"))

    ##output forest plot
    plot_ipwvaxany1 <- forest_from_gt(tab_ipwvaxany1)
    ggsave( here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_ipwvaxany1.svg"),  plot_ipwvaxany1)


  }

  if(brand!="any"){

    # pfizer
    data_pt_atriskvaxpfizer1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwvaxpfizer1.rds"))
    ipwvaxpfizer1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model_ipwvaxpfizer1.rds")))

    tab_ipwvaxpfizer1 <- gt_model_summary(ipwvaxpfizer1, data_pt_atriskvaxpfizer1$patient_id)
    gtsave(tab_ipwvaxpfizer1 %>% as_gt(), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwvaxfizer1.html"))

    ##output forest plot
    plot_ipwvaxpfizer1 <- forest_from_gt(tab_ipwvaxpfizer1)
    ggsave(here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_ipwvaxfizer1.svg"),  plot_ipwvaxpfizer1)

    # AZ
    data_pt_atriskvaxaz1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwvaxaz1.rds"))
    ipwvaxaz1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model_ipwvaxaz1.rds")))

    tab_ipwvaxaz1 <- gt_model_summary(ipwvaxaz1, data_pt_atriskvaxaz1$patient_id)
    gtsave(tab_ipwvaxaz1 %>% as_gt(), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwvaxaz1.html"))

    ##output forest plot
    plot_ipwvaxaz1 <- forest_from_gt(tab_ipwvaxaz1)
    ggsave( here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_ipwvaxaz1.svg"),  plot_ipwvaxaz1)

    # combine tables
    tbl_merge(list(tab_ipwvaxpfizer1, tab_ipwvaxaz1), tab_spanner = c("Pfizer", "AstraZeneca")) %>%
      as_gt() %>%
      gtsave(here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_pfizer_az.html"))

  }


  data_pt_atriskdeath <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwdeath.rds"))
  ipwdeath <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "model_ipwdeath.rds"))

  ## output model coefficients

  tab_ipwdeath <- gt_model_summary(ipwdeath, data_pt_atriskdeath$patient_id)
  gtsave(tab_ipwdeath %>% as_gt(), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwdeath.html"))

  ##output forest plot
  plot_ipwdeath <- forest_from_gt(tab_ipwdeath)
  ggsave(here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_ipwdeath.svg"),  plot_ipwdeath)


}
