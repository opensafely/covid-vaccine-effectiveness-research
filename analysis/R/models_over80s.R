
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


vars_list = list(
  run_date = date(file.info(here::here("metadata","generate_delivery_cohort.log"))$ctime),
  start_date = "2020-12-07",
  end_date = "2021-01-13"
)



data_baseline <- data_over80s %>%
  transmute(
    patient_id,
    age,
    sex,
    imd,
  )


## one-row-per-patient data

data_time <- data_over80s %>%
  transmute(
    patient_id,
    age,
    sex,
    imd,

    start_date,
    end_date,
    outcome_date = post_vax_positive_test_date, #change here for different outcomes
    censor_date = pmin(outcome_date, death_date, end_date, na.rm=TRUE),

    tte_censor = as.numeric(tte(start_date, censor_date, censor_date)),
    tte_outcome = as.numeric(tte(start_date, outcome_date, censor_date, na.censor=TRUE)),
    tte_outcome_censored = as.numeric(tte(start_date, outcome_date, censor_date, na.censor=FALSE)),
    ind_outcome = censor_indicator(outcome_date, censor_date),

    tte_vax1 = as.numeric(tte(start_date, covid_vax_1_date, pmin(censor_date, outcome_date, na.rm=TRUE), na.censor=TRUE)),
    tte_vax1_censored = as.numeric(tte(start_date, covid_vax_1_date, censor_date, na.censor=FALSE)),
    ind_vax1 = censor_indicator(covid_vax_1_date, pmin(censor_date, outcome_date, na.rm=TRUE)),

    tte_death = tte(start_date, death_date, end_date, na.censor=TRUE),
  )



## PH model with only time-varying vax, no time-varying coefficients


# data_tm0 <- tmerge(
#   data1 = data_time %>% select(patient_id, sex, age),
#   data2 = data_time,
#   id = patient_id,
#   vacc1 = tdc(tte_vax1),
#   outcome = event(tte_outcome),
#   tstop = as.numeric(tte_censor)
# ) %>%
#   group_by(patient_id) #%>%
#filter(cumsum(lag(outcome, 1, 0)) == 0) #remove any observations after first occurrence of outcome



# coxmod_ph <- coxph(
#   Surv(tstart, tstop, outcome) ~vacc1 + age + sex + cluster(patient_id),
#   data = data_tm0, x=TRUE
# )
# summary(coxmod_ph)
#
# zp <- cox.zph(coxmod_ph, transform= "km", terms=FALSE)

#plot(zp[1])
# if there's a NA/NAN/Inf warning, then there may be observations in the dataset _after_ the outcome has occurred
# OR...


cat("  \n")
cat("one-row-per-patient tt()")
cat("  \n")


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
  group_by(patient_id) %>%
  filter(cumsum(lag(outcome, 1, 0)) == 0) %>% #remove any observations after first occurrence of outcome
  mutate(
    postvaxperiod = vax1_0_10 + vax1_11_21 + vax3_22_Inf
  )

cat("  \n")
cat("mergedata v1, use tstart tstop")
cat("  \n")

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

