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

data_all <- read_rds(here::here("output", "data", "data_all.rds"))

## one-row-per-patient data

data_tte <- data_all %>%
  filter(
    age>=80,
    is.na(care_home_type),
    is.na(prior_positive_test_date)
  ) %>%
  transmute(
    patient_id,
    age,
    sex,
    imd,
    #ethnicity,

    chronic_cardiac_disease,
    current_copd,
    dementia,
    dialysis,


    start_date,
    end_date,
    covid_vax_1_date,
    covid_vax_2_date,
    positive_test_1_date,
    coviddeath_date,
    death_date,

    outcome_date = positive_test_1_date, #change here for different outcomes.
    lastfup_date = pmin(death_date, end_date, outcome_date, na.rm=TRUE),

    # consider using tte+0.5 to ensure that outcomes occurring on the same day as the start date or treatment date are dealt with in the correct way
    # -- see section 3.3 of the timedep vignette in survival package
    # but might not be necessary if ties are andle appropriately (eg with tmerge)

    tte_censor = tte(start_date, lastfup_date, lastfup_date),
    tte_outcome = tte(start_date, outcome_date, lastfup_date, na.censor=TRUE),
    tte_outcome_censored = tte(start_date, outcome_date, lastfup_date, na.censor=FALSE),
    ind_outcome = censor_indicator(outcome_date, lastfup_date),

    tte_vax1 = tte(start_date, covid_vax_1_date, pmin(lastfup_date, covid_vax_2_date, na.rm=TRUE), na.censor=TRUE),
    tte_vax1_Inf = if_else(is.na(tte_vax1), Inf, tte_vax1),
    tte_vax1_censored = tte(start_date, covid_vax_1_date, pmin(lastfup_date, covid_vax_2_date, na.rm=TRUE), na.censor=FALSE),
    ind_vax1 = censor_indicator(covid_vax_1_date, pmin(lastfup_date, covid_vax_2_date, na.rm=TRUE)),

    tte_vax2 = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=TRUE),
    tte_vax2_Inf = if_else(is.na(tte_vax2), Inf, tte_vax2),
    tte_vax2_censored = tte(start_date, covid_vax_2_date, lastfup_date, na.censor=FALSE),
    ind_vax2 = censor_indicator(covid_vax_2_date, lastfup_date),

    tte_death = tte(start_date, death_date, end_date, na.censor=TRUE),
  )

rm("data_all") # to free up space

write_rds(data_tte, here::here("output", "data", "data_tte_over80s.rds"))

# system(paste(
#   'r:latest ./analysis/R/data_properties.R',
#   "output/data/data_tte_over80s.rds",
#   "output/data_properties"
#   )
# )

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
  data1 = data_tte %>% select(patient_id, sex, age, imd, tte_vax1, tte_vax2),
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


#plot(coxmod_ph_zph[1])
# if there's a NA/NAN/Inf warning, then there may be observations in the dataset _after_ the outcome has occurred
# or possibly spline fit did not work (likely with dummy data)


# print plots

# print dummy plot first
# then overwrite with actual plot if it works
# wrap try around plot call because often fails on dummy data

png(filename=here::here("output","models", "figures", "zph_postvax1.png"))
plot(c(1,2),c(1,2))
try(plot(coxmod_ph_zph[1]), silent=TRUE)
dev.off()


png(filename=here::here("output","models", "figures", "zph_postvax2.png"))
plot(c(1,2),c(1,2))
try(plot(coxmod_ph_zph[2]), silent=TRUE)
dev.off()



## non-PH model ----
# time-varying treatment (vaccination) with time-varying effects for vax1 and vax2 (not brand-specific)

# define post-vaccination time periods for piece-wise constant hazards (ie time-varying effects / time-varying coefficients)
# eg c(0, 10, 21) will create 4 periods
# pre-vaccination, [0, 10), [10, 21), and [21, inf)
# can use eg c(3, 10, 21) to treat first 3 days post-vaccination the same as pre-vaccination
# note that the exact vaccination date is set to the first "pre-vax" period,
# because in survival analysis, intervals are open-left and closed-right.

postvaxcuts <- c(0, 3, 6, 12, 21)

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


## DO NOT DELETE YET
## may be useful for reweighting

## alternative to coxmod_tt1 using long dataset
## DO NOT DELETE YET

# data_tm <- tmerge(
#   data1 = data_tte %>% select(patient_id, sex, age, imd, tte_vax1_Inf, tte_vax2_Inf),
#   data2 = data_tte,
#   id = patient_id,
#   vax1 = tdc(tte_vax1),
#   vax2 = tdc(tte_vax2),
#   outcome = event(tte_outcome),
#   tstop = tte_censor
# ) %>%
#   mutate(
#     width = tstop - tstart,
#     vax_status = vax1+vax2
#   )
#
# coxmod_tt1a <- coxph(
#   formula = Surv(tstart, tstop, outcome) ~ tt(vaxtime) + age + sex + imd,
#   data = data_tm %>% mutate(vaxtime =cbind(tte_vax1_Inf, tte_vax2_Inf)),
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
write_csv(coxmod_summary, path = here::here("output", "models", "tables", "estimates.csv"))

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
    title="Hazard ratios, positive test by time since vaccine",
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
coxmod_forest
ggsave(filename=here::here("output", "models", "figures", "forest_plot.svg"), coxmod_forest, width=20, height=20, units="cm")

