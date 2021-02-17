
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data
# creates additional survival variables for use in models (eg time to event from study start date)
# fits 3 models for vaccine effectiveness, with 3 different adjustment sets
# models are
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "survival_functions.R"))

## create output directories ----
dir.create(here::here("output", "models", "cox", "over80s"), showWarnings = FALSE, recursive=TRUE)


## Import processed data ----

data_tte <- read_rds(here::here("output", "modeldata", "data_tte_day_over80s.rds")) # wide (one row per patient)
data_tte_cp <- read_rds(here::here("output", "modeldata", "data_tte_day_cp_over80s.rds")) # counting-process (one row per patient per event)


# MODELS ----

## PH model ----
# proportional hazards model, with no time-varying treatment effect, only time-varying vaccination
# need to use tmerge to extend analysis dataframe, to one-row-per-event
# because cox.zph doesn't work with models specified using tt()


coxmod_ph <- coxph(
  Surv(tstart, tstop, outcome) ~ as.factor(vax_status) + age + sex + imd + cluster(patient_id),
  data = data_tte_cp, x=TRUE
)

# tests for proportional hazards, used for plotting spline over time
coxmod_ph_zph <- cox.zph(coxmod_ph, transform= "km", terms=FALSE)


#plot(coxmod_ph_zph[1])
# if there's a NA/NAN/Inf warning, then there may be observations in the dataset _after_ the outcome has occurred
# or possibly spline fit did not work (likely with dummy data)

# print plots

# print dummy plot first
# then overwrite with actual plot if it works
# wrap try around plot call because often fails on dummy data

png(filename=here::here("output","models", "cox", "over80s", "zph_vax.png"))
plot(c(1,2),c(1,2))
try(plot(coxmod_ph_zph[1]), silent=TRUE)
dev.off()


png(filename=here::here("output","models", "cox", "over80s", "zph_age.png"))
plot(c(1,2),c(1,2))
try(plot(coxmod_ph_zph[2]), silent=TRUE)
dev.off()



## non-PH models ----
# time-varying treatment (vaccination) with time-varying effects for vax1 and vax2 (not brand-specific)

postvaxcuts <- c(0, 3, 7, 14, 21) # use if coded as days
#postvaxcuts <- c(0, 1, 2, 3) # use if coded as weeks


### model 0 - unadjusted vaccination effect model ----
## no control variables

coxmod_tt0 <- coxph(
  formula = Surv(tte_outcome_censored, ind_outcome) ~ tt(vaxtime),
  data = data_tte %>% mutate(vaxtime =cbind(tte_vax1_Inf, tte_vax2_Inf)),
  #id = patient_id,
  #cluster = patient_id, # not needed for one-row-per-patient representation
  robust = TRUE,
  tt = function(x, t, ...){

    x1 <- x[,1]
    x2 <- x[,2]

    vax1_status <- postvax_cut(x1, t, breaks=postvaxcuts, prelabel=" pre-vax", prefix="Dose 1 ")
    vax2_status <- postvax_cut(x2, t, breaks=postvaxcuts, prelabel=" SHOULD NOT APPEAR", prefix="Dose 2 ")

    levels <- c(levels(vax1_status), levels(vax2_status))

    factor(if_else(t<=x2, as.character(vax1_status), as.character(vax2_status)), levels=levels) %>% droplevels()

  }
)

### model 1 - minimally adjusted vaccination effect model ----
## age, sex, IMD
coxmod_tt1 <- coxph(
  formula = Surv(tte_outcome_censored, ind_outcome) ~ tt(vaxtime) + age + sex + imd,
  data = data_tte %>% mutate(vaxtime =cbind(tte_vax1_Inf, tte_vax2_Inf)),
  #id = patient_id,
  #cluster = patient_id, # not needed for one-row-per-patient representation
  robust = TRUE,
  tt = function(x, t, ...){

    x1 <- x[,1]
    x2 <- x[,2]

    vax1_status <- postvax_cut(x1, t, breaks=postvaxcuts, prelabel=" pre-vax", prefix="Dose 1 ")
    vax2_status <- postvax_cut(x2, t, breaks=postvaxcuts, prelabel=" SHOULD NOT APPEAR", prefix="Dose 2 ")

    levels <- c(levels(vax1_status), levels(vax2_status))

    factor(if_else(t<=x2, as.character(vax1_status), as.character(vax2_status)), levels=levels) %>% droplevels()

  }
)

## ALTERNATIVE USING COUNTING-PROCESS DATA - DO NOT DELETE

# coxmod_tt1a <- coxph(
#   formula = Surv(tstart, tstop, outcome) ~ tt(vaxtime) + age + sex + imd,
#   data = data_tte_cp %>% mutate(vaxtime =cbind(tte_vax1_Inf, tte_vax2_Inf)),
#   cluster = patient_id, # not needed for one-row-per-patient representation
#   robust = TRUE,
#   tt = function(x, t, ...){
#
#     x1 <- x[,1]
#     x2 <- x[,2]
#
#     vax1_status <- postvax_cut(x1, t, breaks=postvaxcuts, prelabel=" pre-vax", prefix="Dose 1 ")
#     vax2_status <- postvax_cut(x2, t, breaks=postvaxcuts, prelabel=" SHOULD NOT APPEAR", prefix="Dose 2 ")
#
#     levels <- c(levels(vax1_status), levels(vax2_status))
#
#     factor(if_else(t<=x2, as.character(vax1_status), as.character(vax2_status)), levels=levels) %>% droplevels()
#
#   }
# )

### model 2 - "fully" adjusted vaccination effect model ----
## age, sex, IMD, + other comorbidities
## PLACEHOLDER FOR THE EVENTUAL FULLY ADJUSTED MODEL

coxmod_tt2 <- coxph(
  formula = Surv(tte_outcome_censored, ind_outcome) ~ tt(vaxtime) + age + sex + imd +
    chronic_cardiac_disease + current_copd + dementia + dialysis,
  data = data_tte %>% mutate(vaxtime =cbind(tte_vax1_Inf, tte_vax2_Inf)),
  #id = patient_id,
  #cluster = patient_id, # not needed for one-row-per-patient representation
  robust = TRUE,
  tt = function(x, t, ...){

    x1 <- x[,1]
    x2 <- x[,2]

    vax1_status <- postvax_cut(x1, t, breaks=postvaxcuts, prelabel=" pre-vax", prefix="Dose 1 ")
    vax2_status <- postvax_cut(x2, t, breaks=postvaxcuts, prelabel=" SHOULD NOT APPEAR", prefix="Dose 2 ")

    levels <- c(levels(vax1_status), levels(vax2_status))

    factor(if_else(t<=x2, as.character(vax1_status), as.character(vax2_status)), levels=levels) %>% droplevels()

  }
)

## report models ----

# tidy model outputs
coxmod_tidy_tt0 <- broom::tidy(coxmod_tt0, conf.int=TRUE) %>% mutate(model="Unadjusted")
coxmod_tidy_tt1 <- broom::tidy(coxmod_tt1, conf.int=TRUE) %>% mutate(model="Minimally adjusted")
coxmod_tidy_tt2 <- broom::tidy(coxmod_tt2, conf.int=TRUE) %>% mutate(model="'Fully' adjusted (temp)")

# create table with model estimates
coxmod_summary <- bind_rows(
  coxmod_tidy_tt0,
  coxmod_tidy_tt1,
  coxmod_tidy_tt2
) %>%
mutate(
  hr = exp(estimate),
  hr.ll = exp(estimate - robust.se*qnorm(0.975)),
  hr.ul = exp(estimate + robust.se*qnorm(0.975)),
)
write_csv(coxmod_summary, path = here::here("output", "models", "cox", "over80s", "estimates.csv"))

# create forest plot
coxmod_forest <- coxmod_summary %>%
  filter(str_detect(term, "vaxtime")) %>%
  mutate(
    dose=str_extract(term, pattern="Dose \\d"),
    term=str_replace(term, pattern="tt\\(vaxtime\\)", ""),
    term=str_replace(term, pattern="imd", "IMD "),
    term=str_replace(term, pattern="sex", "Sex "),
    term=str_replace(term, pattern="Dose \\d", ""),
    term=fct_inorder(term)
  ) %>%
  ggplot(aes(colour=model)) +
  geom_point(aes(x=hr, y=forcats::fct_rev(factor(term))), position = position_dodge(width = 0.5))+
  geom_linerange(aes(xmin=hr.ll, xmax=hr.ul, y=forcats::fct_rev(factor(term))), position = position_dodge(width = 0.5))+
  geom_vline(aes(xintercept=1), colour='grey')+
  facet_grid(rows=vars(dose), scales="free_y", switch="y")+
  scale_x_log10()+
  scale_y_discrete(na.translate=FALSE)+
  coord_cartesian(xlim=c(0.1,10)) +
  labs(
    x="Hazard ratio, versus no vaccination",
    y=NULL,
    colour=NULL,
    title="Hazard ratios, positive test by time since vaccination",
    subtitle="Aged 80+, non-carehome, no prior positive test"
  ) +
  theme_bw()+
  theme(
    panel.border = element_blank(),
    axis.line.x = element_line(colour = "black"),

    strip.background = element_blank(),
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0),

    plot.title = element_text(hjust = 0),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0, face= "italic"),
    strip.text.y = element_text(angle = 0),

    legend.position = "right"
  )


## save plot
ggsave(filename=here::here("output", "models", "cox", "over80s", "forest_plot.svg"), coxmod_forest, width=20, height=20, units="cm")

