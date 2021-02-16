
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data
# creates additional survival variables for use in models (eg time to event from study start date)
# fits 3 marginal structural models for vaccine effectiveness, with 3 different adjustment sets
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
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

## create output directories ----
dir.create(here::here("output", "models", "msm", "over80s"), showWarnings = FALSE, recursive=TRUE)


## Import processed data ----

data_tte_pt <- read_rds(here::here("output", "modeldata", "data_tte_week_pt_over80s.rds")) # counting-process (one row per patient per event)


#postvaxcuts <- c(0, 3, 6, 12, 21) # use if coded as days
postvaxcuts <- c(0, 1, 2, 3) # use if coded as weeks


# IPW model ----

# consider:
# piecewise period effects with eg as.factor(tstop)
# polynomial splines, eg, t + I(t^2) + I(t^3)
# using GAMs for getting spline effect of calendar time, with library('mgcv')
# localised infection rates (then can ignore calendar time?)

# tests:
# test that model complexity/DoF for vax1 and vax2 is the same (eg same factor levels for predictors)
# test that no first and second vax occur on the same day (or week or whatever time period is)

## models for first and second vaccination ----

data_tte_pt_atriskvax1 <- data_tte_pt %>% filter(vax_history==0)
data_tte_pt_atriskvax2 <- data_tte_pt %>% filter(vax_history==1)

### with time-updating covariates

ipwvax1 <- glm(
  formula = vax1 ~ age + I(age*age) + sex + imd + as.character(tstop),
  data = data_tte_pt_atriskvax1,
  family=binomial
)

ipwvax2 <- glm(
  formula = vax2 ~ age + I(age*age) + sex + imd + as.character(tstop),
  data = data_tte_pt_atriskvax2,
  family=binomial
)


### without time-updating covariates ----
# exclude time-updating covariates _except_ variables derived from calendar time itself (eg as.factor(calendar_time))
# used for stabilised ip weights

# using quadratic time for now;

ipwvax1_fxd <- glm(
  formula = vax1 ~ age + I(age*age) + sex + imd + tstop,# + I(tstop^2),
  data = data_tte_pt_atriskvax1,
  family=binomial
)


ipwvax2_fxd <- glm(
  formula = vax2 ~ age + I(age*age) + sex + imd + tstop,# + I(tstop^2),
  data = data_tte_pt_atriskvax2,
  family=binomial
)


## get predictions from model ----

data_predvax1 <- data_tte_pt_atriskvax1 %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    predvax1=predict(ipwvax1, type="response"),
    predvax1_fxd=predict(ipwvax1_fxd, type="response"),
  )

data_predvax2 <- data_tte_pt_atriskvax2 %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    predvax2=predict(ipwvax2, type="response"),
    predvax2_fxd=predict(ipwvax2_fxd, type="response"),
  )


data_weights <- data_tte_pt %>%
  left_join(data_predvax1, by=c("patient_id", "tstart", "tstop")) %>%
  left_join(data_predvax2, by=c("patient_id", "tstart", "tstop")) %>%
  group_by(patient_id) %>%
  mutate(

    predvax1 = if_else(vax_history==1L, 1, predvax1),
    predvax2 = if_else(vax_history==0L, 0, predvax2),
    predvax2 = if_else(vax_history==2L, 1, predvax2),

    # get probability of occurrence of realised vaccination status
    probstatus = case_when(
      vax_status==0L ~ 1-predvax1,
      vax_status==1L ~ 1-predvax2,
      vax_status==2L ~ predvax2,
      TRUE ~ NA_real_
    ),

    # cumulative product of status probabilities
    cmlprobstatus = cumprod(probstatus),

    # inverse probability weights
    ipweight = 1/cmlprobstatus,


    #same but for time-independent model

    predvax1_fxd = if_else(vax_history==1L, 1, predvax1_fxd),
    predvax2_fxd = if_else(vax_history==0L, 0, predvax2_fxd),
    predvax2_fxd = if_else(vax_history==2L, 1, predvax2_fxd),

    probstatus_fxd = case_when(
      vax_status==0L ~ 1-predvax1_fxd,
      vax_status==1L ~ 1-predvax2_fxd,
      vax_status==2L ~ predvax2_fxd,
      TRUE ~ NA_real_
    ),

    cmlprobstatus_fxd = cumprod(probstatus_fxd),

    # stabilised inverse probability weights
    ipweight_stbl = cmlprobstatus_fxd/cmlprobstatus,

  ) %>%
  ungroup()

## output weight distribution file ----

summarise_weights <-
  data_weights %>%
  select(starts_with("ipweight")) %>%
  map(redacted_summary_num) %>%
  enframe()

capture.output(
  walk2(summarise_weights$value, summarise_weights$name, print_num),
  file = here::here("output", "models", "msm", "over80s", "weights.txt"),
  append=FALSE
)


# MSM model ----

# do not use time-dependent covariates as these are accounted for with the weights
# use cluster standard errors
# use quasibinomial to suppress "non-integer #successes in a binomial glm!" warning
# use interaction with time terms?

### model 0 - unadjusted vaccination effect model ----
## no control variables

msmmod0 <- glm(
  formula = outcome ~ timesincevax_pw,
  data = data_weights,
  weights = ipweight_stbl,
  family = quasibinomial
)

summary(msmmod0)

### model 1 - minimally adjusted vaccination effect model ----
## age, sex, IMD

msmmod1 <- glm(
  formula = outcome ~ timesincevax_pw + age + sex + imd,
  data = data_weights,
  weights = ipweight_stbl,
  family = quasibinomial
)

summary(msmmod1)

### model 2 - "fully" adjusted vaccination effect model ----
## age, sex, IMD, + other comorbidities
## PLACEHOLDER FOR THE EVENTUAL FULLY ADJUSTED MODEL

msmmod2 <- glm(
  formula = outcome ~ timesincevax_pw + age + sex + imd +
    chronic_cardiac_disease + current_copd + dementia + dialysis,
  data = data_weights,
  weights = ipweight_stbl,
  family = quasibinomial
)

summary(msmmod2)

## report models ----

# tidy model outputs
msmmod_tidy0 <- broom::tidy(msmmod0, conf.int=TRUE) %>% mutate(model="Unadjusted")
msmmod_tidy1 <- broom::tidy(msmmod1, conf.int=TRUE) %>% mutate(model="Minimally adjusted")
msmmod_tidy2 <- broom::tidy(msmmod2, conf.int=TRUE) %>% mutate(model="'Fully' adjusted (temp)")

# library('sandwich')
# library('lmtest')
# create table with model estimates
msmmod_summary <- bind_rows(
  msmmod_tidy0,
  msmmod_tidy1,
  msmmod_tidy2
) %>%
mutate(
  or = exp(estimate),
  or.ll = exp(conf.low),
  or.ul = exp(conf.high),
)
write_csv(msmmod_summary, path = here::here("output", "models", "msm", "over80s", "estimates.csv"))

# create forest plot
msmmod_forest <- msmmod_summary %>%
  filter(str_detect(term, "timesincevax")) %>%
  mutate(
    dose=str_extract(term, pattern="Dose \\d"),
    term=str_replace(term, pattern="timesincevax\\_pw", ""),
    term=str_replace(term, pattern="imd", "IMD "),
    term=str_replace(term, pattern="sex", "Sex "),
    term=str_replace(term, pattern="Dose \\d", ""),
    term=fct_inorder(term)
  ) %>%
  ggplot(aes(colour=model)) +
  geom_point(aes(x=or, y=forcats::fct_rev(factor(term))), position = position_dodge(width = 0.5))+
  geom_linerange(aes(xmin=or.ll, xmax=or.ul, y=forcats::fct_rev(factor(term))), position = position_dodge(width = 0.5))+
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
    subtitle="Aged 80+, non-carehome, no prior positive test (non-robust standard errors)"
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
ggsave(filename=here::here("output", "models", "msm", "over80s", "forest_plot.svg"), msmmod_forest, width=20, height=20, units="cm")

