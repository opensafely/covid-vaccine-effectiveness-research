
# # # # # # # # # # # # # # # # # # # # #
# This script:
# takes a cohort name as defined in data_define_cohorts.R, and imported as an Arg
# creates 3 datasets for that cohort:
# 1 is one row per patient (wide format)
# 2 is one row per patient per event (eg `stset` format, where a new row is created everytime an event occurs or a covariate changes)
# 3 is one row per patient per day
# creates additional survival variables for use in models (eg time to event from study start date)
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

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)

cohort <- args[[1]]

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
}

# import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./lib/global-variables.json"
)
#list2env(gbl_vars, globalenv())


# Import metadata for cohort ----

metadata_cohorts <- read_rds(here::here("output", "modeldata", "metadata_cohorts.rds"))
metadata_cohorts <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort,]

stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))

## define model hyper-parameters and characteristics ----

### model names ----

list2env(metadata_cohorts, globalenv())

## or equivalently:
# cohort <- metadata_cohorts$cohort
# cohort_descr <- metadata_cohorts$cohort_descr
# outcome <- metadata_cohorts$outcome
# outcome_descr <- metadata_cohorts$outcome_descr

# create output directories ----
dir.create(here::here("output", "models", "msm", cohort), showWarnings = FALSE, recursive=TRUE)

# Import processed data ----

data_pt <- read_rds(here::here("output", "modeldata", glue::glue("data_pt_{cohort}.rds")))


postestsperday <- data_pt %>%
  group_by(tstop, vax_status) %>%
  summarise(
    date=as.Date(gbl_vars$start_date) + tstop,
    n=n(),
    positive_tests = sum(outcome)
  )


plotpostestsperday <- ggplot(postestsperday) +
  geom_bar(aes(x=date, y=positive_tests, fill=vax_status==1), stat="identity", colour="transparent")+
  scale_x_date(date_breaks = "1 month", labels = scales::date_format("%Y-%m"))+
  scale_fill_brewer(type="qual", palette="Set1", na.value="grey")+
  labs(
    x=NULL,
    y=NULL,
    fill="Vaccinated",
    title="Daily positive tests",
    subtitle=cohort_descr
  )+
  theme_minimal()+
  theme(
    legend.position = "left",
    strip.text.y.right = element_text(angle = 0),
    axis.line.x = element_line(colour = "black"),
    axis.text.x = element_text(angle = 70, vjust = 1, hjust=1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )


ggsave(filename=here::here("output", "models", "msm", cohort, "postestsperday.svg"), plotpostestsperday, width=20, height=30, units="cm")

postestsperday_sex_imd <- data_pt %>%
  group_by(tstop, vax_status, sex, imd) %>%
  summarise(
    date=as.Date(gbl_vars$start_date) + tstop,
    n=n(),
    positive_tests = sum(outcome)
  )



plotpostestsperday_age_ind <- ggplot(postestsperday_sex_imd) +
  geom_bar(aes(x=date, y=positive_tests, fill=vax_status==1), stat="identity", colour="transparent")+
  facet_grid(cols=vars(sex), rows=vars(imd), margins=TRUE)+
  scale_x_date(date_breaks = "1 month", labels = scales::date_format("%Y-%m"))+
  scale_fill_brewer(type="qual", palette="Set1", na.value="grey")+
  labs(
    x=NULL,
    y=NULL,
    fill="Vaccinated",
    title="Daily positive tests",
    subtitle=cohort_descr
  )+
  theme_minimal()+
  theme(
    legend.position = "left",
    strip.text.y.right = element_text(angle = 0),
    axis.line.x = element_line(colour = "black"),
    axis.text.x = element_text(angle = 70, vjust = 1, hjust=1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )


ggsave(filename=here::here("output", "models", "msm", cohort, "postestsperday_sex_imd.svg"), plotpostestsperday_age_ind, width=20, height=30, units="cm")
