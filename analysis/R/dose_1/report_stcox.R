
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports fitted sequential trial cox models
# outputs effects plots
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by 5 arguments:
# 1. the name of the cohort
# 2. the stratification variable. Use "all" if no stratification
# 3. the duration of time from positive test over which to exclude vaccinations from the exposure. This changes the causal estimand, but allows estimation of covid-19 specific mortality
# 4. the name of the outcome
# 5. the name of the brand (currently "any", "az",or "pfizer")
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----



# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"
  strata_var <- "all"
  recentpostest_period <- as.numeric("0")
  brand <- "any"
  outcome <- "covidadmitted"

} else {
  removeobs <- TRUE
  cohort <- args[[1]]
  strata_var <- args[[2]]
  recentpostest_period <- as.numeric(args[[3]])
  brand <- args[[4]]
  outcome <- args[[5]]
}



## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('lubridate')
library('survival')
library('splines')
library('gtsummary')


## Import custom user functions from lib
source(here("lib", "utility_functions.R"))
source(here("lib", "redaction_functions.R"))
source(here("lib", "survival_functions.R"))


## import metadata ----

## if changing treatment strategy as per Miguel's suggestion
exclude_recentpostest <- (recentpostest_period >0)

# Import processed data ----

# import models ----

## report models ----

#data_cox <- read_rds(here("output", "models", outcome, timescale, "modelcox_data.rds"))

tidy_cox <- read_rds(here::here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue("stcox_tidy.rds")))

effectscox <- tidy_cox %>%
  filter(str_detect(term, fixed("timesincereruitment_pw")) | str_detect(term, fixed("treated"))) %>%
  mutate(
    term=str_replace(term, pattern=fixed("treated:strata(timesincerecruitment_pw)"), ""),
    term=fct_inorder(term),
    term_left = as.numeric(str_extract(term, "^\\d+"))-1,
    term_right = as.numeric(str_extract(term, "\\d+$"))-1,
    term_right = if_else(is.na(term_right), 60, term_right),
    term_midpoint = term_left + (term_right+1-term_left)/2
  )

write_csv(effectscox, here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue::glue("reportstcox_effects.csv")))
write_rds(effectscox, here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue::glue("reportstcox_effects.rds")))

plotcox <-
  ggplot(data = effectscox) +
  geom_point(aes(y=exp(estimate), x=term_midpoint, colour=model_name), position = position_dodge(width = 1.8))+
  geom_linerange(aes(ymin=exp(conf.low), ymax=exp(conf.high), x=term_midpoint, colour=model_name), position = position_dodge(width = 1.8))+
  geom_hline(aes(yintercept=1), colour='grey')+
  scale_y_log10(
    breaks=c(0.01, 0.05, 0.1, 0.5, 1, 2),
    sec.axis = dup_axis(name="favours \n <-- non-vax  /  vax  -->", breaks = NULL)
  )+
  scale_x_continuous(breaks=unique(effectscox$term_left), limits=c(min(effectscox$term_left), max(effectscox$term_right)+1), expand = c(0, 0))+
  scale_colour_brewer(type="qual", palette="Set2", guide=guide_legend(ncol=1))+
  labs(
    y="Hazard ratio",
    x="Time since first dose",
    colour=NULL
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

    legend.position = "bottom"
  ) +
  NULL
plotcox
## save plot

write_rds(plotcox, path=here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue("reportstcox_effectsplot.rds")))
ggsave(filename=here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue("reportstcox_effectsplot.svg")), plotcox, width=20, height=15, units="cm")
ggsave(filename=here("output", cohort, strata_var, recentpostest_period, brand, outcome, glue("reportstcox_effectsplot.png")), plotcox, width=20, height=15, units="cm")




