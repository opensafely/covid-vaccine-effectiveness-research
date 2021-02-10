
# Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')
library('survminer')

source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "survival_functions.R"))

# create output directories ----

dir.create(here::here("output", "models", "figures"), showWarnings = FALSE, recursive=TRUE)
dir.create(here::here("output", "models", "tables"), showWarnings = FALSE, recursive=TRUE)


# Import processed data ----

data_tte <- read_rds(here::here("output", "data", "data_tte_ready_over80s.rds"))

# functions ----
postvax_cut <- function(x, t, breaks, prelabel="pre", prefix=""){

  # this function defines post-vaccination time-periods at time `t`,
  # for a vaccination occurring at time `x`
  # delimited by `breaks`

  # note, intervals are open on the left and closed on the right
  # so at the exact time point the vaccination occurred, it will be classed as "pre-dose".

  x <- as.numeric(x)
  x <- if_else(!is.na(x), x, Inf)

  diff <- t-x
  breaks_aug <- unique(c(-Inf, breaks, Inf))
  labels0 <- cut(c(breaks, Inf), breaks_aug)
  labels <- paste0(prefix, c(prelabel, as.character(labels0[-1])))
  period <- cut(diff, breaks=breaks_aug, labels=labels, include.lowest=TRUE)


  period
}
#
# t=0:50
# x=6
# breaks=c(0,10,21)
#
# cbind(t, t-x, as.character(postvax_cut(x, t, cutoff)))



# MODELS ----

## PH model ----
# with only time-varying vaccination, no time-varying coefficients
# need to use tmerge to extend analysis dataframe,
# because cox.zph doesn't work with models specified using tt()

data_tm <- tmerge(
  data1 = data_tte %>% select(patient_id, sex, age, imd),
  data2 = data_tte,
  id = patient_id,
  vax1 = tdc(tte_vax1),
  vax2 = tdc(tte_vax2),
  outcome = event(tte_outcome),
  tstop = tte_censor
) %>%
mutate(
  width = tstop - tstart,
  vax_status = vax1+vax2
)

coxmod_ph <- coxph(
  Surv(tstart, tstop, outcome) ~ as.factor(vax_status) + age + sex + imd + cluster(patient_id),
  data = data_tm, x=TRUE
)

coxmod_ph_zph <- cox.zph(coxmod_ph, transform= "km", terms=FALSE)

# wrap try around plot call because often fails on dummy data
try(coxmod_ph_zph_vax1 <- plot(coxmod_ph_zph[1]), silent=TRUE)
try(coxmod_ph_zph_vax2 <- plot(coxmod_ph_zph[2]), silent=TRUE)
# if there's a NA/NAN/Inf warning, then there may be observations in the dataset _after_ the outcome has occurred
# or possibly spline fit did not work (likely with dummy data)


# print plots
if(exists("coxmod_ph_zph_vax1")){

  png(filename=here::here("output","models", "zph_postvax1.png"))
  plot(coxmod_ph_zph_vax1)
  dev.off()
}

if(exists("coxmod_ph_zph_vax2")){

  png(filename=here::here("output","models", "zph_postvax2.png"))
  plot(coxmod_ph_zph_vax2)
  dev.off()
}


## non-PH model ----
# time-varying treatment (vaccination) with time-varying effects for vax1 and vax2 (not brand-specific)

# define post-vaccination time periods for piece-wise constant hazards (ie time-varying effects / time-varying coefficients)
# eg c(0, 10, 21) will create 4 periods
# pre-vaccination, [0, 10), [10, 21), and [21, inf)
# can use eg c(3, 10, 21) to treat first 3 days post-vaccination the same as pre-vaccination
# note that the exact vaccination date is set to the first "pre-vax" period,
# because in survival analysis, intervals are open-left and closed-right.

postvaxcuts <- c(0, 3, 6, 9, 12, 21)

coxmod_tt <- coxph(
  formula = Surv(tte_outcome_censored, ind_outcome) ~ tt(vaxtime) + age + sex + imd,
  data = data_tte %>% mutate(vaxtime =cbind(tte_vax1_Inf, tte_vax2_Inf)),
  #id = patient_id,
  #cluster = patient_id, # not needed for one-row-per-patient representation
  robust = TRUE,
  tt = function(x, t, ...){

    x1 <- x[,1]
    x2 <- x[,2]

    vax1_status <- postvax_cut(x1, t, breaks=postvaxcuts, prelabel=" pre-vax", prefix="vax 1 ")
    vax2_status <- postvax_cut(x2, t, breaks=postvaxcuts, prelabel=" SHOULD NOT APPEAR", prefix="vax 2 ")

    if_else(t<=x2, as.character(vax1_status), as.character(vax2_status))

  }
)

# create table with model estimates
coxmod_table <- broom::tidy(coxmod_tt, conf.int=TRUE) %>%
  mutate(
    hr = exp(estimate),
    hr.ll = exp(estimate - robust.se*qnorm(0.975)),
    hr.ul = exp(estimate + robust.se*qnorm(0.975)),
  )
write_csv(coxmod_table, file = here::here("output", "models", "tables", "estimates.csv"))

# create forest plot
coxmod_forest <- ggforest(coxmod_tt)
png(filename=here::here("output","models", "figures", "forest_plot.png"))
plot(coxmod_forest)
dev.off()



# OLD TEST MODELS keep for sense-checking ---


## cox model, time-varying vaccination status using tt() functions ----
# cat("  \n  ")
# cat("one-row-per-patient tt()")
# cat("  \n  ")
#
#
# coxmod_tt1 <- coxph(
#   Surv(tte_outcome_censored, ind_outcome) ~ tt(tte_vax1_Inf) + age + sex + imd + cluster(patient_id),
#   data = data_tte,
#   tt = function(x, t, ...){
#
#     vax1_status <- postvax_cut(x, t, breaks=postvaxcuts, prefix="vax1 ")
#
#     # vax1_status <- fct_case_when(
#     #   t <= x | is.na(x)  ~ 'unvaccinated',
#     #   (x < t) & (t <= x+10) ~ 'vax1[(0,10]',
#     #   (x+10 < t) & (t <= x+21) ~ 'vax1(10,21]',
#     #   (x+21 < t) ~ 'vax1(21,Inf)',
#     #   TRUE ~ NA_character_
#     # )
#     vax1_status
#   }
# )
# summary(coxmod_tt1)


## use tmerge method


# cat("  \n")
# cat("mergedata v1, use tstart tstop")
# cat("  \n")
#
#
# data_tm <- tmerge(
#   data1=data_time %>% select(patient_id, sex, age, imd, tte_vax1_Inf),
#   data2=data_time,
#   id=patient_id,
#   vax1_0_10 = tdc(tte_vax1),
#   vax1_11_21 = tdc(tte_vax1+10),
#   vax1_22_Inf = tdc(tte_vax1+21),
#   outcome = event(tte_outcome),
#   tstop = tte_censor
# ) %>%
# {print(attr(., "tcount")); .} %>%
# group_by(patient_id) %>%
# #filter(cumsum(lag(outcome, 1, 0)) == 0) %>% #remove any observations after first occurrence of outcome
# mutate(
#   enum = row_number(),
#   width = tstop - tstart,
#   postvaxperiod = vax1_0_10 + vax1_11_21 + vax1_22_Inf
# ) %>%
# ungroup()
#
#
#
# coxmod_tm1 <- coxph(
#   Surv(tstart, tstop, outcome) ~ as.factor(postvaxperiod) + age + sex + imd + cluster(patient_id),
#   data = data_tm
# )
# summary(coxmod_tm1)




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

