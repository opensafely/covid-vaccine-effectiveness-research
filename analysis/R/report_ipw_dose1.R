
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
  brand <- "any"
  strata_var <- "all"
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







## table and plot functions ----

gt_model_summary <- function(model, cluster) {


  tbl_regression(
    x = model,
    pvalue_fun = ~style_pvalue(.x, digits=3),
    tidy_fun = partial(tidy_plr, cluster = cluster),
    include = -contains("ns(tstop"),
    label = list(
      age ~ "Age",
      `I(age * age)` ~ "Age-squared",
      sex ~ "Sex",
      imd ~ "Deprivation",
      ethnicity ~ "Ethnicity",
      region ~ "Region",

      bmi ~ "Body Mass Index",
      chronic_cardiac_disease ~ "Chronic cardiac disease",
      heart_failure ~ "Heart failure",
      other_heart_disease ~ "Other heart disease",

      dialysis ~ "Dialysis",
      diabetes ~ "Diabetes",
      chronic_liver_disease ~ "Chronic liver disease",

      current_copd ~ "COPD",
      cystic_fibrosis ~ "Cystic fibrosis",
      other_resp_conditions ~ "Other respiratory conditions",

      lung_cancer ~ "Lung Cancer",
      haematological_cancer ~ "Haematological cancer",
      cancer_excl_lung_and_haem ~ "Cancer excl. lung, haemo",

      chemo_or_radio ~ "Chemo- or radio-therapy",
      solid_organ_transplantation ~ "Solid organ transplant",
      #bone_marrow_transplant ~ "Bone marrow transplant",
      #sickle_cell_disease ~ "Sickle Cell Disease",
      permanant_immunosuppression ~ "Permanent immunosuppression",
      #temporary_immunosuppression ~ "Temporary Immunosuppression",
      asplenia ~ "Asplenia",
      dmards ~ "DMARDS",

      dementia ~ "Dementia",
      other_neuro_conditions ~ "Other neurological conditions",

      LD_incl_DS_and_CP ~ "Learning disability, incl. DS and CP",
      psychosis_schiz_bipolar ~ "Psychosis, Schizophrenia, Bipolar",

      flu_vaccine ~ "Flu vaccine in previous 5 years",

      timesince_probable_covid_pw ~ "Time since probable COVID",
      timesince_suspected_covid_pw ~ "Time since suspected COVID",
      timesince_hosp_discharge_pw ~ "Time since hospital discharge"
    )
  )

}

forest_from_gt <- function(gt_obj, title){

  #all these methods use broom to get the coefficients. but tidy.glm only uses profile CIs, not Wald. (yTHO??)
  #profile CIs will take forever on large datasets.
  #so need to write custom function for plotting wald CIs. grr
  #jtools::plot_summs(ipwvaxany1)
  #modelsummary::modelplot(ipwvaxany1, coef_omit = 'Interc|tstop', conf.type="wald", exponentiate=TRUE)
  #sjPlot::plot_model(ipwvaxany1)

  plot_data <- gt_obj %>%
  as_gt() %>%
    .$`_data` %>%
    filter(
      !str_detect(variable,fixed("ns(tstop")),
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
      label=fct_rev(fct_inorder(label)),
    ) %>%
    ungroup() %>%
    droplevels()

  lookup <- plot_data$var_label
  names(lookup) <- plot_data$variable

  ggplot(plot_data) +
    geom_point(aes(x=or, y=label)) +
    geom_linerange(aes(xmin=or.ll, xmax=or.ul, y=label)) +
    geom_vline(aes(xintercept=1), colour='black', alpha=0.8)+
    facet_grid(rows=vars(variable), scales="free_y", switch="y", space="free_y", labeller = labeller(variable = lookup))+
    scale_x_log10(breaks=c(0.03125, 0.0625, 0.125, 0.25, 0.5, 1, 2, 4, 8), labels=c("1/32", "1/16", "1/8", "/14", "1/2", "1", "2", "4", "8"))+
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

strata <- read_rds(here::here("output", cohort, outcome, brand, strata_var, "strata_vector.rds"))
summary_list <- vector("list", length(strata))
names(summary_list) <- strata


for(stratum in strata){

  # import models ----
  if(brand=="any"){

    data_pt_atriskvaxany1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwvaxany1.rds"))
    ipwvaxany1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "model_ipwvaxany1.rds"))

    ## output model coefficients

    tab_ipwvaxany1 <- gt_model_summary(ipwvaxany1, data_pt_atriskvaxany1$patient_id)
    gtsave(tab_ipwvaxany1 %>% as_gt(), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwvaxany1.html"))
    write_csv(tab_ipwvaxany1$table_body, here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwvaxany1.csv"))

    ##output forest plot
    plot_ipwvaxany1 <- forest_from_gt(tab_ipwvaxany1, "Predicting any vaccine")
    ggsave(
      here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_ipwvaxany1.svg"),
      plot_ipwvaxany1,
      units="cm", width=20, height=25
    )


  }

  if(brand!="any"){

    # pfizer
    data_pt_atriskvaxpfizer1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwvaxpfizer1.rds"))
    ipwvaxpfizer1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model_ipwvaxpfizer1.rds")))

    tab_ipwvaxpfizer1 <- gt_model_summary(ipwvaxpfizer1, data_pt_atriskvaxpfizer1$patient_id)
    gtsave(tab_ipwvaxpfizer1 %>% as_gt(), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwvaxfizer1.html"))
    write_csv(tab_ipwvaxpfizer1$table_body, here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwvaxpfizer1.csv"))

    ##output forest plot
    plot_ipwvaxpfizer1 <- forest_from_gt(tab_ipwvaxpfizer1, "Predicting Pfizer vaccine")
    ggsave(
      here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_ipwvaxfizer1.svg"),
      plot_ipwvaxpfizer1,
      units="cm", width=20, height=25
    )

    # AZ
    data_pt_atriskvaxaz1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, "data_ipwvaxaz1.rds"))
    ipwvaxaz1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model_ipwvaxaz1.rds")))

    tab_ipwvaxaz1 <- gt_model_summary(ipwvaxaz1, data_pt_atriskvaxaz1$patient_id)
    gtsave(tab_ipwvaxaz1 %>% as_gt(), here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwvaxaz1.html"))
    write_csv(tab_ipwvaxaz1$table_body, here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwvaxaz1.csv"))

    ##output forest plot
    plot_ipwvaxaz1 <- forest_from_gt(tab_ipwvaxaz1, "Predicting AZ vaccine")
    ggsave(
      here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_ipwvaxaz1.svg"),
      plot_ipwvaxaz1,
      units="cm", width=20, height=25
    )

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
  write_csv(tab_ipwdeath$table_body, here::here("output", cohort, outcome, brand, strata_var, stratum, "tab_ipwdeath.csv"))

  ##output forest plot
  plot_ipwdeath <- forest_from_gt(tab_ipwdeath, "Predicting death")
  ggsave(
    here::here("output", cohort, outcome, brand, strata_var, stratum, "plot_ipwdeath.svg"),
    plot_ipwdeath,
    units="cm", width=20, height=25
  )


}


warnings()
