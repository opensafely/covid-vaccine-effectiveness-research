
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits some marginal structural models for vaccine effectiveness by brand, with different adjustment sets
# "tte" = "time-to-event"

# The script should be run via an action in the project.yaml
# The script must be accompanied by two arguments,
# 1. the name of the cohort defined in data_define_cohorts.R
# 2. the name of the outcome defined in data_define_cohorts.R
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
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
outcome <- args[[2]]

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  outcome <- "postest"
}



# Import metadata for cohort ----

metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
metadata <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort & metadata_cohorts[["outcome"]]==outcome, ]


stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))

## define model hyper-parameters and characteristics ----

### model names ----

list2env(metadata, globalenv())

## or equivalently:
# cohort <- metadata_cohorts$cohort
# cohort_descr <- metadata_cohorts$cohort_descr
# outcome <- metadata_cohorts$outcome
# outcome_descr <- metadata_cohorts$outcome_descr

### define parglm optimisation parameters ----

parglmparams <- parglm.control(
  method = "LINPACK",
  nthreads = 8
)


### post vax time periods ----

postvaxcuts <- c(0, 3, 7, 14, 21) # use if coded as days
#postvaxcuts <- c(0, 1, 2, 3) # use if coded as weeks

### knot points for calendar time splines ----

knots <- c(21)

## define outcomes, exposures, and covariates ----

formula_demog <- . ~ . + age + I(age*age) + sex + imd
formula_exposure <- . ~ . + timesincevax_pw
formula_comorbs <- . ~ . +
  chronic_cardiac_disease + current_copd + dementia + dialysis +
  solid_organ_transplantation + chemo_or_radio + sickle_cell_disease +
  permanant_immunosuppression + temporary_immunosuppression + asplenia +
  intel_dis_incl_downs_syndrome + psychosis_schiz_bipolar +
  lung_cancer + cancer_excl_lung_and_haem + haematological_cancer
formula_secular <- . ~ . + ns(tstop, knots=knots)
formula_secular_region <- . ~ . + ns(tstop, knots=knots)*region
formula_timedependent <- . ~ . + hospital_status # consider adding local infection rates

# create output directories ----
dir.create(here::here("output", cohort, outcome, "models"), showWarnings = FALSE, recursive=TRUE)

# Import processed data ----

data_pt <- read_rds(here::here("output", cohort, "data", glue::glue("data_pt.rds"))) %>% # person-time dataset (one row per patient per day)
  #fastDummies::dummy_cols(select_columns="region") %>%
  filter(
    tstop <= .[[glue::glue("tte_{outcome}")]] | is.na(.[[glue::glue("tte_{outcome}")]]), # follow up ends at occurrence of outcome
    !(vaxpfizer_history>0 & vaxaz_history>0), #exclude follow-up time with mixed branding
  ) %>%
  mutate(
    timesincevax_pw = timesince2_cut(timesincevax1, timesincevax2, postvaxcuts, "pre-vax"),
    outcome = .[[outcome]]
  )




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

data_pt_atriskvax1 <- data_pt %>% filter(vaxpfizer_history==0 & vaxaz_history==0)
data_pt_atriskvax2_pfizer1 <- data_pt %>% filter(vaxpfizer_history==1 & vaxaz_history==0)
data_pt_atriskvax2_az1 <- data_pt %>% filter(vaxaz_history==1 & vaxpfizer_history==0)


## DO WE NEED TO CONVERT THIS TO MULTINOMIAL LOGIT?

# at risk of first ever vaccine being pfizer
cat("ipwvaxpfizer1 \n")
ipwvaxpfizer1 <- parglm(
  formula = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_timedependent),
  data = data_pt_atriskvax1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail"
)
jtools::summ(ipwvaxpfizer1)


# at risk of first ever vaccine being az
cat("ipwvaxaz1 \n")
ipwvaxaz1 <- parglm(
  formula = update(vaxaz1 ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_timedependent),
  data = data_pt_atriskvax1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail"
)
jtools::summ(ipwvaxaz1)

#at risk of second pfizer vaccine, given first vaccine pfizer
cat("ipwvaxpfizer2_pfizer1 \n")
ipwvaxpfizer2_pfizer1 <- parglm(
  formula = update(vaxpfizer2 ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_timedependent),
  data = data_pt_atriskvax2_pfizer1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail"
)
jtools::summ(ipwvaxpfizer2_pfizer1)

# at risk of second pfizer vaccine, given first vaccine az
# cat("ipwvaxpfizer2_az1 \n")
# ipwvaxpfizer2_az1 <- parglm(
#   formula = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_timedependent),
#   data = data_pt_atriskvax2_az1,
#   family=binomial,
#   control = parglmparams,
#   na.action = "na.fail"
# )
# jtools::summ(ipwvaxpfizer2_az1)

# at risk of second az vaccine, given first vaccine az
cat("ipwvaxaz2_az1 \n")
ipwvaxaz2_az1 <- parglm(
  formula = update(vaxaz2 ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_timedependent),
  data = data_pt_atriskvax2_az1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail"
)
summary(ipwvaxaz2_az1)

# at risk of second az vaccine, given first vaccine pfizer
# cat("ipwvaxaz2_pfizer1 \n")
# ipwvaxaz2_pfizer1 <- parglm(
#   formula = update(vaxaz1 ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_timedependent),
#   data = data_pt_atriskvax2_pfizer1,
#   family=binomial,
#   control = parglmparams,
#   na.action = "na.fail"
# )
# jtools::summ(ipwvaxaz2_pfizer1)



### without time-updating covariates ----
# exclude time-updating covariates _except_ variables derived from calendar time itself (eg poly(calendar_time,2))
# used for stabilised ip weights


# at risk of first ever vaccine being pfizer
cat("ipwvaxpfizer1_fxd \n")
ipwvaxpfizer1_fxd <- parglm(
  formula = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_secular),
  data = data_pt_atriskvax1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail"
)
jtools::summ(ipwvaxpfizer_fxd1)


# at risk of first ever vaccine being az
cat("ipwvaxaz1_fxd \n")
ipwvaxaz1_fxd <- parglm(
  formula = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_secular),
  data = data_pt_atriskvax1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail"
)
jtools::summ(ipwvaxaz1_fxd)

#at risk of second vaccine being pfizer, given first vaccine pfizer
cat("ipwvaxpfizer2_pfizer1_fxd \n")
ipwvaxpfizer2_pfizer1_fxd <- parglm(
  formula = update(vaxpfizer2 ~ 1, formula_demog) %>% update(formula_secular),
  data = data_pt_atriskvax2_pfizer1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail"
)
jtools::summ(ipwvaxpfizer2_pfizer1_fxd)

# at risk of second vaccine pfizer, given first vaccine az
# cat("ipwvaxpfizer2_az1 \n")
# ipwvaxpfizer2_az1 <- parglm(
#   formula = update(vaxpfizer1 ~ 1, formula_demog) %>% update(formula_secular),
#   data = data_pt_atriskvax2_az1,
#   family=binomial,
#   control = parglmparams,
#   na.action = "na.fail"
# )
# jtools::summ(ipwvaxpfizer2_az1)

# at risk of second vaccine az, given first vaccine az
cat("ipwvaxaz2_az1_fxd \n")
ipwvaxaz2_az1_fxd <- parglm(
  formula = update(vaxaz2 ~ 1, formula_demog) %>% update(formula_secular),
  data = data_pt_atriskvax2_az1,
  family=binomial,
  control = parglmparams,
  na.action = "na.fail"
)
jtools::summ(ipwvaxaz2_az1_fxd)

# at risk of second vaccine az, given first vaccine pfizer
# cat("ipwvaxaz2_pfizer1 \n")
# ipwvaxaz2_pfizer1 <- parglm(
#   formula = update(vaxaz1 ~ 1, formula_demog) %>% update(formula_secular),
#   data = data_pt_atriskvax2_pfizer1,
#   family=binomial,
#   control = parglmparams,
#   na.action = "na.fail"
# )
# jtools::summ(ipwvaxaz2_pfizer1)




## get predictions from model ----

data_pt_atriskvax1
data_pt_atriskvax2_pfizer1
data_pt_atriskvax2_az1


data_predvax1 <- data_pt_atriskvax1 %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    predvaxpfizer1=predict(ipwvaxpfizer1, type="response"),
    predvaxpfizer1_fxd=predict(ipwvaxpfizer1_fxd, type="response"),

    predvaxaz1=predict(ipwvaxaz1, type="response"),
    predvaxaz1_fxd=predict(ipwvaxaz1_fxd, type="response"),
  )

data_predvaxpfizer2_pfizer1 <- data_pt_atriskvax2_pfizer1 %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    predvaxpfizer2_pfizer1=predict(ipwvaxpfizer2_pfizer1, type="response"),
    predvaxpfizer2_pfizer1_fxd=predict(ipwvaxpfizer2_pfizer1_fxd, type="response"),
  )


data_predvaxaz2_az1 <- data_pt_atriskvax2_az1 %>%
  transmute(
    patient_id,
    tstart, tstop,

    # get predicted probabilities from ipw models
    predvaxaz2_az1=predict(ipwvaxaz2_az1, type="response"),
    predvaxaz2_az1_fxd=predict(ipwvaxaz2_az1_fxd, type="response"),
  )


data_weights <- data_pt %>%
  left_join(data_predvax1, by=c("patient_id", "tstart", "tstop")) %>%
  left_join(data_predvaxpfizer2_pfizer1, by=c("patient_id", "tstart", "tstop")) %>%
  left_join(data_predvaxpfizer2_pfizer1, by=c("patient_id", "tstart", "tstop")) %>%
  group_by(patient_id) %>%
  mutate(

    predvaxpfizer1 = if_else(vaxpfizer_history==1L, 1, predvaxpfizer1),
    predvaxpfizer1 = if_else(vaxaz_history==1L, 0, predvaxpfizer1),

    predvaxaz1 = if_else(vaxaz_history==1L, 1, predvaxaz1),
    predvaxaz1 = if_else(vaxpfizer_history==1L, 0, predvaxaz1),

    predvaxpfizer2_pfizer1 = if_else(vaxpfizer_history==0L, 0, predvaxpfizer2_pfizer1),
    predvaxpfizer2_pfizer1 = if_else(vaxpfizer_history==2L, 1, predvaxpfizer2_pfizer1),
    predvaxpfizer2_pfizer1 = if_else(vaxaz_history==1L, 0, predvaxpfizer2_pfizer1),

    predvaxaz2_az1 = if_else(vaxaz_history==0L, 0, predvaxaz2_az1),
    predvaxaz2_az1 = if_else(vaxaz_history==2L, 1, predvaxaz2_az1),
    predvaxaz2_az1 = if_else(vaxpfizer_history==1L, 0, predvaxaz2_az1),

    # get probability of occurrence of realised vaccination status
    # NEED MNLOGIT HERE!
    probstatus = case_when(
      vax_status==0L ~ 1-predvaxpfizer1-predvaxaz1, #incorrect from here onwards
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
  file = here::here("output", "models", "msm", cohort, "weights.txt"),
  append=FALSE
)


# MSM model ----

# do not use time-dependent covariates as these are accounted for with the weights
# use cluster standard errors
# use quasibinomial to suppress "non-integer #successes in a binomial glm!" warning
# use interaction with time terms?

### model 0 - unadjusted vaccination effect model ----
## no control variables, just weighted

cat("msmmod0 \\n")
msmmod0 <- parglm(
  formula = update(outcome ~ 1, formula_exposure),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail"
)

summary(msmmod0)

### model 1 - minimally adjusted vaccination effect model ----
cat("msmmod1 \\n")
msmmod1 <- parglm(
  formula = update(outcome ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_exposure),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail"
)

summary(msmmod1)

### model 2 - "fully" adjusted vaccination effect model ----
cat("msmmod2 \\n")
msmmod2 <- parglm(
  formula = update(outcome ~ 1, formula_demog) %>% update(formula_secular) %>% update(formula_comorbs) %>% update(formula_exposure),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail"
)

summary(msmmod2)

cat("msmmod3 \\n")
msmmod3 <- parglm(
  formula = update(outcome ~ 1, formula_demog) %>% update(formula_secular_region) %>% update(formula_comorbs) %>% update(formula_exposure),
  data = data_weights,
  weights = ipweight_stbl,
  family = binomial,
  control = parglmparams,
  na.action = "na.fail"
)

summary(msmmod3)

## report models ----

# tidy model outputs

msmmod_tidy0 <- tidy_parglm(msmmod0, conf.int=TRUE) %>% mutate(model="Unadjusted")
msmmod_tidy1 <- tidy_parglm(msmmod1, conf.int=TRUE) %>% mutate(model="Minimal adj.")
msmmod_tidy2 <- tidy_parglm(msmmod2, conf.int=TRUE) %>% mutate(model="Full adj.")
msmmod_tidy3 <- tidy_parglm(msmmod2, conf.int=TRUE) %>% mutate(model="Full adj. by region")

# library('sandwich')
# library('lmtest')
# create table with model estimates
msmmod_summary <- bind_rows(
  msmmod_tidy0,
  msmmod_tidy1,
  msmmod_tidy2,
  msmmod_tidy3
) %>%
mutate(
  or = exp(estimate),
  or.ll = exp(conf.low),
  or.ul = exp(conf.high),
)
write_csv(msmmod_summary, path = here::here("output", "models", "msm", cohort, "estimates.csv"))

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
    title=glue::glue("{outcome_descr} by time since vaccination"),
    subtitle=cohort_descr
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
ggsave(filename=here::here("output", "models", "msm", cohort, "forest_plot.svg"), msmmod_forest, width=20, height=20, units="cm")


## secular trends ----

ggsecular2 <- interactions::interact_plot(
  msmmod2,
  pred=tstop, modx=region, data=data_weights,
  colors="Set1", vary.lty=FALSE,
  x.label="Days since 7 Dec 2020",
  y.label=glue::glue("{outcome_descr} prob.")
 )
ggsecular3<- interactions::interact_plot(
  msmmod3, pred=tstop, modx=region, data=data_weights,
  colors="Set1", vary.lty=FALSE,
  x.label="Days since 7 Dec 2020",
  y.label=glue::glue("{outcome_descr} prob.")
)

ggsecular_patch <- patchwork::wrap_plots(list(ggsecular2, ggsecular3), ncol=1, byrow=FALSE, guides="collect")

ggsave(filename=here::here("output", "models", "msm", cohort, "secular_trends_region_plot.svg"), ggsecular_patch, width=20, height=30, units="cm")

