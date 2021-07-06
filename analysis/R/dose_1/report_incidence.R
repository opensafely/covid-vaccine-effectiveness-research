
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports fitted MSMs
# calculates robust CIs taking into account patient-level clustering
# outputs forest plots for the primary vaccine-outcome relationship
# outputs plots showing model-estimated spatio-temporal trends
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
  cohort <- "over80s"
  outcome <- "covidadmitted"
  brand <- "any"
  strata_var <- "all"
  removeobs <- FALSE
} else {
  cohort <- args[[1]]
  outcome <- args[[2]]
  brand <- args[[3]]
  strata_var <- args[[4]]
  removeobs <- TRUE
}



# import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)

# Import metadata for outcome ----
## these are created in data_define_cohorts.R script

metadata_outcomes <- read_rds(here::here("output", "metadata", "metadata_outcomes.rds"))
stopifnot("outcome does not exist" = (outcome %in% metadata_outcomes[["outcome"]]))
metadata_outcomes <- metadata_outcomes[metadata_outcomes[["outcome"]]==outcome, ]

list2env(metadata_outcomes, globalenv())

### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())

formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))

##  Create big loop over all categories

strata <- read_rds(here::here("output", "metadata", "list_strata.rds"))[[strata_var]]
strata_names <- paste0("strata_",strata)
summary_list <- vector("list", length(strata))
names(summary_list) <- strata_names

for(stratum in strata){
  stratum_name <- strata_names[which(strata==stratum)]
  # Import processed data ----

  data_weights <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("data_weights.rds")))

  # import models ----

  #msmmod0 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model0.rds")))
  msmmod1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model1.rds")))
  msmmod2 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model2.rds")))
  #msmmod3 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model3.rds")))
  msmmod4 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model4.rds")))



  ### cumulative incidence curves
  survival_novax <- data_weights %>%
    mutate(timesincevax_pw="pre-vax") %>%
    transmute(
      patient_id,
      tstop,
      sample_weights,
      timesincevax_pw,
      outcome_prob1=predict(msmmod1, newdata=., type="response"),
      outcome_prob2=predict(msmmod2, newdata=., type="response"),
      outcome_prob4=predict(msmmod4, newdata=., type="response"),
      vax_status="Unvaccinated"
    )

  survival_vax <- data_weights %>%
    transmute(
      patient_id,
      tstop,
      sample_weights,
      timesincevax_pw = timesince_cut(tstop, postvaxcuts, "pre-vax"),
      outcome_prob1=predict(msmmod1, newdata=., type="response"),
      outcome_prob2=predict(msmmod2, newdata=., type="response"),
      outcome_prob4=predict(msmmod4, newdata=., type="response"),
      vax_status="Vaccinated"
    )

  curves <- bind_rows(survival_novax, survival_vax) %>%
    #marginalise over all patients
    group_by(vax_status, tstop) %>%
    summarise(
      outcome_prob1=weighted.mean(outcome_prob1, sample_weights),
      outcome_prob2=weighted.mean(outcome_prob2, sample_weights),
      outcome_prob4=weighted.mean(outcome_prob4, sample_weights),
    ) %>%
    arrange(vax_status, tstop) %>%
    group_by(vax_status) %>%
    mutate(
      survival1 = cumprod(1-outcome_prob1),
      survival2 = cumprod(1-outcome_prob2),
      survival4 = cumprod(1-outcome_prob4),
    )

  cml_inc <- ggplot(curves)+
    geom_step(aes(x=tstop, y=1-survival4, group=vax_status, colour=vax_status))+
    scale_x_continuous(breaks=seq(0,700,7), limits=c(0, max(curves$tstop)))+
    labs(
      x="Days",
      y="Cumulative risk",
      colour=""
    ) +
    theme_bw()+
    theme(
      legend.position=c(0.9,.1),
      legend.justification = c(1,0),
      panel.grid.minor.x = element_blank(),
    )

  ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, stratum, "cml_incidence_plot.svg"), cml_inc, width=20, height=15, units="cm")
  ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, stratum, "cml_incidence_plot.png"), cml_inc, width=20, height=15, units="cm")



  ggsecular1 <- interactions::interact_plot(
    msmmod1,
    pred=tstop, modx=region, data=data_weights,
    colors="Set1", vary.lty=FALSE,
    x.label=glue::glue("Days since {gbl_vars$start_date}"),
    y.label=glue::glue("{outcome_descr} prob.")
  )
  ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, stratum, "time_trends_region_plot1.svg"), ggsecular1, width=20, height=15, units="cm")
  ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, stratum, "time_trends_region_plot1.png"), ggsecular1, width=20, height=15, units="cm")

}


#
## secular trends ----

#
# ggsecular2 <- interactions::interact_plot(
#   msmmod2,
#   pred=tstop, modx=region, data=data_weights,
#   colors="Set1", vary.lty=FALSE,
#   x.label=glue::glue("Days since {gbl_vars$start_date}"),
#   y.label=glue::glue("{outcome_descr} prob.")
# )
#
# ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, "time_trends_region_plot2.svg"), ggsecular2, width=20, height=15, units="cm")
#
#
# ggsecular3 <- interactions::interact_plot(
#   msmmod3,
#   pred=tstop, modx=region, data=data_weights,
#   colors="Set1", vary.lty=FALSE,
#   x.label=glue::glue("Days since {gbl_vars$start_date}"),
#   y.label=glue::glue("{outcome_descr} prob.")
# )
#
# ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, "time_trends_region_plot3.svg"), ggsecular3, width=20, height=15, units="cm")
#
#
# ggsecular4 <- interactions::interact_plot(
#   msmmod4,
#   pred=tstop, modx=region, data=data_weights,
#   colors="Set1", vary.lty=FALSE,
#   x.label=glue::glue("Days since {gbl_vars$start_date}"),
#   y.label=glue::glue("{outcome_descr} prob.")
# )
#
# ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, "time_trends_region_plot4.svg"), ggsecular4, width=20, height=15, units="cm")


