
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



if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"
  outcome <- "postest"
  brand <- "any"
  strata_var <- "all"
} else {
  removeobs <- TRUE
  cohort <- args[[1]]
  outcome <- args[[2]]
  brand <- args[[3]]
  strata_var <- args[[4]]
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

# Import metadata for outcome ----
## these are created in data_define_cohorts.R script

metadata_outcomes <- read_rds(here::here("output", "data", "metadata_outcomes.rds"))
stopifnot("outcome does not exist" = (outcome %in% metadata_outcomes[["outcome"]]))
metadata_outcomes <- metadata_outcomes[metadata_outcomes[["outcome"]]==outcome, ]

list2env(metadata_outcomes, globalenv())

### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "data", "list_formula.rds"))
list2env(list_formula, globalenv())

formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))

## if outcome is positive test, remove time-varying positive test info from covariate set
if(outcome=="postest"){
  formula_remove_postest <- as.formula(". ~ . - timesince_postest_pw")
} else{
  formula_remove_postest <- as.formula(". ~ .")
}





## table and plot functions ----

gt_model_summary <- function(model, cluster) {


  covar_labels = list(
    `age, degree = 2` ~ "Age",
    sex ~ "Sex",
    imd ~ "Deprivation",
    ethnicity_combined ~ "Ethnicity",

    bmi ~ "Body Mass Index",
    heart_failure ~ "Heart failure",
    other_heart_disease ~ "Other heart disease",

    dialysis ~ "Dialysis",
    diabetes ~ "Diabetes",
    chronic_liver_disease ~ "Chronic liver disease",

    current_copd ~ "COPD",
    #cystic_fibrosis ~ "Cystic fibrosis",
    other_resp_conditions ~ "Other respiratory conditions",

    lung_cancer ~ "Lung Cancer",
    haematological_cancer ~ "Haematological cancer",
    cancer_excl_lung_and_haem ~ "Cancer excl. lung, haemo",

    #chemo_or_radio ~ "Chemo- or radio-therapy",
    #solid_organ_transplantation ~ "Solid organ transplant",
    #bone_marrow_transplant ~ "Bone marrow transplant",
    #sickle_cell_disease ~ "Sickle Cell Disease",
    #permanant_immunosuppression ~ "Permanent immunosuppression",
    #temporary_immunosuppression ~ "Temporary Immunosuppression",
    #asplenia ~ "Asplenia",
    #dmards ~ "DMARDS",
    any_immunosuppression ~ "Immunosuppressed",

    dementia ~ "Dementia",
    other_neuro_conditions ~ "Other neurological conditions",

    LD_incl_DS_and_CP ~ "Learning disabilities",
    psychosis_schiz_bipolar ~ "Serious mental illness",

    multimorb ~ "Morbidity count",
    shielded ~ "Shielding criteria met",

    flu_vaccine ~ "Flu vaccine in previous 5 years",

    efi_cat ~ "Frailty",

    timesince_hospinfectiousdischarge_pw ~ "Time since discharge from infectious hosp admission",
    timesince_hospnoninfectiousdischarge_pw ~ "Time since discharge from non-infectious hosp admission",
    #timesince_probablecovid_pw ~ "Time since probable COVID",
    timesince_suspectedcovid_pw ~ "Time since suspected COVID",
    timesince_postesttdc_pw ~ "Time since positive SARS-CoV-2 test"
  )

  ## if outcome is positive test, remove positive test label assumes it is the last one)
  if(outcome=="postest"){
    covar_labels <- covar_labels[-length(covar_labels)]
  }

  tbl_reg <- tbl_regression(
    x = model,
    pvalue_fun = ~style_pvalue(.x, digits=3),
    tidy_fun = partial(tidy_plr, cluster = cluster),
    include = -contains("ns(tstop"),
    label = covar_labels
  )

  tbl_reg$model_obj <- NULL
  tbl_reg$inputs <- NULL

  tbl_reg

}

forest_from_gt <- function(gt_obj, title){

  #jtools::plot_summs(ipwvaxany1)
  #modelsummary::modelplot(ipwvaxany1, coef_omit = 'Interc|tstop', conf.type="wald", exponentiate=TRUE)
  #sjPlot::plot_model(ipwvaxany1)
  #all these methods use broom::tidy to get the coefficients. but tidy.glm only uses profile CIs, not Wald. (yTHO??)
  #profile CIs will take forever on large datasets.
  #so need to write custom function for plotting wald CIs. grr


  plot_data <- gt_obj %>%
  as_gt() %>%
    .$`_data` %>%
    filter(
      !str_detect(variable,fixed("ns(tstop")),
      !str_detect(variable,fixed("region")),
      !is.na(term)
    ) %>%
    mutate(
      var_label = if_else(row_type=="label", "", var_label),
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
    scale_x_log10(breaks=c(0.015625, 0.03125, 0.0625, 0.125, 0.25, 0.5, 1, 2, 4, 8), labels=c("1/64", "1/32", "1/16", "1/8", "1/4", "1/2", "1", "2", "4", "8"))+
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


##  Create big loop over all categories

strata <- read_rds(here::here("output", "data", "list_strata.rds"))[[strata_var]]

for(stratum in strata){

  # import models ----
  if(brand=="any"){

    #data_atrisk <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "data_atrisk_vaxany1.rds"))
    model_vaxany1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "model_vaxany1.rds"))
    ipw_formula <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "model_formula_vaxany1.rds"))
    assign(as.character(model_vaxany1$call$data), model_vaxany1$data) # alternative to `data_atrisk <- model_vaxany1$data` that ensures the right model name is used


    # rename model dataset to match name it had when first created, then remove oldname dataset
    #assign(as.character(model_vaxany1$call$data),data_atrisk_vaxany1)
    #rm(data_atrisk_vaxany1)

    ## output model coefficients
    tab_vaxany1 <- gt_model_summary(model_vaxany1, model_vaxany1$data$patient_id)
    write_rds(tab_vaxany1, here::here("output", cohort, outcome, brand, strata_var, stratum, "gt_vaxany1.rds"))

    gtsave(as_gt(tab_vaxany1), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_vaxany1.html"))
    write_csv(tab_vaxany1$table_body, here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_vaxany1.csv"))

    ##output forest plot
    plot_vaxany1 <- forest_from_gt(tab_vaxany1, "Predicting vaccination by any brand")
    ggsave(
      here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_vaxany1.svg"),
      plot_vaxany1,
      units="cm", width=20, height=25
    )

    ggsecular_vaxany1 <- interactions::interact_plot(
      model_vaxany1,
      pred=tstop, modx=region, data=model_vaxany1$data,
      colors="Set1", vary.lty=FALSE,
      x.label=glue::glue("Days since {as.Date(gbl_vars$start_date)+1}"),
      y.label=glue::glue("Death rate (mean-centered)")
    )
    ggsave(
      filename=here::here("output", cohort, outcome, brand, strata_var, "plot_vaxany1_trends.svg"),
      ggsecular_vaxany1,
      width=20, height=15, units="cm"
    )

    if(removeobs)
      rm(list= c(
        as.character(model_vaxany1$call$data),
        "ipw_formula", "model_vaxany1",
        "tab_vaxany1", "plot_vaxany1", "ggsecular_vaxany1"
      ))

  }

  if(brand!="any"){

    # pfizer
    model_vaxpfizer1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model_vaxpfizer1.rds")))
    ipw_formula <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "model_formula_vaxpfizer1.rds"))
    assign(as.character(model_vaxpfizer1$call$data), model_vaxpfizer1$data)

    tab_vaxpfizer1 <- gt_model_summary(model_vaxpfizer1, model_vaxpfizer1$data$patient_id)
    gtsave(as_gt(tab_vaxpfizer1), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_vaxfizer1.html"))
    write_rds(tab_vaxpfizer1, here::here("output", cohort, outcome, brand, strata_var, stratum, "gt_vaxpfizer1.rds"), compress="gz")
    write_csv(tab_vaxpfizer1$table_body, here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_vaxpfizer1.csv"))

    plot_vaxpfizer1 <- forest_from_gt(tab_vaxpfizer1, "Predicting P-BNT vaccine")
    ggsave(
      here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_vaxfizer1.svg"),
      plot_vaxpfizer1,
      units="cm", width=20, height=25
    )

    ggsecular_vaxpfizer1 <- interactions::interact_plot(
      model_vaxpfizer1,
      pred=tstop, modx=region, data=model_vaxpfizer1$data,
      colors="Set1", vary.lty=FALSE,
      x.label=glue::glue("Days since {as.Date(gbl_vars$start_date)+1}"),
      y.label=glue::glue("Death rate (mean-centered)")
    )
    ggsave(
      filename=here::here("output", cohort, outcome, brand, strata_var, "plot_vaxpfizer1_trends.svg"),
      ggsecular_vaxpfizer1,
      width=20, height=15, units="cm"
    )

    if(removeobs)
      rm(list= c(
        as.character(model_vaxpfizer1$call$data),
        "ipw_formula", "model_vaxpfizer1",
        "plot_vaxpfizer1", "ggsecular_vaxpfizer1"
      ))

    # AZ
    model_vaxaz1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model_vaxaz1.rds")))
    ipw_formula <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "model_formula_vaxaz1.rds"))
    assign(as.character(model_vaxaz1$call$data), model_vaxaz1$data)

    tab_vaxaz1 <- gt_model_summary(model_vaxaz1, model_vaxaz1$data$patient_id)
    gtsave(as_gt(tab_vaxaz1), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_vaxaz1.html"))
    write_rds(tab_vaxaz1, here::here("output", cohort, outcome, brand, strata_var, stratum, "gt_vaxaz1.rds"), compress="gz")
    write_csv(tab_vaxaz1$table_body, here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_vaxaz1.csv"))

    plot_vaxaz1 <- forest_from_gt(tab_vaxaz1, "Predicting Ox-AZ vaccine")
    ggsave(
      here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_vaxaz1.svg"),
      plot_vaxaz1,
      units="cm", width=20, height=25
    )

    ggsecular_vaxaz1 <- interactions::interact_plot(
      model_vaxaz1,
      pred=tstop, modx=region, data=model_vaxaz1$data,
      colors="Set1", vary.lty=FALSE,
      x.label=glue::glue("Days since {as.Date(gbl_vars$start_date)+1}"),
      y.label=glue::glue("Death rate (mean-centered)")
    )
    ggsave(
      filename=here::here("output", cohort, outcome, brand, strata_var, "plot_vaxaz1_trends.svg"),
      ggsecular_vaxaz1,
      width=20, height=15, units="cm"
    )


    if(removeobs)
      rm(list= c(
        as.character(model_vaxaz1$call$data),
        "ipw_formula", "model_vaxaz1",
        "plot_vaxaz1", "ggsecular_vaxaz1"
      ))


    # combine tables
    tbl_merge(list(tab_vaxpfizer1, tab_vaxaz1), tab_spanner = c("Pfizer", "AstraZeneca")) %>%
      as_gt() %>%
      gtsave(here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_pfizer_az.html"))

    if(removeobs) rm("tab_vaxpfizer1", "tab_vaxaz1")
  }




  if(outcome!="death"){
    model_death <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "model_death.rds"))
    ipw_formula <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "model_formula_death.rds"))
    assign(as.character(model_death$call$data), model_death$data)


    ## output model coefficients
    tab_death <- gt_model_summary(model_death, model_death$data$patient_id)
    gtsave(as_gt(tab_death), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_death.html"))
    write_csv(tab_death$table_body, here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_death.csv"))

    ##output forest plot
    plot_death <- forest_from_gt(tab_death, "Predicting death")
    ggsave(
      here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_death.svg"),
      plot_death,
      units="cm", width=20, height=25
    )

    ggsecular_death <- interactions::interact_plot(
      model_death,
      pred=tstop, modx=region, data=model_death$data,
      colors="Set1", vary.lty=FALSE,
      x.label=glue::glue("Days since {as.Date(gbl_vars$start_date)+1}"),
      y.label=glue::glue("Death rate (mean-centered)")
    )

    ggsave(
      filename=here::here("output", cohort, outcome, brand, strata_var, "plot_death_trends.svg"),
      ggsecular_death,
      width=20, height=15, units="cm"
    )

    if(removeobs)
      rm(list= c(
        as.character(model_death$call$data),
        "ipw_formula", "model_death",
        "tab_death", "plot_death", "ggsecular_death"
      ))
  }

}

warnings()
