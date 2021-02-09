
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
    # -- see section 3.3 of the timedep vignette in survival package
    tte_censor = tte(start_date, censor_date, censor_date),
    tte_outcome = tte(start_date, outcome_date, censor_date, na.censor=TRUE),
    tte_outcome_censored = tte(start_date, outcome_date, censor_date, na.censor=FALSE),
    ind_outcome = censor_indicator(outcome_date, censor_date),

    tte_vax1 = tte(start_date, covid_vax_1_date, pmin(censor_date, outcome_date, covid_vax_2_date, na.rm=TRUE), na.censor=TRUE),
    tte_vax1_Inf = if_else(is.na(tte_vax1), 500, tte_vax1),
    tte_vax1_censored = tte(start_date, covid_vax_1_date, pmin(censor_date, outcome_date, covid_vax_2_date, na.rm=TRUE), na.censor=FALSE),
    ind_vax1 = censor_indicator(covid_vax_1_date, pmin(censor_date, outcome_date, covid_vax_2_date, na.rm=TRUE)),

    tte_vax2 = tte(start_date, covid_vax_2_date, pmin(censor_date, outcome_date, na.rm=TRUE), na.censor=TRUE),
    tte_vax2_Inf = if_else(is.na(tte_vax2), 500, tte_vax2),
    tte_vax2_censored = tte(start_date, covid_vax_2_date, pmin(censor_date, outcome_date, na.rm=TRUE), na.censor=FALSE),
    ind_vax2 = censor_indicator(covid_vax_2_date, pmin(censor_date, outcome_date, na.rm=TRUE)),


    tte_vax2 = tte(start_date, covid_vax_2_date, pmin(censor_date, outcome_date, na.rm=TRUE), na.censor=TRUE),
    tte_vax2_censored = tte(start_date, covid_vax_2_date, censor_date, na.censor=FALSE),
    ind_vax2 = censor_indicator(covid_vax_2_date, pmin(censor_date, outcome_date, na.rm=TRUE)),

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


coxmod_tt1 <- coxph(
  Surv(tte_outcome_censored, ind_outcome) ~ tt(tte_vax1_Inf) + age + sex + imd + cluster(patient_id),
  data = data_time,
  tt = function(x, t, ...){

    vax1_status <- fct_case_when(
      t <= x | is.na(x)  ~ 'unvaccinated',
      (x < t) & (t <= x+10) ~ 'vax1(0,10]',
      (x+10 < t) & (t <= x+21) ~ 'vax1(10,21]',
      (x+21 < t) ~ 'vax1(21,Inf)',
      TRUE ~ NA_character_
    )
    vax1_status
  }
)
summary(coxmod_tt1)

cat("  \n  ")
cat("one-row-per-patient tt(), 2 doses")
cat("  \n  ")

coxmod_tt2 <- coxph(
  Surv(tte_outcome_censored, ind_outcome) ~ tt(cbind(tte_vax1_Inf, tte_vax2_Inf)) + age + sex + imd + cluster(patient_id),
  data = data_time,
  tt = function(x, t, ...){

    x1 <- x[,1]
    x2 <- x[,2]

    vax1_status <- fct_case_when(
      t <= x1 | is.na(x1)  ~ 'unvaccinated',
      (x1 < t) & (t <= x1+10) ~ 'vax1(0,10]',
      (x1+10 < t) & (t <= x1+21) ~ 'vax1(10,21]',
      (x1+21 < t) ~ 'vax1(21,Inf)',
      TRUE ~ NA_character_
    )

    vax2_status <- fct_case_when(
      t <= x2 | is.na(x2)  ~ 'novax2',
      (x2 < t) & (t <= x2+10) ~ 'vax2(0,10]',
      (x2+10 < t) & (t <= x2+21) ~ 'vax2(10,21]',
      (x2+21 < t) ~ 'vax2(21,Inf)',
      TRUE ~ NA_character_
    )

    if_else(vax2_status=="novax2", as.character(vax1_status), as.character(vax2_status))

  }
)
summary(coxmod_tt2)



## use tmerge method


cat("  \n")
cat("mergedata v1, use tstart tstop")
cat("  \n")


data_tm <- tmerge(
  data1=data_time %>% select(patient_id, sex, age, imd, tte_vax1_Inf),
  data2=data_time,
  id=patient_id,
  vax1_0_10 = tdc(tte_vax1),
  vax1_11_21 = tdc(tte_vax1+10),
  vax1_22_Inf = tdc(tte_vax1+21),
  outcome = event(tte_outcome),
  tstop = tte_censor
) %>%
{print(attr(., "tcount")); .} %>%
group_by(patient_id) %>%
#filter(cumsum(lag(outcome, 1, 0)) == 0) %>% #remove any observations after first occurrence of outcome
mutate(
  enum = row_number(),
  width = tstop - tstart,
  postvaxperiod = vax1_0_10 + vax1_11_21 + vax1_22_Inf
) %>%
ungroup()



coxmod_tm1 <- coxph(
  Surv(tstart, tstop, outcome) ~ as.factor(postvaxperiod) + age + sex + imd + cluster(patient_id),
  data = data_tm
)
summary(coxmod_tm1)




# cat("mergedata v2, use tt()")
#
# data_tm2 <- tmerge(
#   data1=data_time %>% select(patient_id, sex, age, imd, tte_vax1_Inf),
#   data2=data_time,
#   id=patient_id,
#   outcome = event(tte_outcome),
#   tstop = tte_censor
# ) %>%
#   {print(attr(., "tcount")); .} %>%
#   group_by(patient_id) %>%
#   #filter(cumsum(lag(outcome, 1, 0)) == 0) %>% #remove any observations after first occurrence of outcome
#   mutate(
#     enum = row_number(),
#     width = tstop - tstart,
#   ) %>%
#   ungroup()
#
#
# coxmod_tm2 <- coxph(
#   Surv(tstart, tstop, outcome) ~ tt(tte_vax1_Inf) + age + sex + imd + cluster(patient_id),
#   data = data_tm2,
#   tt = list(
#     function(x, t, ...){
#       vax_status <- fct_case_when(
#         t <= x | is.na(x)  ~ 'unvaccinated',
#         (x < t) & (t <= x+10) ~ '(0,10]',
#         (x+10 < t) & (t <= x+21) ~ '(10,21]',
#         (x+21 < t) ~ '(21,Inf)',
#         TRUE ~ NA_character_
#       )
#       vax_status
#     },
#     function(x, t, ...){x}
#   )
# )
# summary(coxmod_tm2)


sink()

