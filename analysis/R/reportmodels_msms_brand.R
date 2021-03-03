
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data and restricts it to patients in "cohort"
# fits some marginal structural models for vaccine effectiveness, with different adjustment sets
# saves model summaries (tables and figures)
# "tte" = "time-to-event"
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
outcome <- args[[2]]
brand <- args[[3]]

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
  outcome <- "postest"
  brand <- "pfizer"
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


# Import processed data ----

data_weights <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("data_weights.rds")))

# import models ----


ipwvax1 <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model_vax1.rds")))
ipwvax2 <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model_vax2.rds")))
ipwvax1_fxd <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model_vax1_fxd.rds")))
ipwvax2_fxd <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model_vax2_fxd.rds")))
msmmod0 <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model0.rds")))
msmmod1 <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model1.rds")))
msmmod2 <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model2.rds")))
msmmod3 <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model3.rds")))
msmmod4 <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model4.rds")))
msmmod5 <- read_rds(here::here("output", cohort, outcome, "models", brand, glue::glue("model5.rds")))



## report models ----

# tidy model outputs

msmmod_tidy0 <- tidy_parglm(msmmod0, conf.int=TRUE) %>% mutate(model="0 Unadjusted")
msmmod_tidy1 <- tidy_parglm(msmmod1, conf.int=TRUE) %>% mutate(model="1 Age, sex, IMD")
msmmod_tidy2 <- tidy_parglm(msmmod2, conf.int=TRUE) %>% mutate(model="2  + co-morbidities")
msmmod_tidy3 <- tidy_parglm(msmmod3, conf.int=TRUE) %>% mutate(model="3  + spatio-temporal trends")
msmmod_tidy4 <- tidy_parglm(msmmod4, conf.int=TRUE) %>% mutate(model="4  + IP-weighting")
msmmod_tidy5 <- tidy_parglm(msmmod5, conf.int=TRUE) %>% mutate(model="5 trends + IP-weighting only")

# library('sandwich')
# library('lmtest')
# create table with model estimates
msmmod_summary <- bind_rows(
  msmmod_tidy0,
  msmmod_tidy1,
  msmmod_tidy2,
  msmmod_tidy3,
  msmmod_tidy4,
  msmmod_tidy5,
) %>%
mutate(
  or = exp(estimate),
  or.ll = exp(conf.low),
  or.ul = exp(conf.high),
)
write_csv(msmmod_summary, path = here::here("output", cohort, outcome, "models", brand, "estimates.csv"))

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
  scale_colour_brewer(type="qual", palette="Set1", guide=guide_legend(reverse = TRUE))+
  coord_cartesian(xlim=c(0.05,5)) +
  labs(
    x="Hazard ratio, versus no vaccination",
    y=NULL,
    colour=NULL,
    title=glue::glue("{outcome_descr} by time since vaccination ({brand})"),
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
ggsave(filename=here::here("output", cohort, outcome, "models", brand, "forest_plot.svg"), msmmod_forest, width=20, height=20, units="cm")


## secular trends ----

ggsecular2 <- interactions::interact_plot(
  msmmod2,
  pred=tstop, modx=region, data=data_weights,
  colors="Set1", vary.lty=FALSE,
  x.label="Days since 7 Dec 2020",
  y.label=glue::glue("{outcome_descr} prob.")
)
ggsecular3 <- interactions::interact_plot(
  msmmod3,
  pred=tstop, modx=region, data=data_weights,
  colors="Set1", vary.lty=FALSE,
  x.label="Days since 7 Dec 2020",
  y.label=glue::glue("{outcome_descr} prob.")
 )
ggsecular4<- interactions::interact_plot(
  msmmod4, pred=tstop, modx=region, data=data_weights,
  colors="Set1", vary.lty=FALSE,
  x.label="Days since 7 Dec 2020",
  y.label=glue::glue("{outcome_descr} prob.")
)

ggsecular_patch <- patchwork::wrap_plots(list(
  ggsecular2,
  ggsecular3,
  ggsecular4
), ncol=1, byrow=FALSE, guides="collect")

ggsave(filename=here::here("output", cohort, outcome, "models", brand, "secular_trends_region_plot.svg"), ggsecular_patch, width=20, height=30, units="cm")


## estimated postvax survival ----

data_postvax_pt <- data_weights %>%
  filter(
    vax_status>0
  ) %>%
  mutate(
    timesincevax = case_when(
      vax_status==1 ~ timesincevax1,
      vax_status==2 ~ timesincevax2,
      TRUE ~ NA_integer_
    ),
  )

stopifnot("timesincevax should always be non-null" = all(!is.na(data_postvax_pt$timesincevax)))

data_surv_vax <- data_postvax_pt %>%
  arrange(patient_id, timesincevax1) %>%
  transmute(
    patient_id,
    timesincevax1,
    timesincevax2,
    timesincevax,
    timesincevax_pw,
    vax_status,
    prob_outcome = predict(msmmod3, ., type="response"),
  ) %>%
  group_by(patient_id) %>%
  mutate(
    cmlprob_outcome = 1-cumprod(1-prob_outcome),
  ) %>% ungroup()

data_surv_novax <- data_postvax_pt %>%
  arrange(patient_id, timesincevax1) %>%
  mutate(
    timesincevax_pw="pre-vax",
    vax_status=0,
  ) %>%
  transmute(
    patient_id,
    timesincevax1,
    timesincevax2,
    timesincevax,
    timesincevax_pw,
    vax_status,
    prob_outcome = predict(msmmod3, ., type="response"),
  ) %>%
  group_by(patient_id) %>%
  mutate(
    cmlprob_outcome = 1-cumprod(1-prob_outcome),
  ) %>% ungroup()


data_surv <- bind_rows(data_surv_vax, data_surv_novax) %>%
  group_by(timesincevax, vax_status) %>%
  summarise(
    prob_outcome = mean(prob_outcome),
    cmlprob_outcome = mean(cmlprob_outcome)
  )


event_rate <- ggplot(data_surv) +
  geom_step(aes(x=timesincevax, y=cmlprob_outcome, colour=factor(vax_status)))+#, group=patient_id, colour=patient_id))+
  labs(
    x="Time since dose",
    y="Positive test rate",
    colour="Doses"
  )+
  theme_minimal()

ggsave(filename=here::here("output", cohort, outcome, "models", brand, "event_rate.svg"), event_rate, width=30, height=00, units="cm")



data_surv_compare <-
  inner_join(
    data_surv_vax %>% mutate(prob_outcome_vax = prob_outcome, cmlprob_outcome_vax = cmlprob_outcome),
    data_surv_novax %>% mutate(prob_outcome_novax = prob_outcome, cmlprob_outcome_novax = cmlprob_outcome),
    by=c("patient_id",
         "timesincevax1",
         "timesincevax2",
         "timesincevax"
    )
  ) %>%
  mutate(
    effectiveness = (prob_outcome_novax - prob_outcome_vax)/prob_outcome_novax,
    cmleffectiveness = (cmlprob_outcome_novax - cmlprob_outcome_vax)/cmlprob_outcome_novax
  ) %>%
  group_by(timesincevax) %>%
  summarise(
    effectiveness = mean(effectiveness, na.rm=TRUE),
    cmleffectiveness = mean(cmleffectiveness, na.rm=TRUE)
  ) %>%
  ungroup()



event_rate_compare <- ggplot(data_surv_compare) +
  geom_step(aes(x=timesincevax, y=cmleffectiveness))+#, group=patient_id, colour=patient_id))+
  labs(
    x="Time since dose"
  )+
  theme_minimal()

ggsave(filename=here::here("output", cohort, outcome, "models", brand, "cml_effectiveness.svg"), event_rate, width=30, height=00, units="cm")


