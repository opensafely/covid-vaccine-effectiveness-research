
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

cohort <- args[[1]]
outcome <- args[[2]]
brand <- args[[3]]
strata_var <- args[[4]]
removeobs <- TRUE

if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
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

formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))

##  Create big loop over all categories

strata <- read_rds(here::here("output", "data", "list_strata.rds"))[[strata_var]]
summary_list <- vector("list", length(strata))
names(summary_list) <- strata

for(stratum in strata){

  # Import processed data ----

  data_weights <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("data_weights.rds")))

  # import models ----

  msmmod0 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model0.rds")))
  msmmod1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model1.rds")))
  msmmod2 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model2.rds")))
  msmmod3 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model3.rds")))
  msmmod4 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model4.rds")))


  ## report models ----

  robust0 <- tidy_plr(msmmod0, cluster=data_weights$patient_id)
  robust1 <- tidy_plr(msmmod1, cluster=data_weights$patient_id)
  robust2 <- tidy_plr(msmmod2, cluster=data_weights$patient_id)
  robust3 <- tidy_plr(msmmod3, cluster=data_weights$patient_id)
  robust4 <- tidy_plr(msmmod4, cluster=data_weights$patient_id)

  robust_summary <- bind_rows(
    robust0 %>% mutate(model="0 Unadjusted", strata=stratum),
    robust1 %>% mutate(model="1 Demographics", strata=stratum),
    robust2 %>% mutate(model="2 Demographics + cinical", strata=stratum),
    robust3 %>% mutate(model="3 Demographics + cinical + date", strata=stratum),
    robust4 %>% mutate(model="4 Fully adjusted", strata=stratum),
  )

  summary_list[[stratum]] <- robust_summary

}

summary_df <- summary_list %>% bind_rows

write_csv(summary_df, path = here::here("output", cohort, outcome, brand, strata_var, "estimates.csv"))

# create forest plot
msmmod_forest_data <- summary_df %>%
  filter(str_detect(term, "timesincevax")) %>%
  mutate(
    term=str_replace(term, pattern="timesincevax\\_pw", ""),
    term=fct_inorder(term),
    term_left = as.numeric(str_extract(term, "\\d+")),
    term_right = as.numeric(str_remove(str_extract(term, "\\d+]$"), "]")),
    term_right = if_else(is.na(term_right), max(term_left)+7, term_right),
    term_midpoint = term_left + (term_right-term_left)/2
  )

msmmod_forest <-
  ggplot(data = msmmod_forest_data, aes(colour=as.factor(strata))) +
  #geom_segment(aes(y=or, yend=or, x=term_left, xend=term_right))+
  #geom_ribbon(aes(ymin=or.ll, ymax=or.ul, x=term_left), fill=)+
  geom_point(aes(y=or, x=term_midpoint), position = position_dodge(width = 0.5))+
  geom_linerange(aes(ymin=or.ll, ymax=or.ul, x=term_midpoint), position = position_dodge(width = 0.5))+
  geom_hline(aes(yintercept=1), colour='grey')+
  facet_grid(rows=vars(model), switch="y")+
  scale_y_log10(breaks=c(0.03125, 0.0625, 0.125, 0.25, 0.5, 1, 2, 4))+
  scale_x_continuous(breaks=unique(msmmod_forest_data$term_left))+
  scale_colour_brewer(type="qual", palette="Set2")+#, guide=guide_legend(reverse = TRUE))+
  #coord_cartesian(ylim=c(0.1,2)) +
  labs(
    y="Hazard ratio, versus no vaccination",
    x="Time since first dose",
    colour=NULL,
    title=glue::glue("{outcome_descr} by time since first {brand} vaccine"),
    subtitle=cohort_descr
  ) +
  theme_bw()+
  theme(
    panel.border = element_blank(),
    axis.line.y = element_line(colour = "black"),

    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    strip.background = element_blank(),
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0),

    panel.spacing = unit(0.8, "lines"),

    plot.title = element_text(hjust = 0),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0, face= "italic"),

    legend.position = "right"
  )

## save plot
ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, "forest_plot.svg"), msmmod_forest, width=20, height=15, units="cm")




#
## secular trends ----



ggsecular3 <- interactions::interact_plot(
  msmmod3,
  pred=tstop, modx=region, data=data_weights,
  colors="Set1", vary.lty=FALSE,
  x.label=glue::glue("Days since {gbl_vars$start_date}"),
  y.label=glue::glue("{outcome_descr} prob.")
)

ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, "time_trends_region_plot3.svg"), ggsecular3, width=20, height=15, units="cm")


ggsecular4 <- interactions::interact_plot(
  msmmod4,
  pred=tstop, modx=region, data=data_weights,
  colors="Set1", vary.lty=FALSE,
  x.label=glue::glue("Days since {gbl_vars$start_date}"),
  y.label=glue::glue("{outcome_descr} prob.")
)

ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, "time_trends_region_plot4.svg"), ggsecular4, width=20, height=15, units="cm")


