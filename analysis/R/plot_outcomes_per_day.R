
# # # # # # # # # # # # # # # # # # # # #
# This script:
# takes a cohort name as defined in data_define_cohorts.R, and imported as an Arg
# creates descriptive outputs on the occurrence of outcome events over time
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by two arguments,
# 1. the name of the cohort defined in data_define_cohorts.R
# 2. the name of the outcome defined in data_define_cohorts.R
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')
library('splines')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  outcome <- "postest"
} else {
  # use for actions
  cohort <- args[[1]]
  outcome <- args[[2]]
}

## import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
#list2env(gbl_vars, globalenv())


## Import metadata for cohort ----

metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
metadata <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort & metadata_cohorts[["outcome"]]==outcome, ]


stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))


## put metadata into global environment
list2env(metadata, globalenv())
### or equivalently:
# cohort <- metadata_cohorts$cohort
# cohort_descr <- metadata_cohorts$cohort_descr
# outcome <- metadata_cohorts$outcome
# outcome_descr <- metadata_cohorts$outcome_descr




## create output directories ----
dir.create(here::here("output", cohort, outcome, "descr"), showWarnings = FALSE, recursive=TRUE)


## Import processed data ----


data_fixed <- read_rds(here::here("output", cohort, "data", glue::glue("data_wide_fixed.rds")))


data_pt <- read_rds(here::here("output", cohort, "data", glue::glue("data_pt.rds")))  %>%
  mutate(
    outcome = .[[outcome]],
    date = as.Date(gbl_vars$start_date) + tstop,
    anyvax = vax_status>0
  ) %>%
  left_join(data_fixed, by="patient_id")



## define theme ----

plot_theme <-
theme_minimal()+
  theme(
    legend.position = "left",
    strip.text.y.right = element_text(angle = 0),
    axis.line.x = element_line(colour = "black"),
    axis.text.x = element_text(angle = 70, vjust = 1, hjust=1),
    panel.grid.major.x = element_blank()#,
   # panel.grid.minor.x = element_blank()
  )


# create plots ----

## overall ----

eventsperday <- data_pt %>%
  group_by(date, anyvax) %>%
  summarise(
    n=n(),
    n_outcome = sum(outcome),
    rate_outcome = mean(outcome)
  )


plotoutcome_n <- ggplot(eventsperday) +
  geom_bar(aes(x=date, y=n_outcome, fill=anyvax), stat="identity", colour="transparent")+
  scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
  scale_fill_brewer(type="qual", palette="Set1", na.value="grey")+
  labs(
    x=NULL,
    y=glue::glue("{outcome_descr} frequency"),
    fill="Vaccinated",
    title=glue::glue("{outcome_descr} frequency"),
    subtitle=cohort_descr
  )+
  plot_theme

ggsave(filename=here::here("output", cohort, outcome, "descr", glue::glue("events_perday_n.svg")), plotoutcome_n, width=30, height=20, units="cm", scale=0.8)


plotoutcome_rate <- ggplot(eventsperday) +
  geom_line(aes(x=date, y=rate_outcome, colour=anyvax), stat="identity")+
  scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
  scale_colour_brewer(type="qual", palette="Set1", na.value="grey")+
  labs(
    x=NULL,
    y=glue::glue("{outcome_descr} rate"),
    colour="Vaccinated",
    title=glue::glue("{outcome_descr} rate"),
    subtitle=cohort_descr
  )+
  plot_theme

ggsave(filename=here::here("output", cohort, outcome, "descr", glue::glue("events_perday_rate.svg")), plotoutcome_rate, width=30, height=20, units="cm", scale=0.8)

## by sex, imd ----


outcomeperday_sex_imd <- data_pt %>%
  group_by(date, anyvax, sex, imd, .drop=FALSE) %>%
  summarise(
    n=n(),
    n_outcome = sum(outcome),
    rate_outcome = mean(outcome)
  )


plotoutcome_n_sex_ind <- ggplot(outcomeperday_sex_imd) +
  geom_bar(aes(x=date, y=n_outcome, fill=anyvax), stat="identity", colour="transparent")+
  facet_grid(cols=vars(sex), rows=vars(imd))+
  scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
  scale_fill_brewer(type="qual", palette="Set1", na.value="grey")+
  labs(
    x=NULL,
    y=glue::glue("{outcome_descr} frequency"),
    fill="Vaccinated",
    title=glue::glue("{outcome_descr} frequency"),
    subtitle=cohort_descr
  )+
  plot_theme


ggsave(filename=here::here("output", cohort, outcome, "descr", glue::glue("events_perday_n_sex_imd.svg")), plotoutcome_n_sex_ind, width=30, height=40, units="cm", scale=0.6)



plotoutcome_rate_sex_ind <- ggplot(outcomeperday_sex_imd) +
  geom_line(aes(x=date, y=rate_outcome, colour=anyvax), stat="identity")+
  facet_grid(cols=vars(sex), rows=vars(imd))+
  scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
  scale_colour_brewer(type="qual", palette="Set1", na.value="grey")+
  labs(
    x=NULL,
    y=glue::glue("{outcome_descr} rate"),
    colour="Vaccinated",
    title=glue::glue("{outcome_descr} rate"),
    subtitle=cohort_descr
  )+
  plot_theme


ggsave(filename=here::here("output", cohort, outcome, "descr", glue::glue("events_perday_rate_sex_imd.svg")), plotoutcome_rate_sex_ind, width=30, height=40, units="cm", scale=0.8)




## by region ----


outcomeperday_region <- data_pt %>%
  group_by(date, anyvax, region) %>%
  summarise(
    n=n(),
    n_outcome = sum(outcome),
    rate_outcome = mean(outcome)
  )


plotoutome_n_region <- ggplot(outcomeperday_region) +
  geom_bar(aes(x=date, y=n_outcome, fill=anyvax), stat="identity", colour="transparent")+
  facet_wrap(facets=vars(region))+
  scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
  scale_fill_brewer(type="qual", palette="Set1", na.value="grey")+
  labs(
    x=NULL,
    y=glue::glue("{outcome_descr} frequency"),
    fill="Vaccinated",
    title=glue::glue("{outcome_descr} frequency"),
    subtitle=cohort_descr
  )+
  plot_theme



ggsave(filename=here::here("output", cohort, outcome, "descr", glue::glue("events_perday_n_region.svg")), plotoutome_n_region, width=30, height=40, units="cm", scale=0.6)



plotoutcome_rate_region <- ggplot(outcomeperday_region) +
  geom_line(aes(x=date, y=rate_outcome, colour=anyvax), stat="identity")+
  facet_wrap(facets=vars(region))+
  scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
  scale_colour_brewer(type="qual", palette="Set1", na.value="grey")+
  labs(
    x=NULL,
    y=glue::glue("{outcome_descr} rate"),
    colour="Vaccinated",
    title=glue::glue("{outcome_descr} rate"),
    subtitle=cohort_descr
  )+
  plot_theme

ggsave(filename=here::here("output", cohort, outcome, "descr", glue::glue("events_perday_rate_region.svg")), plotoutcome_rate_region, width=30, height=40, units="cm", scale=0.8)

