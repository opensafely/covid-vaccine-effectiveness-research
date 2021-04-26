
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports reported MSM estimates for ALL outcomes
# calculates robust CIs taking into account patient-level clustering
# outputs forest plots for the primary vaccine-outcome relationship
# outputs plots showing model-estimated spatio-temporal trends
#
# The script should only be run via an action in the project.yaml only
# The script must be accompanied by four arguments: cohort, brand, and stratum
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

cohort <- args[[1]]
brand <- args[[2]]
strata_var <- args[[3]]
removeobs <- TRUE

if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"
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

# Import metadata for outcomes ----
## these are created in data_define_cohorts.R script

metadata_outcomes <- read_rds(here::here("output", "data", "metadata_outcomes.rds"))


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

# import models ----


estimates <-
  metadata_outcomes %>%
  filter(outcome %in% c(
    "postest",
    "covidadmitted",
    "coviddeath",
    "noncoviddeath",
    "death"
  )) %>%
  mutate(
    outcome = fct_inorder(outcome),
    outcome_descr = fct_inorder(outcome_descr),
    estimates = map(outcome, ~read_csv(here::here("output", cohort, .x, brand, strata_var, glue::glue("estimates.csv"))))
  ) %>%
  unnest(estimates)


write_csv(estimates, path = here::here("output", cohort, glue::glue("estimates_{brand}_{strata_var}.csv")))

# create forest plot
msmmod_forest_data <- estimates %>%
  filter(
    str_detect(term, "timesincevax"),
    str_sub(model, 1, 1) %in% c(3,4)
  ) %>%
  mutate(
    term=str_replace(term, pattern="timesincevax\\_pw", ""),
    term=fct_inorder(term),
    term_left = as.numeric(str_extract(term, "\\d+")),
    term_right = as.numeric(str_remove(str_extract(term, "\\d+]$"), "]")),
    term_right = if_else(is.na(term_right), max(term_left)+7, term_right),
    term_midpoint = term_left + (term_right-term_left)/2,
    model = fct_case_when(
      str_sub(model, 1, 1) == 3 ~ "Standard Cox",
      str_sub(model, 1, 1) == 4 ~ "Marginal structural Cox"
    )
  )

msmmod_forest <-
  ggplot(data = msmmod_forest_data, aes(colour=model)) +
  #geom_segment(aes(y=or, yend=or, x=term_left, xend=term_right))+
  #geom_ribbon(aes(ymin=or.ll, ymax=or.ul, x=term_left), fill=)+
  geom_point(aes(y=or, x=term_midpoint), position = position_dodge(width = 1))+
  geom_linerange(aes(ymin=or.ll, ymax=or.ul, x=term_midpoint), position = position_dodge(width = 1))+
  geom_hline(aes(yintercept=1), colour='grey')+
  facet_grid(rows=vars(outcome_descr), cols=vars(as.factor(strata)), switch="y")+
  scale_y_log10(breaks=2^(-7:2), labels=c("1/128", "1/64", "1/32", "1/16", "1/8", "1/4", "1/2", "1", "2", "4"))+
  scale_x_continuous(breaks=unique(msmmod_forest_data$term_left))+
  scale_colour_brewer(type="qual", palette="Set2")+#, guide=guide_legend(reverse = TRUE))+
  coord_cartesian(ylim=c(2^-7,2)) +
  labs(
    y="Hazard ratio, versus no vaccination",
    x="Time since first dose",
    colour=NULL,
    title=glue::glue("Outcomes by time since first {brand} vaccine"),
    subtitle=cohort_descr
  ) +
  guides(colour=guide_legend(nrow=1))+
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

    legend.position = "bottom"
  )

## save plot
ggsave(filename=here::here("output", cohort, glue::glue("forest_plot_{brand}_{strata_var}.svg")), msmmod_forest, width=20, height=30, units="cm")


tab_forest <-
msmmod_forest_data %>%
  transmute(
    outcome_descr, model, term,
    `HR` = specify_decimal(or, 3),
    `95% CI` = print_2bracket(or.ll, or.ul, round=3),
    `P value` = print_pval(p.value, 3),
  ) %>%
  pivot_wider(
    id_cols = c(outcome_descr, term),
    names_from = model,
    values_from = c(HR, `95% CI`, `P value`),
    names_glue = "{model}_{.value}"
    ) %>%
  select(Outcome=outcome_descr, `Time since first dose`=term, contains("Standard"), contains("Marginal")) %>%
  gt(
    groupname_col = "Outcome"
  ) %>%
  tab_spanner_delim("_")

gtsave(tab_forest, here::here("output", cohort, glue::glue("estimates_{brand}_{strata_var}.html")))


