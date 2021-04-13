
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
library('gtsummary')
library('gt')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)

cohort <- args[[1]]
strata_var <- args[[2]]

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  strata_var <- "all"
}


outcome <- "vaccination"

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


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "data", "list_formula.rds"))
list2env(list_formula, globalenv())

formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))



## table and plot functions ----

##  Create big loop over all categories

strata <- read_rds(here::here("output", "data", "list_strata.rds"))[[strata_var]]
summary_list <- vector("list", length(strata))
names(summary_list) <- strata


for(stratum in strata){

  data_cox_sub <- read_rds(here::here("output", cohort, outcome, strata_var, stratum, "data_cox_sub.rds"))

  # import models ----
    coxmod1 <- read_rds(here::here("output", cohort, outcome, strata_var, stratum, "vaxmodelcox1.rds"))
    coxmod2 <- read_rds(here::here("output", cohort, outcome, strata_var, stratum, "vaxmodelcox2.rds"))
    coxmod3 <- read_rds(here::here("output", cohort, outcome, strata_var, stratum, "vaxmodelcox3.rds"))

    ## output model coefficients

    tab_coxmod1 <- gtsummary::tbl_regression(coxmod1)
    gtsave(tab_coxmod1 %>% as_gt(), here::here("output", cohort, outcome, strata_var, stratum, "tab_vaxcoxmod1.html"))
    write_csv(tab_coxmod1$table_body, here::here("output", cohort, outcome, strata_var, stratum, "tab_vaxcoxmod1.csv"))

    ##output forest plot
    plot_coxmod1 <- survminer::ggforest(coxmod1, data=data_cox_sub)
    ggsave(
      here::here("output", cohort, outcome, strata_var, stratum, "plot_vaxcoxmod1.svg"),
      plot_coxmod1,
      units="cm", width=20, height=25
    )


    tab_coxmod2 <- gtsummary::tbl_regression(coxmod2)
    gtsave(tab_coxmod2 %>% as_gt(), here::here("output", cohort, outcome, strata_var, stratum, "tab_vaxcoxmod2.html"))
    write_csv(tab_coxmod2$table_body, here::here("output", cohort, outcome, strata_var, stratum, "tab_vaxcoxmod2.csv"))

    ##output forest plot
    plot_coxmod2 <- survminer::ggforest(coxmod2, data=data_cox_sub)
    ggsave(
      here::here("output", cohort, outcome, strata_var, stratum, "plot_vaxcoxmod2.svg"),
      plot_coxmod2,
      units="cm", width=20, height=25
    )


    tab_coxmod3 <- gtsummary::tbl_regression(coxmod3)
    gtsave(tab_coxmod3 %>% as_gt(), here::here("output", cohort, outcome, strata_var, stratum, "tab_vaxcoxmod3.html"))
    write_csv(tab_coxmod3$table_body, here::here("output", cohort, outcome, strata_var, stratum, "tab_vaxcoxmod3.csv"))

    ##output forest plot
    plot_coxmod3 <- survminer::ggforest(coxmod3, data=data_cox_sub %>% mutate(`strata(region)`=region))

    ggsave(
      here::here("output", cohort, outcome, strata_var, stratum, "plot_vaxcoxmod3.svg"),
      plot_coxmod3,
      units="cm", width=20, height=30
    )

    age_contrast <- termplot(
      coxmod3,
      #data=data_cox_sub,
      terms="poly(age, degree = 2, raw = TRUE)",
      se=TRUE, reference="sample", xlabs="Age", ylabs="log hazard ratio",
      plot=FALSE
    ) %>% as.data.frame() %>%
      mutate(
        age.y.ll = age.y-(age.se*1.96),
        age.y.ul = age.y+(age.se*1.96),
        centre = first(age.y),
        hr = exp(age.y - centre),
        hr.ll = exp(age.y.ll - centre),
        hr.ul = exp(age.y.ul - centre),
      )

    age_plot <- ggplot(age_contrast) +
      geom_line(aes(x=age.x, y=hr))+
      geom_ribbon(aes(x=age.x, ymin=hr.ll, ymax=hr.ul), colour="transparent", fill="grey", alpha=0.3)+
      scale_y_log10()+
      labs(x="age", y="hazard ratio")+
      theme_bw()


    ggsave(
      here::here("output", cohort, outcome, strata_var, stratum, "plot_vaxcoxmod3_age.svg"),
      plot=age_plot,

    )
}


## plot HR contrast by age ----

# Greg::plotHR(coxmod2, term="age", xlim=c(80,110), cntrst=FALSE)

# png(filename=here::here("output", cohort, outcome, strata_var, stratum, "plot_vaxcoxmod3_age.png"))
# termplot(
#   coxmod3,
#   #data=data_cox_sub,
#   terms="poly(age, degree = 2, raw = TRUE)",
#   se=TRUE, reference="sample", xlabs="Age", ylabs="log hazard ratio",
#   plot=TRUE
# )
# dev.off()


warnings()
