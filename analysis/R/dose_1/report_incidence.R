
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
library('here')
library('glue')
library('lubridate')
library('survival')
library('splines')
library('parglm')
library('gtsummary')
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
  cohort <- "over80s"
  strata_var <- "all"
  brand <- "any"
  outcome <- "covidadmitted"
  removeobs <- FALSE
} else {
  cohort <- args[[1]]
  strata_var <- args[[2]]
  brand <- args[[3]]
  outcome <- args[[4]]
  removeobs <- TRUE
}



# import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)

# Import metadata for outcome ----
## these are created in data_define_cohorts.R script

metadata_outcomes <- read_rds(here("output", "metadata", "metadata_outcomes.rds"))
stopifnot("outcome does not exist" = (outcome %in% metadata_outcomes[["outcome"]]))
metadata_outcomes <- metadata_outcomes[metadata_outcomes[["outcome"]]==outcome, ]

list2env(metadata_outcomes, globalenv())

### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())

formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))

# import globally defined repo variables from
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)

start_date <- gbl_vars[[glue("start_date_{cohort}")]]


##  Create big loop over all categories

strata <- read_rds(here("output", "metadata", "list_strata.rds"))[[strata_var]]
strata_names <- paste0("strata_",strata)
summary_list <- vector("list", length(strata))
names(summary_list) <- strata_names


for(stratum in strata){
  stratum_name <- strata_names[which(strata==stratum)]
  # Import processed data ----

  data_weights <- read_rds(here("output", cohort, strata_var, brand, outcome, glue("data_weights_{stratum}.rds")))

  # import models ----

  #msmmod0 <- read_rds(here("output", cohort, strata_var, brand, outcome, glue("model0_{stratum}.rds")))
  msmmod1 <- read_rds(here("output", cohort, strata_var, brand, outcome, glue("model1_{stratum}.rds")))
  #msmmod2 <- read_rds(here("output", cohort, strata_var, brand, outcome, glue("model2_{stratum}.rds")))
  #msmmod3 <- read_rds(here("output", cohort, strata_var, brand, outcome, glue("model3_{stratum}.rds")))
  msmmod4 <- read_rds(here("output", cohort, strata_var, brand, outcome, glue("model4_{stratum}.rds")))


  ### cumulative incidence curves
  ### incorporating calendar-time-varying baseline
  survival_novax <- data_weights %>%
    mutate(timesincevax_pw="pre-vax") %>%
    transmute(
      patient_id,
      tstop,
      sample_weights,
      timesincevax_pw,
      # outcome_prob1=predict(msmmod1, newdata=., type="response"),
      # outcome_prob2=predict(msmmod2, newdata=., type="response"),
      # outcome_prob3=predict(msmmod3, newdata=., type="response"),
      outcome_prob4=predict(msmmod4, newdata=., type="response"),
      vax_status="Unvaccinated"
    )

  survival_vax <- data_weights %>%
    mutate(timesincevax_pw = timesince_cut(tstop, postvaxcuts, "pre-vax")) %>%
    transmute(
      patient_id,
      tstop,
      sample_weights,
      timesincevax_pw,
      # outcome_prob1=predict(msmmod1, newdata=., type="response"),
      # outcome_prob2=predict(msmmod2, newdata=., type="response"),
      # outcome_prob2=predict(msmmod3, newdata=., type="response"),
      outcome_prob4=predict(msmmod4, newdata=., type="response"),
      vax_status="Vaccinated"
    )

  curves <- bind_rows(survival_novax, survival_vax) %>%
    #marginalise over all patients
    group_by(vax_status, tstop) %>%
    summarise(
      # outcome_prob1=weighted.mean(outcome_prob1, sample_weights),
      # outcome_prob2=weighted.mean(outcome_prob2, sample_weights),
      # outcome_prob3=weighted.mean(outcome_prob3, sample_weights),
      outcome_prob4=weighted.mean(outcome_prob4, sample_weights),
    ) %>%
    arrange(vax_status, tstop) %>%
    group_by(vax_status) %>%
    mutate(
      # survival1 = cumprod(1-outcome_prob1),
      # survival2 = cumprod(1-outcome_prob2),
      # survival3 = cumprod(1-outcome_prob3),
      survival4 = cumprod(1-outcome_prob4),
    ) %>%
    ungroup() %>%
    add_row(
      vax_status=c("Unvaccinated", "Vaccinated"),
      tstop=0,
      outcome_prob4 =0,
      survival4 = 1,
    ) %>%
    arrange(vax_status, tstop) %>%
    mutate(
      stratum = stratum,
      date = as.Date(start_date) + tstop
    )


  summary_list[[stratum_name]] <- curves

  cml_inc <- ggplot(curves)+
    geom_step(aes(x=date, y=1-survival4, group=vax_status, colour=vax_status))+
    scale_x_date(
      breaks = seq(min(curves$date),max(curves$date)+1,by=14),
      limits = c(lubridate::floor_date((min(curves$date)), "1 month"), NA),
      labels = scales::date_format("%d/%m"),
      expand = expansion(0),
      sec.axis = sec_axis(
        trans = ~as.Date(.),
        breaks=as.Date(seq(floor_date(min(curves$date), "month"), ceiling_date(max(curves$date), "month"),by="month")),
        labels = scales::date_format("%b %y")
      )
    )+
    scale_colour_brewer(type="qual", palette="Set2")+
    labs(
      x="Date",
      y="Cumulative risk",
      colour=NULL
    )+
    theme_bw()+
    theme(
      legend.position=c(0.05,.95),
      legend.justification = c(0,1),
      axis.text.x.top=element_text(hjust=0)
    )

  ggsave(filename=here("output", cohort, strata_var, brand, outcome, glue("cml_incidence_plot_{stratum}.svg")), cml_inc, width=20, height=15, units="cm")
  ggsave(filename=here("output", cohort, strata_var, brand, outcome, glue("cml_incidence_plot_{stratum}.png")), cml_inc, width=20, height=15, units="cm")


  ### absolute daily risk, by region

  ggsecular1 <- interactions::interact_plot(
    msmmod1,
    pred=tstop, modx=region, data=data_weights,
    colors="Set1", vary.lty=FALSE,
    x.label=glue("Days since {start_date}"),
    y.label=glue("{outcome_descr} prob.")
  )
  ggsave(filename=here("output", cohort, strata_var, brand, outcome, glue("time_trends_region_plot1_{stratum}.svg")), ggsecular1, width=20, height=15, units="cm")
  ggsave(filename=here("output", cohort, strata_var, brand, outcome, glue("time_trends_region_plot1_{stratum}.png")), ggsecular1, width=20, height=15, units="cm")

}


summary_df <- summary_list %>% bind_rows

write_rds(summary_df, path = here("output", cohort, strata_var, brand, outcome, "data_incidence.rds"))
