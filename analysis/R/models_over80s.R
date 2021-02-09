
sink(file = "./output/cox.txt", split = FALSE)

# Import libraries ----
library('tidyverse')

source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))

# Import processed data ----

data_over80s <- read_rds(here::here("output", "data", "data_over80s.rds"))


# Import libraries ----
library('tidyverse')
library('lubridate')
library('jsonlite')
library('survival')


## one-row-per-patient data

data_time <- data_over80s %>%
  transmute(
    patient_id,
    age,
    sex,
    imd,

    start_date,
    end_date,
    covid_vax_1_date,
    outcome_date = positive_test_1_date, #change here for different outcomes.
    censor_date = pmin(death_date, end_date, outcome_date, na.rm=TRUE),

    # +0.5 ensures that outcomes occurring on the same day as the start date or treatment date are dealt with in the correct way
    # -- see sectoin 3.3 of timedep vignette in survival package
    tte_censor = tte(start_date, censor_date, censor_date)+0.5,
    tte_outcome = tte(start_date, outcome_date, censor_date, na.censor=TRUE)+0.5,
    tte_outcome_censored = tte(start_date, outcome_date, censor_date, na.censor=FALSE)+0.5,
    ind_outcome = censor_indicator(outcome_date, censor_date),

    tte_vax1 = tte(start_date, covid_vax_1_date, pmin(censor_date, outcome_date, na.rm=TRUE), na.censor=TRUE),
    tte_vax1_censored = tte(start_date, covid_vax_1_date, censor_date, na.censor=FALSE),
    ind_vax1 = censor_indicator(covid_vax_1_date, pmin(censor_date, outcome_date, na.rm=TRUE)),

    tte_death = tte(start_date, death_date, end_date, na.censor=TRUE)+0.5,
  )

options(width=200) # set output width for capture.output
dir.create(here::here("output","data_summary"), showWarnings = FALSE, recursive=TRUE)
capture.output(skimr::skim(data_time), file = here::here("output", "data_summary", "time_colsummary.txt"), split=FALSE)


## PH model with only time-varying vax, no time-varying coefficients

# cat("  \n")
# cat("tmerge cox PH model")
# cat("  \n")

# data_tm0 <- tmerge(
#   data1 = data_time %>% select(patient_id, sex, age, imd),
#   data2 = data_time,
#   id = patient_id,
#   vax1 = tdc(tte_vax1),
#   outcome = event(tte_outcome),
#   tstop = tte_censor
# ) %>%
# mutate(
#   width = tstop - tstart
# ) #%>%
#group_by(patient_id) %>%
#filter(cumsum(lag(outcome, 1, 0)) == 0) #remove any observations after first occurrence of outcome


# coxmod_ph <- coxph(
#   Surv(tstart, tstop, outcome) ~vax1 + age + sex + imd + cluster(patient_id),
#   data = data_tm0, x=TRUE
# )
# summary(coxmod_ph)
#
# zp <- cox.zph(coxmod_ph, transform= "km", terms=FALSE)

#plot(zp[1])
# if there's a NA/NAN/Inf warning, then there may be observations in the dataset _after_ the outcome has occurred
# OR...

cat("  \n")
cat("simple cox model")
cat("  \n")


coxmod_ph <- coxph(Surv(tte_outcome_censored, ind_outcome) ~ age + sex,
                   data = data_time, x=TRUE
                   )
summary(coxmod_ph)

zp <- cox.zph(coxmod_ph, transform= "km", terms=FALSE)
try(plot(zp[1]), silent=TRUE)


cat("  \n  ")
cat("one-row-per-patient tt()")
cat("  \n  ")


coxmod_tt <- coxph(
  Surv(tte_outcome_censored, ind_outcome) ~ tt(tte_vax1_censored) + age + sex + imd + cluster(patient_id),
  data = data_time,
  tt = function(x, t, ...){
    vax_status <- fct_case_when(
      t <= x ~ 'unvaccinated',
      (x < t) & (t <= x+10) ~ '(0,10]',
      (x+10 < t) & (t <= x+21) ~ '(10,21]',
      (x+21 < t) ~ '(21,Inf)',
      TRUE ~ NA_character_
    )
    vax_status
  }
)
summary(coxmod_tt)



## use tmerge method


cat("  \n")
cat("mergedata v1, use tstart tstop")
cat("  \n")


data_tm <- tmerge(
  data1=data_time %>% select(patient_id, sex, age, imd, tte_vax1_censored),
  data2=data_time,
  id=patient_id,
  vax1_0_10 = tdc(tte_vax1),
  vax1_11_21 = tdc(tte_vax1+10),
  vax3_22_Inf = tdc(tte_vax1+21),
  outcome = event(tte_outcome),
  tstop = tte_censor
) %>%
tmerge(
  data1 = .,
  data2 = .,
  id= patient_id,
  enum = cumtdc(tstart)
) %>%
{print(attr(., "tcount")); .} %>%
mutate(
  width = tstop - tstart
) %>%
group_by(patient_id) %>%
filter(cumsum(lag(outcome, 1, 0)) == 0) %>% #remove any observations after first occurrence of outcome
mutate(
  postvaxperiod = vax1_0_10 + vax1_11_21 + vax3_22_Inf
)



coxmod_tm1 <- coxph(
  Surv(tstart, tstop, outcome) ~ as.factor(postvaxperiod) + age + sex + imd + cluster(patient_id),
  data = data_tm
)
summary(coxmod_tm1)

#cat("mergedata v2, use tt()")
#
# coxmod_tm2 <- coxph(
#   Surv(tstart, tstop, outcome) ~ tt(tte_vax1_censored) + age + sex + cluster(patient_id),
#   data = data_tm,
#   tt = function(x, t, ...){
#     vax_status <- fct_case_when(
#       t <= x ~ 'unvaccinated',
#       (x < t) & (t <= x+10) ~ '(0,10]',
#       (x+10 < t) & (t <= x+21) ~ '(10,21]',
#       (x+21 < t) ~ '(21,Inf)',
#       TRUE ~ NA_character_
#     )
#     vax_status
#   }
# )
# summary(coxmod_tm2)


sink()

