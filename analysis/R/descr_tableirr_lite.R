
# # # # # # # # # # # # # # # # # # # # #
# This script creates a table of incidence rate ratios for each brand / outcome combination
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by two arguments,
# 1. the name of the cohort defined in data_define_cohorts.R
# 2. whether or not (TRUE/FALSE) to relabel vaccinations occurring after a recent positive test as "unvaccinated"
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('lubridate')
library('survival')
library('gt')
library('gtsummary')

## Import custom user functions from lib

source(here("lib", "utility_functions.R"))
source(here("lib", "redaction_functions.R"))
source(here("lib", "survival_functions.R"))

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  exclude_recentpostest <- FALSE
  removeobs <- FALSE
} else {
  # use for actions
  cohort <- args[[1]]
  exclude_recentpostest <- as.logical(args[[2]])
  removeobs <- TRUE
}

## import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
#list2env(gbl_vars, globalenv())


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())

## create output directory ----
fs::dir_create(here("output", cohort, "descriptive", "tables"))

## Import processed data ----
data_cohort <- read_rds(here("output", cohort, "data", "data_cohort.rds"))
characteristics <- read_rds(here("output", "metadata", "baseline_characteristics.rds"))

# create pt data ----

data_tte <- data_cohort %>%
  transmute(
    patient_id,

    start_date = start_date -1,
    end_date,

    #composite of death, deregistration and end date
    lastfup_date = pmin(death_date, end_date, dereg_date, na.rm=TRUE),


    tte_firstfupany = tte(start_date, pmax(start_date, as.Date(gbl_vars$start_date_any)-1), lastfup_date),
    tte_firstfuppfizer = tte(start_date, pmax(start_date, as.Date(gbl_vars$start_date_pfizer)-1), lastfup_date),
    tte_firstfupaz = tte(start_date, pmax(start_date, as.Date(gbl_vars$start_date_az)-1), lastfup_date),

    tte_enddate = tte(start_date, end_date, end_date),

    # time to last follow up day
    tte_lastfup = tte(start_date, lastfup_date, lastfup_date),

    tte_lastfupany = tte(start_date, pmin(covid_vax_2_date, na.rm=TRUE), lastfup_date),
    tte_lastfuppfizer = tte(start_date, pmin(covid_vax_az_1_date, covid_vax_2_date, na.rm=TRUE), lastfup_date),
    tte_lastfupaz = tte(start_date, pmin(covid_vax_pfizer_1_date, covid_vax_2_date, na.rm=TRUE), lastfup_date),

    # time to test
    tte_covidtest = tte(start_date, covid_test_1_date, lastfup_date, na.censor=TRUE),

    # time to positive test
    tte_postest = tte(start_date, positive_test_1_date, lastfup_date, na.censor=TRUE),

    # time to admission
    tte_covidadmitted = tte(start_date, covidadmitted_1_date, lastfup_date, na.censor=TRUE),

    #time to covid death
    tte_coviddeath = tte(start_date, coviddeath_date, lastfup_date, na.censor=TRUE),
    tte_noncoviddeath = tte(start_date, noncoviddeath_date, lastfup_date, na.censor=TRUE),

    #time to death
    tte_death = tte(start_date, death_date, lastfup_date, na.censor=TRUE),

    tte_vaxany1 = tte(start_date, covid_vax_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxany2 = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=TRUE),

    tte_vaxpfizer1 = tte(start_date, covid_vax_pfizer_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxpfizer2 = tte(start_date, covid_vax_pfizer_2_date, lastfup_date, na.censor=TRUE),

    tte_vaxaz1 = tte(start_date, covid_vax_az_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxaz2 = tte(start_date, covid_vax_az_2_date, lastfup_date, na.censor=TRUE),
  )


if(removeobs) rm(data_cohort)

get_irr <- function(brand, outcome){

    data_atrisk <- data_tte %>%
      transmute(
        patient_id,
        tte_postest,
        tte_outcome = .[[glue("tte_{outcome}")]],
        tte_vaxbrand = .[[glue("tte_vax{brand}1")]],
        tte_firstfup = .[[glue("tte_firstfup{brand}")]],
        tte_lastfup = .[[glue("tte_lastfup{brand}")]], # overwrite to account for off-brand / second dose censoring
      ) %>%
      filter(
        tte_firstfup<pmin(tte_outcome, Inf, na.rm=TRUE), # not interested if outcome occurred before first "at risk" date
        tte_firstfup<tte_lastfup, # not interested if last follow up (death, dereg, study end date) occurred before first "at risk" date
      )


    # expand dataset to add an extra row for each postvax period
    data_timesincelong <- data_atrisk %>%
      filter(
        !is.na(tte_vaxbrand),
        tte_vaxbrand<=pmin(tte_outcome, Inf, na.rm=TRUE), # not interested if vaccination occurred after outcome (this is caught by `tstop` but is quicker to exclude earlier)
      ) %>%
      select(patient_id, tte_vaxbrand) %>%
      expand_grid(
        nesting(
          postvaxcuts = postvaxcuts,
          timesincevax_pw = as.character(timesince_cut(c(postvaxcuts[-1], Inf), postvaxcuts, "Unvaccinated"))
        )
      ) %>%
      transmute(
        patient_id,
        day = tte_vaxbrand + postvaxcuts,
        timesincevax_pw
      )

    data_pt <- data_atrisk %>%
      tmerge(
        data1 = .,
        data2 = .,
        id = patient_id,
        outcome = event(tte_outcome),
        tstart = tte_firstfup,
        tstop = pmin(tte_lastfup, tte_outcome, na.rm=TRUE)
      ) %>%
      tmerge(
        data1 = .,
        data2 = data_timesincelong,
        id=patient_id,
        timesincevax_pw = tdc(day, timesincevax_pw),
        options = list(tdcstart = "Unvaccinated")
      ) %>%
      tmerge(
        data1 = .,
        data2 = data_atrisk,
        id=patient_id,
        postest_status = tdc(tte_postest),
        postest_status_stop = tdc(tte_postest+Inf)
      ) %>%
      mutate(
        twidth = tstop - tstart,
        recentpostest = postest_status & (!postest_status_stop) & exclude_recentpostest,
        timesincevax_pw = factor(timesincevax_pw, timesince_cut(c(postvaxcuts, Inf), postvaxcuts, "Unvaccinated")),
        timesincevax_pw = if_else(!recentpostest, timesincevax_pw, factor("Unvaccinated"))
      )


    data_irr <- data_pt %>%
    group_by(timesincevax_pw) %>%
      summarise(
        yearsatrisk=sum(twidth)/365.25,
        n=sum(outcome),
        rate=n/yearsatrisk,
      ) %>%
      ungroup() %>%
      mutate(
        rr=rate/first(rate),
        rrCI = rrCI_exact(n, yearsatrisk, first(n), first(yearsatrisk), timesincevax_pw, 0.01),
      )

    data_irr_total <- data_pt %>%
      summarise(
        yearsatrisk=sum(twidth)/365.25,
        n=sum(outcome),
        rate=n/yearsatrisk,
        timesincevax_pw = "Total"
      )

    bind_rows(data_irr, data_irr_total)

}

#get_irr("az", "postest")

data_irr_nested <-
  crossing(
    nesting(brand=fct_inorder(c("any", "pfizer", "az")), brand_descr=fct_inorder(c("Any vaccine", "BNT162b2", "ChAdOx1"))),
    outcome = fct_inorder(c("postest", "covidadmitted", "coviddeath", "noncoviddeath", "death")),
  ) %>%
  mutate(
    irrs = map2(brand, outcome, get_irr)
  )


format_ratio = function(numer,denom, width=7){
  paste0(
    replace_na(scales::comma_format(accuracy=1)(numer), "--"),
    " /",
    str_pad(replace_na(scales::comma_format(accuracy=1)(denom),"--"), width=width, pad=" ")
  )
}

data_irr <- data_irr_nested %>%
  unnest(irrs) %>%
  mutate(
    rate = redactor2(n, 5, rate),
    rr = redactor2(n, 5, rr),
    rrCI = redactor2(n, 5, rrCI),
    n = redactor2(n, 5),
    q = format_ratio(n, yearsatrisk),
  )


data_irr_wide <- data_irr %>%
  pivot_wider(
    id_cols = c(brand, brand_descr, timesincevax_pw),
    names_from = outcome,
    values_from =c(n, rate, q, rr, rrCI),
    names_glue = "{outcome}_{.value}"
  )


data_irr_wide_print <-
data_irr_wide %>%
  mutate(
    across(starts_with("rr"), ~scales::label_number(accuracy=0.01, trim=FALSE)(.))
  ) %>%
  select(brand_descr, starts_with("timesince"), ends_with(c("_q","_rr", "_rrCI")))

string_exclude_recentpostest <- if(exclude_recentpostest){
  "_exclude_recentpostest"
} else {
  ""
}


data_irr_wide_print %>%
  write_csv(here("output", cohort, "descriptive", "tables", glue("table_irr{string_exclude_recentpostest}.csv")))

tab_irr <- data_irr_wide_print %>%
  gt(
    groupname_col = "brand_descr",
  ) %>%
  cols_label(
    brand_descr = "Vaccine brand",
    timesincevax_pw = "Time since first dose",


    postest_q = "Events / person-years",
    covidadmitted_q = "Events / person-years",
    coviddeath_q = "Events / person-years",
    noncoviddeath_q = "Events / person-years",
    death_q = "Events / person-years",

    # postest_yearsatrisk = "Person-years at risk",
    # covidadmitted_yearsatrisk = "Person-years at risk",
    # coviddeath_yearsatrisk = "Person-years at risk",
    # noncoviddeath_yearsatrisk = "Person-years at risk",
    # #death_yearsatrisk = "Person-years at risk",
    #
    # postest_n = "Events",
    # covidadmitted_n = "Events",
    # coviddeath_n = "Events",
    # noncoviddeath_n = "Events",
    # #death_n = "Events",
    #
    # postest_rate = "Rate/year",
    # covidadmitted_rate = "Rate/year",
    # coviddeath_rate = "Rate/year",
    # noncoviddeath_rate = "Rate/year",
    # #death_rate = "Rate/year"

    postest_rr = "Rate ratio",
    covidadmitted_rr = "Rate ratio",
    coviddeath_rr = "Rate ratio",
    noncoviddeath_rr = "Rate ratio",
    death_rr = "Rate ratio",

    postest_rrCI = "95% CI",
    covidadmitted_rrCI = "95% CI",
    coviddeath_rrCI = "95% CI",
    noncoviddeath_rrCI = "95% CI",
    death_rrCI = "95% CI"
  ) %>%
  tab_spanner(
    label = "Positive test",
    columns = starts_with("postest")
  ) %>%
  tab_spanner(
    label = "COVID-19 hospitalisation",
    columns = starts_with("covidadmitted")
  ) %>%
  tab_spanner(
    label = "COVID-19 death",
    columns = starts_with("coviddeath")
  ) %>%
  tab_spanner(
    label = "Non-COVID-19 death",
    columns = starts_with("noncoviddeath")
  ) %>%
  tab_spanner(
    label = "Any death",
    columns = starts_with("death")
  ) %>%
  # fmt_number(
  #   columns = ends_with(c("yearsatrisk")),
  #   decimals = 0
  # ) %>%
  fmt_number(
    columns = ends_with(c("rr")),
    decimals = 2
  ) %>%
  fmt_missing(
    everything(),
    missing_text="--"
  ) %>%
  cols_align(
    align = "right",
    columns = everything()
  ) %>%
  cols_align(
    align = "left",
    columns = "timesincevax_pw"
  )



gtsave(tab_irr, here("output", cohort, "descriptive", "tables", glue("table_irr{string_exclude_recentpostest}.html")))


## note:
# the follow poisson model gives the same results eg for postest
# poismod <- glm(
#   formula = postest_n ~ timesincevax_pw + offset(log(postest_yearsatrisk*365.25)),
#   family=poisson,
#   data=pt_summary(data_pt, "timesincevaxany1", postvaxcuts)
# )

# same but with person-time data
# poismod2 <- glm(
#   formula = postest ~ timesincevax_pw ,
#   family=poisson,
#   data=data_pt %>% mutate(timesincevax_pw = timesince_cut(timesincevaxany1, postvaxcuts, "Unvaccinated")) %>% filter(postest_status==0, death_status==0, dereg_status==0)
# )

# and the following pyears call gives the same results
# pyears(
#  Surv(time=tstart, time2=tstop, event=postest) ~ timesincevaxany1,
#  data=data_pt %>% filter(postest_status==0),
#  data.frame = TRUE
# )


