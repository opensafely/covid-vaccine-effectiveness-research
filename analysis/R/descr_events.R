
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
library('here')
library('glue')
library('lubridate')
library('survival')

## Import custom user functions from lib
source(here("lib", "utility_functions.R"))
source(here("lib", "redaction_functions.R"))


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
  cohort <- "in70s"
  removeobs <- FALSE
} else {
  # use for actions
  cohort <- args[[1]]
  removeobs <- TRUE
}




## import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
#list2env(gbl_vars, globalenv())
start_date = gbl_vars[[glue("start_date_{cohort}")]]


## create output directories ----
fs::dir_create(here("output", cohort, "descriptive", "plots"))
fs::dir_create(here("output", cohort, "descriptive", "tables"))

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

data_fixed <- read_rds(here("output", cohort, "data", "data_fixed.rds"))
data_tte <- read_rds(here("output", cohort, "data", "data_tte.rds"))
data_pt <- read_rds(here("output", cohort, "data", "data_pt.rds"))

data_pt <- data_pt %>% select(
  patient_id,
  tstart, tstop,

  vaxany1_status,
  vaxany2_status,

  vaxpfizer1_status,
  vaxpfizer2_status,

  vaxaz1_status,
  vaxaz2_status,

  vaxany_status,
  vaxpfizer_status,
  vaxaz_status,

  covidtest_status,
  postest_status,
  covidadmitted_status,
  coviddeath_status,
  noncoviddeath_status,
  death_status,
  dereg_status,
  lastfup_status,

  vaxany1,
  vaxany2,
  vaxpfizer1,
  vaxpfizer2,
  vaxaz1,
  vaxaz2,
  covidtest,
  postest,
  covidadmitted,
  coviddeath,
  noncoviddeath,
  death,
  dereg,
  lastfup,

  vaxanyday1
)

# create plots ----
data_by_day <-
  data_pt %>%
  left_join(
    data_fixed %>% transmute(
      patient_id,
      all = "",
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
      agecohort = cut(age, breaks= c(-Inf, 70, 80, Inf), labels=c("under 70", "70-79", "80+"), right=FALSE) %>% fct_rev(),
    ),
    by = "patient_id"
  ) %>%
  mutate(
    day = tstop,
    date = as.Date(start_date) + day,
    week = lubridate::floor_date(date, unit="week", week_start=2), #week commencing tuesday (since index date is a tuesday)
    #date = week,

    vaxany_status_onedose = vaxany_status!=0,
    vaxany_status = fct_case_when(
      vaxany_status==0 & death_status==0 & dereg_status==0 ~ "Not vaccinated",
      vaxany_status==1 ~ "One dose",
      vaxany_status==2 ~ "Two doses",
      death_status==1 | dereg_status==1 ~ "Died/deregistered",
      TRUE ~ NA_character_
    ),

    vaxbrand1_status = fct_case_when(
      vaxpfizer_status==0 & vaxaz_status==0  ~ "Not vaccinated",
      vaxpfizer_status>0  ~ "BNT162b2",
      vaxaz_status>0  ~ "ChAdOx1",
      TRUE ~ NA_character_
    ),


    vaxbrand12_status = fct_case_when(
      vaxpfizer_status==0 & vaxaz_status==0  ~ "Not vaccinated",
      vaxpfizer_status==1  ~ "BNT162b2\ndose 1",
      vaxpfizer_status==2  ~ "BNT162b2\ndose 2",
      vaxaz_status==1  ~ "ChAdOx1\ndose 1",
      vaxaz_status==2  ~ "ChAdOx1\ndose 2",
      TRUE ~ NA_character_
    ),

    outcome_status = fct_case_when(
      noncoviddeath_status==1 ~ "Non-COVID-19 death",
      coviddeath_status==1 ~ "COVID-19 death",
      covidadmitted_status==1 ~ "COVID-19 hospitalisation",
      postest_status==1 ~ "Positive test",
      TRUE ~ "No events"
    ) %>% fct_rev()
  )




plot_brand1_counts <- function(var, var_descr){

  data1 <- data_by_day %>%
    mutate(
      variable = data_by_day[[var]]
    ) %>%
    filter(dereg_status==0) %>%
    group_by(date, variable, vaxbrand1_status, lastfup_status, .drop=FALSE) %>%
    summarise(
      n = n(),
    ) %>%
    group_by(date, variable) %>%
    mutate(
      n_per_10000 = (n/sum(n))*10000
    ) %>%
    ungroup() %>%
    arrange(date, variable, vaxbrand1_status, lastfup_status) %>%
    mutate(
      lastfup_status = if_else(lastfup_status %in% 1, "Died / deregistered", "At-risk"),
      group= factor(
        paste0(lastfup_status,":",vaxbrand1_status),
        levels= map_chr(
          cross2(c("At-risk", "Died / deregistered"), levels(vaxbrand1_status)),
          paste, sep = ":", collapse = ":"
        )
      )
    )


  #colorspace::lighten("#1b9e77", 0.25)

  plot <- data1 %>%
    ggplot() +
    geom_area(aes(x=date, y=n_per_10000,
                  group=group,
                  fill=vaxbrand1_status,
                  alpha=lastfup_status
              )
    )+
    facet_grid(rows=vars(variable))+
    scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
    scale_fill_manual(values=c("#d95f02", "#7570b3", "#1b9e77"))+
    scale_alpha_manual(values=c(0.8,0.3), breaks=c(0.3))+
    labs(
      x="Date",
      y="Status per 10,000 people",
      colour=NULL,
      fill=NULL,
      alpha=NULL
    ) +
    plot_theme+
    theme(legend.position = "bottom")

  plot
}



plot_brand12_counts <- function(var, var_descr){

  data1 <- data_by_day %>%
    mutate(
      variable = data_by_day[[var]]
    ) %>%
    filter(dereg_status==0) %>%
    group_by(date, variable, vaxbrand12_status, lastfup_status, .drop=FALSE) %>%
    summarise(
      n = n(),
    ) %>%
    group_by(date, variable) %>%
    mutate(
      n_per_10000 = (n/sum(n))*10000
    ) %>%
    ungroup() %>%
    arrange(date, variable, vaxbrand12_status, lastfup_status) %>%
    mutate(
      lastfup_status = if_else(lastfup_status %in% 1, "Died / deregistered", "At-risk"),
      group= factor(
        paste0(lastfup_status,":",vaxbrand12_status),
        levels= map_chr(
          cross2(c("At-risk", "Died / deregistered"), levels(vaxbrand12_status)),
          paste, sep = ":", collapse = ":"
        )
      )
    )

  #colorspace::lighten("#1b9e77", 0.25)

  plot <- data1 %>%
    ggplot() +
    geom_area(aes(x=date, y=n_per_10000,
                  group=group,
                  fill=vaxbrand12_status,
                  alpha=lastfup_status
    )
    )+
    facet_grid(rows=vars(variable))+
    scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
    scale_fill_manual(values=c("#d95f02", "#7570b3", "#9590D3", "#1b9e77",  "#4BBA93"))+
    scale_alpha_manual(values=c(0.9,0.1), breaks=c(0.1))+
    labs(
      x="Date",
      y="Status per 10,000 people",
      colour=NULL,
      fill=NULL,
      alpha=NULL
    ) +
    plot_theme+
    theme(legend.position = "bottom")

  plot
}

#plot_brand1_counts("all", "")
#plot_brand12_counts("all", "")
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
  "all", "",
  "sex", "Sex",
  "imd", "IMD",
  "ageband", "Age",
  "ethnicity_combined", "Ethnicity",
) %>% mutate(
  device="svg",
  units = "cm",
)

# save data to combine across cohorts later
write_rds(
  plot_brand1_counts("all", "")$data,
  path=here("output", cohort, "descriptive", "plots", paste0("vaxcounts1.rds")), compress="gz"
)

write_rds(
  plot_brand12_counts("all", "")$data,
  path=here("output", cohort, "descriptive", "plots", paste0("vaxcounts12.rds")), compress="gz"
)

vars_df %>%
  transmute(
    plot = pmap(lst(var, var_descr), plot_brand1_counts),
    plot = patchwork::align_patches(plot),
    filename = paste0("brandcounts1_",var,".svg"),
    path=here("output", cohort, "descriptive", "plots"),
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
    ggsave),
  )


vars_df %>%
  transmute(
    plot = pmap(lst(var, var_descr), plot_brand12_counts),
    plot = patchwork::align_patches(plot),
    filename = paste0("brandcounts12_",var,".svg"),
    path=here("output", cohort, "descriptive", "plots"),
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
    ggsave),
  )

#
# vars_df %>%
#   transmute(
#     plot = pmap(lst(var, var_descr), plot_event_counts),
#     plot = patchwork::align_patches(plot),
#     filename = paste0("eventcounts_",var,".svg"),
#     path=here("output", cohort, "descr", "plots"),
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
#     path=here("output", cohort, "descr", "plots"),
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

    pt_days_vax = sum(tstop)-sum(pmin(vaxanyday1, tstop, na.rm=TRUE)),
    pt_years_vax = (sum(tstop)-sum(pmin(vaxanyday1, tstop, na.rm=TRUE)))/365.25,

    pt_pct_vax = pt_days_vax / pt_days,

    fup_min = min(tstop),
    fup_q1 = quantile(tstop, 0.25),
    fup_median = median(tstop),
    fup_q3 = quantile(tstop, 0.75),
    max_fup = max(tstop),
  )

write_csv(tab_end_status, here("output", cohort, "descriptive", "tables", "end_status.csv"))
