
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

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))


## custom functions ----


# function to extract total plot height minus panel height
plotHeight <- function(plot, unit){
  grob <- ggplot2::ggplotGrob(plot)
  grid::convertHeight(gtable::gtable_height(grob), unitTo=unit, valueOnly=TRUE)
}

# function to extract total plot width minus panel height
plotWidth <- function(plot, unit){
  grob <- ggplot2::ggplotGrob(plot)
  grid::convertWidth(gtable::gtable_width(grob), unitTo=unit, valueOnly=TRUE)
}

# function to extract total number of bars plot (strictly this is the number of rows in the build of the plot data)
plotNbars <- function(plot){
  length(unique(ggplot2::ggplot_build(plot)$data[[1]]$x))
}

# function to extract total number of bars plot (strictly this is the number of rows in the build of the plot data)
plotNfacetrows <- function(plot){
  length(levels(ggplot2::ggplot_build(plot)$data[[1]]$PANEL))
}

plotNyscales <- function(plot){
  length(ggplot2::ggplot_build(plot)$layout$panel_scales_y[[1]]$range$range)
}


# function to extract total number of panels
plotNpanelrows <- function(plot){
  length(unique(ggplot2::ggplot_build(plot)$layout$layout$ROW))
}



## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  cohort <- "over70s"
} else {
  # use for actions
  cohort <- args[[1]]
}

## import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
#list2env(gbl_vars, globalenv())


## create output directories ----
dir.create(here::here("output", cohort, "descr", "plots"), showWarnings = FALSE, recursive=TRUE)
dir.create(here::here("output", cohort, "descr", "tables"), showWarnings = FALSE, recursive=TRUE)

## define theme ----

plot_theme <-
  theme_minimal()+
  theme(
    legend.position = "left",
    panel.border=element_rect(colour='black', fill=NA),
    strip.text.y.right = element_text(angle = 0),
    axis.line.x = element_line(colour = "black"),
    axis.text.x = element_text(angle = 70, vjust = 1, hjust=1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.ticks.x = element_line(colour = 'black')
  )


## Import processed data ----
data_all <- read_rds(here::here("output", "data", "data_all.rds"))

# Import metadata for cohort ----

data_cohorts <- read_rds(here::here("output", "data", "data_cohorts.rds"))
metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))

stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))

data_cohorts <- data_cohorts[data_cohorts[[cohort]],]

metadata <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort, ]

# create data ----

data_tte <- data_all %>%
  filter(
    patient_id %in% data_cohorts$patient_id # take only the patients from defined "cohort"
  ) %>%
  transmute(
    patient_id,

    age,
    ageband,
    sex,
    imd,
    ethnicity_combined,
    region,

    start_date,
    end_date,

    #composite of death, deregisttration and end date
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

    tte_vaxpfizer1 = tte(start_date, covid_vax_pfizer_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxpfizer2 = tte(start_date, covid_vax_pfizer_2_date, lastfup_date, na.censor=TRUE),

    tte_vaxaz1 = tte(start_date, covid_vax_az_1_date, lastfup_date, na.censor=TRUE),
    tte_vaxaz2 = tte(start_date, covid_vax_az_2_date, lastfup_date, na.censor=TRUE),
  )

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
    timesincevaxany1 = cumsum(vaxany1_status),
    timesincevaxany2 = cumsum(vaxany2_status),
    timesincevaxpfizer1 = cumsum(vaxpfizer1_status),
    timesincevaxpfizer2 = cumsum(vaxpfizer2_status),
    timesincevaxaz1 = cumsum(vaxaz1_status),
    timesincevaxaz2 = cumsum(vaxaz2_status),

    twidth = tstop - tstart,
    vaxany_status = vaxany1_status + vaxany2_status,
    vaxpfizer_status = vaxpfizer1_status + vaxpfizer2_status,
    vaxaz_status = vaxaz1_status + vaxaz2_status,
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
    ),
    .fns = as.integer
  ))


# create plots ----
data_by_day <-
  data_pt %>%
  transmute(
    patient_id,
    all = "all",
    sex,
    imd,
    ethnicity_combined,
    region,
    ageband = cut(
      age,
      breaks=c(-Inf, 70, 75, 80, 85, 90, 95, Inf),
      labels=c("under 70", "70-74", "75-79", "80-84", "85-89", "90-94", "95+"),
      right=FALSE
    ),
    agecohort = cut(age, breaks= c(-Inf, 70, 80, Inf), labels=c("under 70", "70-79", "80+"), right=FALSE),
    day = tstop,
    date = as.Date(gbl_vars$start_date) + day,
    week = lubridate::floor_date(date, unit="week", week_start=1), #week commencing monday (since index date is a monday)
    date = week,

    vaxany_status_onedose = vaxany_status!=0,
    vaxany_status = fct_case_when(
      vaxany_status==0 & death_status==0 & dereg_status==0 ~ "Not vaccinated",
      vaxany_status==1 ~ "One dose",
      vaxany_status==2 ~ "Two doses",
      death_status==1 | dereg_status==1 ~ "Died/deregistered",
      TRUE ~ NA_character_
    ),
    vaxbrand_status = fct_case_when(
      vaxpfizer_status==0 & vaxaz_status==0  & death_status==0 & dereg_status==0 ~ "Not vaccinated",
      vaxpfizer_status>0 ~ "BNT162b2",
      vaxaz_status>0 ~ "ChAdOx1",
      death_status==1 | dereg_status==1 ~ "Died/deregistered",
      TRUE ~ NA_character_
    ),

    vaxbrand_status = fct_case_when(
      vaxpfizer_status==0 & vaxaz_status==0  ~ "Not vaccinated",
      vaxpfizer_status>0  ~ "BNT162b2",
      vaxaz_status>0  ~ "ChAdOx1",
      TRUE ~ NA_character_
    ),

    lastfup,
    death,
    noncoviddeath=death & !coviddeath,
    coviddeath,
    covidadmitted,
    postest,

    lastfup_status,
    death_status,
    dereg_status,
    noncoviddeath_status=death_status & !coviddeath_status,
    coviddeath_status,
    covidadmitted_status,
    postest_status,

    tte_vaxany1,

    outcome_status = fct_case_when(
      noncoviddeath_status==1 ~ "Non-COVID-19 death",
      coviddeath_status==1 ~ "COVID-19 death",
      covidadmitted_status==1 ~ "COVID-19 hospitalisation",
      postest_status==1 ~ "Positive test",
      TRUE ~ "No events"
    ) %>% fct_rev()
  ) %>%
  #group_by(patient_id) %>%
  #mutate(
  #  lag_vaxany_status_onedose = lag(vaxany_status_onedose, 14, 0),
  #  lag_vaxany_status_onedose = fct_case_when(
  #    lag_vaxany_status_onedose==0 ~ "No vaccine or\n< 14 days post-vaccine",
  #    lag_vaxany_status_onedose==1 ~ ">= 14 days post-vaccine",
  #    TRUE ~ NA_character_
  #  )
  #) %>%
  #ungroup() %>%
  droplevels()


## cumulative vaccination status ----


plot_vax_counts <- function(var, var_descr){


  data1 <- data_by_day %>%
    mutate(
      variable = data_by_day[[var]]
    ) %>%
    group_by(date, variable, vaxany_status, .drop=FALSE) %>%
    summarise(
      n = n(),
    ) %>%
    group_by(date, variable) %>%
    mutate(
      n_per_10000 = (n/sum(n))*10000
    ) %>%
    ungroup()


  plot <- data1 %>%
    ggplot() +
    geom_area(aes(x=date, y=n_per_10000, group=vaxany_status, fill=vaxany_status), alpha=0.5)+
    facet_grid(rows=vars(variable))+
    scale_x_date(date_breaks = "1 week", labels = scales::date_format("%m-%d"))+
    scale_fill_manual(values=c("#d95f02", "#7570b3", "#1b9e77", "grey"))+
    labs(
      x=NULL,
      y="Status per 10,000 people",
      colour=NULL,
      fill=NULL#,
      #title = "Vaccination status over time",
      #subtitle = var_descr
    ) +
    plot_theme+
    theme(legend.position = "bottom")

  plot
}



plot_brand_counts <- function(var, var_descr){


  data1 <- data_by_day %>%
    mutate(
      variable = data_by_day[[var]]
    ) %>%
    filter(dereg_status==0) %>%
    group_by(date, variable, vaxbrand_status, death_status, .drop=FALSE) %>%
    summarise(
      n = n(),
    ) %>%
    group_by(date, variable) %>%
    mutate(
      n_per_10000 = (n/sum(n))*10000
    ) %>%
    ungroup() %>%
    arrange(date, variable, vaxbrand_status, death_status) %>%
    mutate(
      death_status= if_else(is.na(death_status) | death_status==0, "Alive", "Dead"),
      group= factor(
        paste0(death_status,":",vaxbrand_status),
        levels= map_chr(
          cross2(c("Alive","Dead"), levels(vaxbrand_status)),
          paste, sep = ":", collapse = ":"
        )
      )
    )

  plot <- data1 %>%
    ggplot() +
    geom_area(aes(x=date, y=n_per_10000,
                  group=group,
                  fill=vaxbrand_status, alpha=death_status))+
    facet_grid(rows=vars(variable))+
    scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
    scale_fill_manual(values=c("#d95f02", "#7570b3", "#1b9e77"))+#, "grey"))+
    scale_alpha_manual(values=c(0.8,0.3))+#, "grey"))+
    #scale_alpha_discrete(range= c(0.3,0.8))+
    labs(
      x="Date",
      y="Status per 10,000 people",
      colour=NULL,
      fill=NULL,
      alpha=NULL#,
      #title = "Vaccination status over time",
      #subtitle = var_descr
    ) +
    plot_theme+
    theme(legend.position = "bottom")

  plot
}

# plot_brand_counts("all", "")
#
#
# data1 <- data_by_day %>%
#   mutate(
#     variable = data_by_day[["all"]]
#   ) %>%
#   #filter(dereg_status==0) %>%
#   group_by(date, variable, vaxbrand_status, death_status, .drop=FALSE) %>%
#   summarise(
#     n = n(),
#   ) %>%
#   group_by(date, variable) %>%
#   mutate(
#     n_per_10000 = (n/sum(n))*10000
#   ) %>%
#   ungroup() %>%
#   arrange(date, variable, vaxbrand_status, death_status) %>%
#   mutate(
#     death_status= if_else(is.na(death_status) | death_status==0, "Alive", "Dead"),
#       group= factor(
#       paste0(death_status,":",vaxbrand_status),
#       levels= map_chr(
#         cross2(c("Alive","Dead"), levels(vaxbrand_status)),
#         paste, sep = ":", collapse = ":"
#       )
#     )
#   )

## cumulative event status ----



plot_event_counts <- function(var, var_descr){

  data1 <- data_by_day %>%
    mutate(
      variable = data_by_day[[var]]
    ) %>%
    group_by(date, outcome_status, variable, lag_vaxany_status_onedose) %>%
    summarise(
      n_events = n()
    ) %>%
    group_by(date, variable, lag_vaxany_status_onedose) %>%
    mutate(
      n = (n_events/sum(n_events))*10000
    ) %>%
    ungroup()

  plot <- data1 %>%
    filter(outcome_status !="No events") %>%
    droplevels() %>%
    ggplot() +
    geom_area(aes(x=date, y=n, group=outcome_status, fill=outcome_status), alpha=0.5)+
    facet_grid(rows=vars(variable), cols=vars(lag_vaxany_status_onedose))+
    scale_x_date(date_breaks = "1 week", labels = scales::date_format("%m-%d"))+
    scale_fill_brewer(palette="Dark2")+
    labs(
      x=NULL,
      y="Events per 10,000 people",
      fill=NULL,
      title = "Outcome status over time",
      subtitle = var_descr
    ) +
    plot_theme+
    theme(legend.position = "bottom")+
    guides(fill = guide_legend(nrow = 2))

  plot
}

## event rates ----


plot_event_rates <- function(var, var_descr){

  data1 <- data_by_day %>%
    mutate(
      variable = data_by_day[[var]]
    ) %>%
    filter(!death_status) %>%
    group_by(date, variable, lag_vaxany_status_onedose) %>%
    summarise(
      n= n(),
      death_rate = (sum(death)/n())*10000,
      coviddeath_rate = (sum(coviddeath)/n())*10000,
      covidadmitted_rate = (sum(covidadmitted)/n())*10000,
      postest_rate = (sum(postest)/n())*10000
    ) %>%
    pivot_longer(
      cols=c(-n, -date, -variable, -lag_vaxany_status_onedose),
      names_to = "outcome",
      values_to = "rate"
    ) %>%
    mutate(
      outcome = factor(
        outcome,
        levels=c("postest_rate", "covidadmitted_rate", "coviddeath_rate", "death_rate"),
        labels=c("Positive test", "COVID-19 hospitalisation", "COVID-19 death", "Any death"))
    )


  plot <- data1 %>%
    ggplot() +
    geom_line(aes(x=date, y=rate, group=outcome, colour=outcome))+
    facet_grid(rows=vars(variable), cols=vars(lag_vaxany_status_onedose))+
    scale_x_date(date_breaks = "1 week", labels = scales::date_format("%m-%d"))+
    scale_color_brewer(palette="Dark2")+
    labs(
      x=NULL,
      y="Event rate per week per 10,000 people",
      colour=NULL#,
      #title = "Outcome rates over time",
      #subtitle = var_descr
    ) +
    plot_theme+
    guides(colour = guide_legend(nrow = 2))+
    theme(legend.position = "bottom")

  plot

}

vars_df <- tribble(
  ~var, ~var_descr,
  "agecohort", "",
  "sex", "Sex",
  "imd", "IMD",
  "ageband", "Age",
  "ethnicity_combined", "Ethnicity",
  "region", "Region"
) %>% mutate(
  device="svg",
  units = "cm",
)

vars_df %>%
  transmute(
    plot = pmap(lst(var, var_descr), plot_vax_counts),
    plot = patchwork::align_patches(plot),
    filename = paste0("vaxcounts_",var,".svg"),
    path=here::here("output", cohort, "descr", "plots"),
    panelwidth = 15,
    panelheight = 7,
    #width = pmap_dbl(list(plot, units, panelwidth), function(plot, units, panelwidth){plotWidth(plot, units) + panelwidth}),
    units="cm",
    width = 25,
    height = pmap_dbl(list(plot, units, panelheight), function(plot, units, panelheight){plotHeight(plot, units) + plotNpanelrows(plot)*panelheight}),
  ) %>%
  mutate(
    pmap(list(
      filename=filename,
      plot=plot,
      path=path,
      width=width, height=height, units=units, limitsize=FALSE, scale=0.8
    ),
    ggsave)
  )


vars_df %>%
  transmute(
    plot = pmap(lst(var, var_descr), plot_brand_counts),
    plot = patchwork::align_patches(plot),
    filename = paste0("brandcounts_",var,".svg"),
    path=here::here("output", cohort, "descr", "plots"),
    panelwidth = 15,
    panelheight = 7,
    #width = pmap_dbl(list(plot, units, panelwidth), function(plot, units, panelwidth){plotWidth(plot, units) + panelwidth}),
    units="cm",
    width = 25,
    height = pmap_dbl(list(plot, units, panelheight), function(plot, units, panelheight){plotHeight(plot, units) + plotNpanelrows(plot)*panelheight}),
  ) %>%
  mutate(
    pmap(list(
      filename=filename,
      plot=plot,
      path=path,
      width=width, height=height, units=units, limitsize=FALSE, scale=0.8
    ),
    ggsave)
  )

#
# vars_df %>%
#   transmute(
#     plot = pmap(lst(var, var_descr), plot_event_counts),
#     plot = patchwork::align_patches(plot),
#     filename = paste0("eventcounts_",var,".svg"),
#     path=here::here("output", cohort, "descr", "plots"),
#     panelwidth = 15,
#     panelheight = 7,
#     units="cm",
#     #width = pmap_dbl(list(plot, units, panelwidth), function(plot, units, panelwidth){plotWidth(plot, units) + panelwidth}),
#     width = 25,
#     height = pmap_dbl(list(plot, units, panelheight), function(plot, units, panelheight){plotHeight(plot, units) + plotNpanelrows(plot)*panelheight}),
#   ) %>%
#   mutate(
#     pmap(list(
#       filename=filename,
#       path=path,
#       plot=plot,
#       width=width, height=height, units=units, limitsize=FALSE, scale=0.8
#     ),
#     ggsave)
#   )
#
#
#
#
# vars_df %>%
#   transmute(
#     plot = pmap(lst(var, var_descr), plot_event_rates),
#     plot = patchwork::align_patches(plot),
#     filename = paste0("eventrates_",var,".svg"),
#     path=here::here("output", cohort, "descr", "plots"),
#     panelwidth = 15,
#     panelheight = 7,
#     units="cm",
#     #width = pmap_dbl(list(plot, units, panelwidth), function(plot, units, panelwidth){plotWidth(plot, units) + panelwidth}),
#     width = 25,
#     height = pmap_dbl(list(plot, units, panelheight), function(plot, units, panelheight){plotHeight(plot, units) + plotNpanelrows(plot)*panelheight}),
#   ) %>%
#   mutate(
#     pmap(list(
#       filename=filename,
#       path=path,
#       plot=plot,
#       width=width, height=height, units=units, limitsize=FALSE, scale=0.8
#     ),
#     ggsave)
#   )


## end-date status ----
tab_end_status <- data_pt %>%
  filter(lastfup == 1) %>%
  summarise(
    n = n(),
    alive_unvax = sum(vaxany_status==0 & death_status==0),
    vaxany = sum(vaxany_status>0 & death_status==0),
    vaxpfizer = sum(vaxpfizer_status>0 & death_status==0),
    vaxaz = sum(vaxaz_status>0 & death_status==0),
    vaxpfizer_pct = vaxpfizer / vaxany,
    vaxaz_pct = vaxaz / vaxany,
    dead_unvax = sum(vaxany_status==0 & death==1),
    dereg_unvax = sum(vaxany_status==0 & dereg==1),

    pt_days = sum(tstop),
    pt_years = sum(tstop)/365.25,

    pt_days_vax = sum(tstop)-sum(pmin(tte_vaxany1, tstop, na.rm=TRUE)),
    pt_years_vax = (sum(tstop)-sum(pmin(tte_vaxany1, tstop, na.rm=TRUE)))/365.25,

    pt_pct_vax = pt_days_vax / pt_days,

    fup_min = min(tstop),
    fup_q1 = quantile(tstop, 0.25),
    fup_median = median(tstop),
    fup_q3 = quantile(tstop, 0.75),
    max_fup = max(tstop),
  )

write_csv(tab_end_status, here::here("output", cohort, "descr", "tables", "end_status.csv"))
