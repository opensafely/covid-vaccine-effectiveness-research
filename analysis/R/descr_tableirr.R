
# # # # # # # # # # # # # # # # # # # # #
# This script:
# takes a cohort name as defined in data_define_cohorts.R, and imported as an Arg
# creates descriptive outputs on patient characteristics by vaccination status at 0, 28, and 56 days.
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by one argument,
# 1. the name of the cohort defined in data_define_cohorts.R
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')
library('gt')
library('gtsummary')

## Import custom user functions from lib

source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  removeobs <- FALSE
} else {
  # use for actions
  cohort <- args[[1]]
  removeobs <- TRUE
}

## import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
#list2env(gbl_vars, globalenv())


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())

## create output directory ----
dir.create(here::here("output", cohort, "descriptive", "tables"), showWarnings = FALSE, recursive=TRUE)

## Import processed data ----
data_cohort <- read_rds(here::here("output", cohort, "data", "data_cohort.rds"))
characteristics <- read_rds(here::here("output", "metadata", "baseline_characteristics.rds"))

# create pt data ----

data_tte <- data_cohort %>%
  transmute(
    patient_id,

    start_date,
    end_date,

    #composite of death, deregistration and end date
    lastfup_date = pmin(death_date, end_date, dereg_date, na.rm=TRUE),

    tte_enddate = tte(start_date, end_date, end_date),

    # time to last follow up day
    tte_lastfup = tte(start_date, lastfup_date, lastfup_date),

    # time to deregistration
    tte_dereg = tte(start_date, dereg_date, dereg_date),

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

    ttecensored_vaxany1 = tte(start_date, covid_vax_1_date, lastfup_date, na.censor=FALSE),
    ind_vaxany1 = censor_indicator(covid_vax_1_date, lastfup_date),

    tte_vaxpfizer1 = tte(start_date, covid_vax_pfizer_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxpfizer2 = tte(start_date, covid_vax_pfizer_2_date, lastfup_date, na.censor=TRUE),

    tte_vaxaz1 = tte(start_date, covid_vax_az_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxaz2 = tte(start_date, covid_vax_az_2_date, lastfup_date, na.censor=TRUE),
  )

if(removeobs) rm(data_cohort)

data_tte_cp <- tmerge(
  data1 = data_tte,
  data2 = data_tte,
  id = patient_id,

  vaxany1_status = tdc(tte_vaxany1),
  vaxany2_status = tdc(tte_vaxany2),

  vaxpfizer1_status = tdc(tte_vaxpfizer1),
  vaxpfizer2_status = tdc(tte_vaxpfizer2),

  vaxaz1_status = tdc(tte_vaxaz1),
  vaxaz2_status = tdc(tte_vaxaz2),

  covidtest_status = tdc(tte_covidtest),
  postest_status = tdc(tte_postest),
  covidadmitted_status = tdc(tte_covidadmitted),
  coviddeath_status = tdc(tte_coviddeath),
  noncoviddeath_status = tdc(tte_noncoviddeath),
  death_status = tdc(tte_death),
  dereg_status= tdc(tte_dereg),
  lastfup_status = tdc(tte_lastfup),

  vaxany1 = event(tte_vaxany1),
  vaxany2 = event(tte_vaxany2),
  vaxpfizer1 = event(tte_vaxpfizer1),
  vaxpfizer2 = event(tte_vaxpfizer2),
  vaxaz1 = event(tte_vaxaz1),
  vaxaz2 = event(tte_vaxaz2),
  covidtest = event(tte_covidtest),
  postest = event(tte_postest),
  covidadmitted = event(tte_covidadmitted),
  coviddeath = event(tte_coviddeath),
  noncoviddeath = event(tte_noncoviddeath),
  death = event(tte_death),
  dereg = event(tte_dereg),
  lastfup = event(tte_lastfup),

  tstart = 0L,
  tstop = tte_enddate # use enddate not lastfup because it's useful for status over time plots
)

alltimes <- expand(data_tte, patient_id, times=as.integer(full_seq(c(0, tte_enddate),1)))

data_pt <- tmerge(
  data1 = data_tte_cp,
  data2 = alltimes,
  id = patient_id,
  alltimes = event(times, times)
) %>%
  arrange(patient_id, tstop) %>%
  group_by(patient_id) %>%
  mutate(

    # define time since vaccination
    vaxany1_timesince = cumsum(vaxany1_status),
    vaxany2_timesince = cumsum(vaxany2_status),
    vaxpfizer1_timesince = cumsum(vaxpfizer1_status),
    vaxpfizer2_timesince = cumsum(vaxpfizer2_status),
    vaxaz1_timesince = cumsum(vaxaz1_status),
    vaxaz2_timesince = cumsum(vaxaz2_status),

    twidth = tstop - tstart,
    vaxany_status = vaxany1_status + vaxany2_status,
    vaxpfizer_status = vaxpfizer1_status + vaxpfizer2_status,
    vaxaz_status = vaxaz1_status + vaxaz2_status,

    fup_any = (death_status==0 & dereg_status==0),
    fup_pfizer = (death_status==0 & dereg_status==0 & vaxaz1_status==0),
    fup_az = (death_status==0 & dereg_status==0 & vaxpfizer1_status==0 & tstart>=27),
    all=0
  ) %>%
  ungroup() %>%
  # for some reason tmerge converts event indicators to numeric. So convert back to save space
  mutate(across(
    .cols = c("vaxany1",
              "vaxany2",
              "vaxpfizer1",
              "vaxpfizer2",
              "vaxaz1",
              "vaxaz2",
              "covidtest",
              "postest",
              "covidadmitted",
              "coviddeath",
              "noncoviddeath",
              "death",
              "dereg",
              "lastfup",
              "vaxany1_status",
              "vaxany2_status",
              "vaxpfizer1_status",
              "vaxpfizer2_status",
              "vaxaz1_status",
              "vaxaz2_status",
              "covidtest_status",
              "postest_status",
              "covidadmitted_status",
              "coviddeath_status",
              "noncoviddeath_status",
              "death_status",
              "dereg_status",
              "lastfup_status",
    ),
    .fns = as.integer
  ))

if(removeobs) rm(data_tte_cp)


## create person-time table ----

format_ratio = function(numer,denom, width=7){
  paste0(
    replace_na(scales::comma_format(accuracy=1)(numer), "--"),
    " /",
    str_pad(replace_na(scales::comma_format(accuracy=1)(denom),"--"), width=width, pad=" ")
  )
}

rrCI_normal <- function(n, pt, ref_n, ref_pt, group, accuracy=0.001){
  rate <- n/pt
  ref_rate <- ref_n/ref_pt
  rr <- rate/ref_rate
  log_rr <- log(rr)
  selog_rr <- sqrt((1/n)+(1/ref_n))
  log_ll <- log_rr - qnorm(0.975)*selog_rr
  log_ul <- log_rr + qnorm(0.975)*selog_rr
  ll <- exp(log_ll)
  ul <- exp(log_ul)

  if_else(
    group==levels(group)[1],
    NA_character_,
    paste0("(", scales::number_format(accuracy=accuracy)(ll), "-", scales::number_format(accuracy=accuracy)(ul), ")")
  )
}

rrCI_exact <- function(n, pt, ref_n, ref_pt, group, accuracy=0.001){

  # use exact methods if incidence is very low for immediate post-vaccine outcomes

  rate <- n/pt
  ref_rate <- ref_n/ref_pt
  rr <- rate/ref_rate

  ll = ref_pt/pt * (n/(ref_n+1)) * 1/qf(2*(ref_n+1), 2*n, p = 0.05/2, lower.tail = FALSE)
  ul = ref_pt/pt * ((n+1)/ref_n) * qf(2*(n+1), 2*ref_n, p = 0.05/2, lower.tail = FALSE)

  if_else(
    group==levels(group)[1],
    NA_character_,
    paste0("(", scales::number_format(accuracy=accuracy)(ll), "-", scales::number_format(accuracy=accuracy)(ul), ")")
  )

}

# get confidence intervals for rate ratio using unadjusted poisson GLM
# uses gtsummary not broom::tidy to make it easier to paste onto original data

rrCI_glm <- function(n, pt, x, accuracy=0.001){

  dat<-tibble(n=n, pt=pt, x=x)

  poismod <- glm(
    formula = n ~ x + offset(log(pt*365.25)),
    family=poisson,
    data=dat
  )

  gtmodel <- tbl_regression(poismod, exponentiate=TRUE)$table_body %>%
    filter(reference_row %in% FALSE) %>%
    select(label, conf.low, conf.high)

  dat2 <- left_join(dat, gtmodel, by=c("x"="label"))

  if_else(
    dat2$x==first(dat2$x),
    NA_character_,
    paste0("(", scales::number_format(accuracy=accuracy)(dat2$conf.low), "-", scales::number_format(accuracy=accuracy)(dat2$conf.high), ")")
  )
}

pt_summary <- function(data, fup, timesince, postvaxcuts, baseline){

  unredacted <- data %>%
    mutate(
      timesincevax = data[[timesince]],
      fup = data[[fup]],
      timesincevax_pw = timesince_cut(timesincevax, postvaxcuts, baseline),
    ) %>%
    filter(fup==1) %>%
    select(
      timesincevax_pw,
      postest_status,
      covidadmitted_status,
      coviddeath_status,
      noncoviddeath_status,
      death_status,
      postest,
      coviddeath,
      covidadmitted,
      noncoviddeath,
      death
    ) %>%
    group_by(timesincevax_pw) %>%
    summarise(
      postest_yearsatrisk=sum(postest_status==0)/365.25,
      postest_n=sum(postest),
      postest_rate=postest_n/postest_yearsatrisk,

      covidadmitted_yearsatrisk=sum(covidadmitted_status==0)/365.25,
      covidadmitted_n=sum(covidadmitted),
      covidadmitted_rate=covidadmitted_n/covidadmitted_yearsatrisk,

      coviddeath_yearsatrisk=sum(coviddeath_status==0)/365.25,
      coviddeath_n=sum(coviddeath),
      coviddeath_rate=coviddeath_n/coviddeath_yearsatrisk,

      noncoviddeath_yearsatrisk=sum(noncoviddeath_status==0)/365.25,
      noncoviddeath_n=sum(noncoviddeath),
      noncoviddeath_rate=noncoviddeath_n/noncoviddeath_yearsatrisk,

      death_yearsatrisk=sum(death_status==0)/365.25,
      death_n=sum(death),
      death_rate=death_n/death_yearsatrisk,
    ) %>%
    ungroup() %>%
    mutate(
      postest_rr=postest_rate/first(postest_rate),
      covidadmitted_rr=covidadmitted_rate/first(covidadmitted_rate),
      coviddeath_rr=coviddeath_rate/first(coviddeath_rate),
      noncoviddeath_rr=noncoviddeath_rate/first(noncoviddeath_rate),
      death_rr=death_rate/first(death_rate),

      postest_rrCI = rrCI_exact(postest_n, postest_yearsatrisk, first(postest_n), first(postest_yearsatrisk), timesincevax_pw, 0.01),
      covidadmitted_rrCI = rrCI_exact(covidadmitted_n, covidadmitted_yearsatrisk, first(covidadmitted_n), first(covidadmitted_yearsatrisk),  timesincevax_pw, 0.01),
      coviddeath_rrCI = rrCI_exact(coviddeath_n, coviddeath_yearsatrisk, first(coviddeath_n), first(coviddeath_yearsatrisk),  timesincevax_pw, 0.01),
      noncoviddeath_rrCI = rrCI_exact(noncoviddeath_n, noncoviddeath_yearsatrisk, first(noncoviddeath_n), first(noncoviddeath_yearsatrisk), timesincevax_pw, 0.01),
      death_rrCI = rrCI_exact(death_n, death_yearsatrisk, first(death_n), first(death_yearsatrisk), timesincevax_pw, 0.01),
    )

  redacted <- unredacted %>%
    mutate(
      postest_rate = redactor2(postest_n, 5, postest_rate),
      covidadmitted_rate = redactor2(covidadmitted_n, 5, covidadmitted_rate),
      coviddeath_rate = redactor2(coviddeath_n, 5, coviddeath_rate),
      noncoviddeath_rate = redactor2(noncoviddeath_n, 5, noncoviddeath_rate),
      death_rate = redactor2(death_n, 5, death_rate),

      postest_rr = redactor2(postest_n, 5, postest_rr),
      covidadmitted_rr = redactor2(covidadmitted_n, 5, covidadmitted_rr),
      coviddeath_rr = redactor2(coviddeath_n, 5, coviddeath_rr),
      noncoviddeath_rr = redactor2(noncoviddeath_n, 5, noncoviddeath_rr),
      death_rr = redactor2(death_n, 5, death_rr),

      postest_rrCI = redactor2(postest_n, 5, postest_rrCI),
      covidadmitted_rrCI = redactor2(covidadmitted_n, 5, covidadmitted_rrCI),
      coviddeath_rrCI = redactor2(coviddeath_n, 5, coviddeath_rrCI),
      noncoviddeath_rrCI = redactor2(noncoviddeath_n, 5, noncoviddeath_rrCI),
      death_rrCI = redactor2(death_n, 5, death_rrCI),

      postest_n = redactor2(postest_n, 5),
      covidadmitted_n = redactor2(covidadmitted_n, 5),
      coviddeath_n = redactor2(coviddeath_n, 5),
      noncoviddeath_n = redactor2(noncoviddeath_n, 5),
      death_n = redactor2(death_n, 5)
    )

  redacted
}


data_summary_any <- local({
    temp1 <- pt_summary(data_pt, "fup_any", "vaxany1_timesince", postvaxcuts, "Unvaccinated")
    temp2 <- pt_summary(data_pt, "fup_any", "all", postvaxcuts, "Total") %>% mutate(across(.cols=ends_with("_rr"), .fns = ~ NA_real_))
    bind_rows(temp1, temp2) %>%  mutate(brand ="Any vaccine")
})

data_summary_pfizer <- local({
  temp1 <- pt_summary(data_pt, "fup_pfizer", "vaxpfizer1_timesince", postvaxcuts, "Unvaccinated")
  temp2 <- pt_summary(data_pt, "fup_pfizer", "all", postvaxcuts, "Total") %>% mutate(across(.cols=ends_with("_rr"), .fns = ~ NA_real_))
  bind_rows(temp1, temp2) %>% mutate(brand ="BNT162b2")
})

data_summary_az <- local({
  temp1 <- pt_summary(data_pt, "fup_az", "vaxaz1_timesince", postvaxcuts, "Unvaccinated")
  temp2 <- pt_summary(data_pt, "fup_az", "all", postvaxcuts, "Total") %>% mutate(across(.cols=ends_with("_rr"), .fns = ~ NA_real_))
  bind_rows(temp1, temp2) %>% mutate(brand ="ChAdOx1")
})

data_summary <- bind_rows(
  data_summary_any,
  data_summary_pfizer,
  data_summary_az
) %>%
  mutate(
    postest_q = format_ratio(postest_n,postest_yearsatrisk),
    covidadmitted_q = format_ratio(covidadmitted_n,covidadmitted_yearsatrisk),
    coviddeath_q = format_ratio(coviddeath_n,coviddeath_yearsatrisk),
    noncoviddeath_q = format_ratio(noncoviddeath_n,noncoviddeath_yearsatrisk),
    death_q = format_ratio(death_n,death_yearsatrisk),
  ) %>%
  select(brand, starts_with("timesince"), ends_with(c("_q","_rr", "_rrCI")))

data_summary %>%
  mutate(
    postest_rr = scales::label_number(accuracy=0.01, trim=FALSE)(postest_rr),
    covidadmitted_rr = scales::label_number(accuracy=0.01, trim=FALSE)(covidadmitted_rr),
    coviddeath_rr = scales::label_number(accuracy=0.01, trim=FALSE)(coviddeath_rr),
    noncoviddeath_rr = scales::label_number(accuracy=0.01, trim=FALSE)(noncoviddeath_rr),
    death_rr = scales::label_number(accuracy=0.01, trim=FALSE)(death_rr),
  ) %>%
write_csv(here::here("output", cohort, "descriptive", "tables", "table_irr.csv"))

tab_summary <- data_summary %>%
  gt(
    groupname_col = "brand",
  ) %>%
  cols_label(
    brand = "Vaccine brand",
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

gtsave(tab_summary, here::here("output", cohort, "descriptive", "tables", "table_irr.html"))


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


