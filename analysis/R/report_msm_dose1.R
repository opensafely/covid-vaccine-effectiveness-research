
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
  strata_var <- "sex"
}


# Import metadata for cohort ----

metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
metadata <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort & metadata_cohorts[["outcome"]]==outcome, ]


stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))


## define model hyper-parameters and characteristics ----

### model names ----

list2env(metadata, globalenv())

## or equivalently:
# cohort <- metadata_cohorts$cohort
# cohort_descr <- metadata_cohorts$cohort_descr
# outcome <- metadata_cohorts$outcome
# outcome_descr <- metadata_cohorts$outcome_descr

### post vax time periods ----

postvaxcuts <- c(0, 3, 7, 14, 21) # use if coded as days
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
  msmmod4 <- read_rds(here::here("output", cohort, outcome, brand, strata_var, stratum, glue::glue("model4.rds")))



  ## report models ----

  # tidy model outputs

  msmmod_tidy0 <- tidy_parglm(msmmod0, conf.int=TRUE) %>% mutate(model="0 Unadjusted", strata=stratum)
  msmmod_tidy1 <- tidy_parglm(msmmod1, conf.int=TRUE) %>% mutate(model="1 Age, sex, IMD", strata=stratum)
  msmmod_tidy4 <- tidy_parglm(msmmod4, conf.int=TRUE) %>% mutate(model="2 Fully adjusted", strata=stratum)

  # create table with model estimates
  msmmod_summary <- bind_rows(
    msmmod_tidy0,
    msmmod_tidy1,
    msmmod_tidy4,
  ) %>%
    mutate(
      or = exp(estimate),
      or.ll = exp(conf.low),
      or.ul = exp(conf.high),
    )


  robustSEs0 <- coeftest(msmmod0, vcov. = vcovCL(msmmod0, cluster = data_weights$patient_id, type = "HC0")) %>% tidy()
  robustSEs1 <- coeftest(msmmod1, vcov. = vcovCL(msmmod1, cluster = data_weights$patient_id, type = "HC0")) %>% tidy()
  robustSEs4 <- coeftest(msmmod4, vcov. = vcovCL(msmmod4, cluster = data_weights$patient_id, type = "HC0")) %>% tidy()

  robustCIs0 <- coefci(msmmod0, vcov. = vcovCL(msmmod0, cluster = data_weights$patient_id, type = "HC0")) %>% as_tibble(rownames="term")
  robustCIs1 <- coefci(msmmod1, vcov. = vcovCL(msmmod1, cluster = data_weights$patient_id, type = "HC0")) %>% as_tibble(rownames="term")
  robustCIs4 <- coefci(msmmod4, vcov. = vcovCL(msmmod4, cluster = data_weights$patient_id, type = "HC0")) %>% as_tibble(rownames="term")

  robust0 <- inner_join(robustSEs0, robustCIs0, by="term") %>% mutate(model="0 Unadjusted",  strata=stratum)
  robust1 <- inner_join(robustSEs1, robustCIs1, by="term") %>% mutate(model="1 Age, sex, IMD", strata=stratum)
  robust4 <- inner_join(robustSEs4, robustCIs4, by="term") %>% mutate(model="2 Fully adjusted", strata=stratum)


  robust_summary <- bind_rows(
    robust0,
    robust1,
    robust4,
  ) %>%
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
# ## secular trends ----
#
#
# ggsecular4 <- interactions::interact_plot(
#   msmmod4,
#   pred=tstop, modx=region, data=data_weights,
#   colors="Set1", vary.lty=FALSE,
#   x.label="Days since 7 Dec 2020",
#   y.label=glue::glue("{outcome_descr} prob.")
# )
#
# ggsave(filename=here::here("output", cohort, outcome, brand, strata_var, "secular_trends_region_plot.svg"), ggsecular4, width=20, height=30, units="cm")


