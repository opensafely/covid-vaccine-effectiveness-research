
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports reported MSM estimates for ALL outcomes
# calculates robust CIs taking into account patient-level clustering
# outputs forest plots for the primary vaccine-outcome relationship
# outputs plots showing model-estimated spatio-temporal trends
#
# The script should only be run via an action in the project.yaml only
# The script must be accompanied by four arguments: cohort and stratum
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
  strata_var <- "all"
} else{
  removeobs <- TRUE
  cohort <- args[[1]]
  strata_var <- args[[2]]
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

# Import metadata for outcomes ----
## these are created in data_define_cohorts.R script

metadata_outcomes <- read_rds(here::here("output", "data", "metadata_outcomes.rds"))

##  Create big loop over all categories

strata <- read_rds(here::here("output", "data", "list_strata.rds"))[[strata_var]]
summary_list <- vector("list", length(strata))
names(summary_list) <- strata

# import models ----


estimates <-
  metadata_outcomes %>%
  filter(outcome %in% c(
    "postest",
    "covidadmitted",
    #"coviddeath",
    #"noncoviddeath",
    "death",
    NULL
  )) %>%
  mutate(
    outcome = fct_inorder(outcome),
    outcome_descr = fct_inorder(outcome_descr),
  ) %>%
  crossing(
    tibble(
      brand = c("any", "pfizer", "az"),
      brand_descr = c("Any vaccine", "BNT162b2", "ChAdOx1")
    ) %>%
    mutate(
      brand = fct_inorder(brand),
      brand_descr = fct_inorder(brand_descr)
    )
  ) %>%
  mutate(
    brand = fct_inorder(brand),
    brand_descr = fct_inorder(brand_descr),
    estimates = map2(outcome, brand, ~read_csv(here::here("output", cohort, .x, .y, strata_var, glue::glue("estimates_timesincevax.csv"))))
  ) %>%
  unnest(estimates) %>%
  mutate(
    model_descr = fct_inorder(model_descr),
  )


write_csv(estimates, path = here::here("output", cohort, glue::glue("estimates_timesincevax_{strata_var}.csv")))

# create forest plot
msmmod_forest_data <- estimates %>%
  mutate(
    term=str_replace(term, pattern="timesincevax\\_pw", ""),
    term=fct_inorder(term),
    term_left = as.numeric(str_extract(term, "\\d+"))-1,
    term_right = as.numeric(str_extract(term, "\\d+$")),
    term_right = if_else(is.na(term_right), max(term_left)+7, term_right),
    term_midpoint = term_left + (term_right-term_left)/2,
    strata = if_else(strata=="all", "", strata)
  )

msmmod_forest <-
  ggplot(data = msmmod_forest_data, aes(colour=model_descr)) +
  geom_point(aes(y=or, x=term_midpoint), position = position_dodge(width = 1))+
  geom_linerange(aes(ymin=or.ll, ymax=or.ul, x=term_midpoint), position = position_dodge(width = 1))+
  geom_hline(aes(yintercept=1), colour='grey')+
  facet_grid(rows=vars(outcome_descr), cols=vars(brand_descr), switch="y")+
  scale_y_log10(
    breaks=c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5),
    sec.axis = sec_axis(~(1-.), name="Effectiveness", breaks = c(-4, -1, 0, 0.5, 0.80, 0.9, 0.95, 0.98, 0.99), labels = scales::label_percent(1))
  )+
  scale_x_continuous(breaks=unique(msmmod_forest_data$term_left))+
  scale_colour_brewer(type="qual", palette="Set2", guide=guide_legend(ncol=1))+
  coord_cartesian(ylim=c(0.04,2)) +
  labs(
    y="Hazard ratio, versus no vaccination",
    x="Days since first dose",
    colour=NULL#,
    #title=glue::glue("Outcomes by time since first {brand} vaccine"),
    #subtitle=cohort_descr
  ) +
  theme_bw(base_size=16)+
  theme(
    panel.border = element_blank(),
    axis.line.y = element_line(colour = "black"),

    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    strip.background = element_blank(),
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0),

    panel.spacing = unit(1, "lines"),

    plot.title = element_text(hjust = 0),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0, face= "italic"),

    legend.position = "bottom"
  )

## save plot
ggsave(filename=here::here("output", cohort, glue::glue("forest_plot_{strata_var}.svg")), msmmod_forest, width=30, height=30, units="cm")

