
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits some marginal structural models for vaccine effectiveness, with different adjustment sets
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
#
# The script should only be run via an action in the project.yaml only
# The script must be accompanied by one argument, the name of the cohort defined in data_define_cohorts.R
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


for(stratum in strata){

  # Import processed data ----

  data_weights <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("data_weights.rds")))

  # import models ----

  msmmod0 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model0.rds")))
  msmmod1 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model1.rds")))
  msmmod3 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model3.rds")))
  msmmod4 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model4.rds")))



  ## report models ----

  plr_summary <- function(model, name, stratum){

    mod_tidy <- tidy_parglm(model, conf.int=TRUE) %>% mutate(model=name, strata=stratum)
    robustSEs <- coeftest(model, vcov. = vcovCL(model, cluster = data_weights$patient_id, type = "HC0")) %>% broom::tidy()
    robustCIs <- coefci(model, vcov. = vcovCL(model, cluster = data_weights$patient_id, type = "HC0")) %>% as_tibble(rownames="term")
    robust <- inner_join(robustSEs, robustCIs, by="term") %>% mutate(model=name,  strata=stratum)

    robust %>%
      rename(
        estimate.robust=estimate,
        std.error.robust=std.error,
        p.value.robust=p.value,
        statistic.robust=statistic,
        conf.low.robust=`2.5 %`,
        conf.high.robust=`97.5 %`
      ) %>%
      mutate(
        or = exp(estimate.robust),
        or.ll = exp(conf.low.robust),
        or.ul = exp(conf.high.robust),
      )

  }

  robust0 <- plr_summary(msmmod0, "0 Unadjusted", stratum)
  robust1 <- plr_summary(msmmod1, "1 Age, sex, IMD, ethnicity", stratum)
  robust3 <- plr_summary(msmmod3, "2 Baseline adjusted", stratum)
  robust4 <- plr_summary(msmmod4, "3 Fully adjusted", stratum)

  robust_summary <- bind_rows(
    robust0,
    robust1,
    robust3,
    robust4
  )

  summary_list[[stratum]] <- robust_summary

}

summary_df <- summary_list %>% bind_rows

write_csv(summary_df, path = here::here("output", cohort, outcome, brand, strata_var, "estimates.csv"))

# create forest plot
msmmod_forest <- summary_df %>%
  filter(str_detect(term, "timesincevax")) %>%
  mutate(
    term=str_replace(term, pattern="timesincevax\\_pw", ""),
    term=str_replace(term, pattern="imd", "IMD "),
    term=str_replace(term, pattern="sex", "Sex "),
    term=fct_inorder(term)
  ) %>%
  ggplot(aes(colour=as.factor(strata))) +
  geom_point(aes(y=or, x=factor(term)), position = position_dodge(width = 0.5))+
  geom_linerange(aes(ymin=or.ll, ymax=or.ul, x=factor(term)), position = position_dodge(width = 0.5))+
  geom_hline(aes(yintercept=1), colour='grey')+
  facet_grid(rows=vars(model), switch="y")+
  scale_y_log10(breaks=c(0.125, 0.25, 0.5, 1, 2, 4))+
  scale_x_discrete(na.translate=FALSE)+
  scale_colour_brewer(type="qual", palette="Set2")+#, guide=guide_legend(reverse = TRUE))+
  coord_cartesian(ylim=c(0.1,2)) +
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

    strip.background = element_blank(),
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0),

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


ggsecular4 <- interactions::interact_plot(
  msmmod4,
  pred=tstop, modx=region, data=data_weights,
  colors="Set1", vary.lty=FALSE,
  x.label=glue::glue("Days since {gbl_vars$start_date}"),
  y.label=glue::glue("{outcome_descr} prob.")
)

ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, "time_trends_region_plot.svg"), ggsecular4, width=20, height=15, units="cm")


