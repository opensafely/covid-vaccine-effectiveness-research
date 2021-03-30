
# # # # # # # # # # # # # # # # # # # # #
# This script:
# takes a cohort name as defined in data_define_cohorts.R, and imported as an Arg
# creates descriptive outputs on patient characteristics by vaccination status at 0, 28, and 56 days.
#
# The script should be run via an action in the project.yaml
# The script must be accompanied by one argument,
# 1. the name of the cohort defined in data_define_cohorts.R
# # # # # # # # # # # # # # # # # # # # #


# Custom functions ----

## Function to extract total plot height minus panel height
plotHeight <- function(plot, unit){
  grob <- ggplot2::ggplotGrob(plot)
  grid::convertHeight(gtable::gtable_height(grob), unitTo=unit, valueOnly=TRUE)
}

## Function to extract total plot width minus panel height
plotWidth <- function(plot, unit){
  grob <- ggplot2::ggplotGrob(plot)
  grid::convertWidth(gtable::gtable_width(grob), unitTo=unit, valueOnly=TRUE)
}

## Function to extract total number of bars plot (strictly this is the number of rows in the build of the plot data)
plotNbars <- function(plot){
  length(unique(ggplot2::ggplot_build(plot)$data[[1]]$x))
}

## Function to extract total number of bars plot (strictly this is the number of rows in the build of the plot data)
plotNfacetrows <- function(plot){
  length(levels(ggplot2::ggplot_build(plot)$data[[1]]$PANEL))
}

##
plotNyscales <- function(plot){
  length(ggplot2::ggplot_build(plot)$layout$panel_scales_y[[1]]$range$range)
}

## Function to extract total number of panels
plotNpanelrows <- function(plot){
  length(unique(ggplot2::ggplot_build(plot)$layout$layout$ROW))
}



# Preliminaries ----

## Import libraries
library('tidyverse')
library('lubridate')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))

## Import command-line arguments
args <- commandArgs(trailingOnly=TRUE)

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"
} else {
  # use for actions
  cohort <- args[[1]]
}

## Import global vars
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
#list2env(gbl_vars, globalenv())

## Create output directories ----
dir.create(here::here("output", cohort, "descr", "plots"), showWarnings = FALSE, recursive=TRUE)

## Define plot theme ----
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


# Import data ---

## Processed data
data_fixed <- read_rds(here::here("output", cohort, "data", glue::glue("data_wide_fixed.rds")))
data_pt <- read_rds(here::here("output", cohort, "data", glue::glue("data_pt.rds")))

## Metadata for cohort
metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))
metadata_cohorts <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort, ]

list2env(metadata_cohorts, globalenv())


# Format data for plots ----

## Data for plotting - filter censored
data_pt <- data_pt %>%
  left_join(data_fixed, by = "patient_id") %>%
  filter(censored_status==0)

## Format data
data_by_day <-
  data_pt %>%
  transmute(
    patient_id,
    all = "all",
    sex,
    imd,
    ethnicity,
    region,
    ageband = cut(
      age,
      breaks=c(-Inf, 70, 75, 80, 85, 90, 95, Inf),
      labels=c("under 70", "70-74", "75-79", "80-84", "85-89", "90-94", "95+"),
      right=FALSE
    ),
    postest_status,
    day = tstop-1,
    date = as.Date(gbl_vars$start_date) + day,
    week = lubridate::floor_date(date, unit="week", week_start=1), #week commencing monday (since index date is a monday)
    date = week,
    vaxany_status_onedose = vaxany_status!=0,
    vaxany_status=fct_case_when(
      vaxany_status==0 ~ "Not vaccinated",
      vaxany_status==1 ~ "One dose",
      vaxany_status==2 ~ "Two doses",
      TRUE ~ NA_character_
    ),

    death,
    noncoviddeath=death & !coviddeath,
    coviddeath,
    covidadmitted,
    postest,

    death_status,
    noncoviddeath_status=death_status & !coviddeath_status,
    coviddeath_status,
    covidadmitted_status,
    postest_status,

    outcome_status = fct_case_when(
      noncoviddeath_status==1 ~ "Non-covid death",
      coviddeath_status==1 ~ "Covid-related death",
      covidadmitted_status==1 ~ "Covid-related admission",
      postest_status==1 ~ "Positive test",
      TRUE ~ "No events"
    ) %>% fct_rev()
  ) %>%
  group_by(patient_id) %>%
  mutate(
    lag_vaxany_status_onedose = lag(vaxany_status_onedose, 14, 0),
     lag_vaxany_status_onedose = fct_case_when(
       lag_vaxany_status_onedose==0 ~ "No vaccine or\n< 14 days post-vaccine",
       lag_vaxany_status_onedose==1 ~ ">= 14 days post-vaccine",
       TRUE ~ NA_character_
    )
  ) %>% ungroup()



# Functions to create plots ----

## Cumulative vaccination status plot
plot_vax_counts <- function(var, var_descr){
  data1 <- data_by_day %>%
    mutate(
      variable = data_by_day[[var]]
    ) %>%
    group_by(date, variable, vaxany_status) %>%
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
    scale_fill_manual(values=c("#d95f02", "#7570b3", "#1b9e77"))+
    labs(
      x=NULL,
      y="Status per 10,000 patients",
      colour=NULL,
      fill=NULL,
      title = "Vaccination status over time",
      subtitle = var_descr
    ) +
    plot_theme+
    theme(legend.position = "bottom")

  plot
}


## Cumulative event status plot
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
      y="Events per 10,000 patients",
      fill=NULL,
      title = "Outcome status over time",
      subtitle = var_descr
    ) +
    plot_theme+
    theme(legend.position = "bottom")+
    guides(fill = guide_legend(nrow = 2))

  plot
}

## Event rates plot
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
        labels=c("Positive test", "Covid-related admission", "Covid-releated death", "Any death"))
    )

  plot <- data1 %>%
    ggplot() +
    geom_line(aes(x=date, y=rate, group=outcome, colour=outcome))+
    facet_grid(rows=vars(variable), cols=vars(lag_vaxany_status_onedose))+
    scale_x_date(date_breaks = "1 week", labels = scales::date_format("%m-%d"))+
    scale_color_brewer(palette="Dark2")+
    labs(
      x=NULL,
      y="Event rate per week per 10,000 patients",
      colour=NULL,
      title = "Outcome rates over time",
      subtitle = var_descr
    ) +
    plot_theme+
    guides(colour = guide_legend(nrow = 2))+
    theme(legend.position = "bottom")

  plot

}



# Create plots ----

## List of variables to plot
vars_df <- tribble(
  ~var, ~var_descr,
  "all", "",
  "sex", "Sex",
  "imd", "IMD",
  "ageband", "Age",
  "ethnicity", "Ethnicity",
  "region", "Region"
) %>% mutate(
  device="svg",
  units = "cm",
)

## Plot cumulative vaccination status 
vars_df %>%
transmute(
  plot = pmap(lst(var, var_descr), plot_vax_counts),
  plot = patchwork::align_patches(plot),
  filename = paste0("vaxcounts_",var,".svg"),
  path=here::here("output", cohort, "descr", "plots"),
  panelwidth = 10,
  panelheight = 5,
  #width = pmap_dbl(list(plot, units, panelwidth), function(plot, units, panelwidth){plotWidth(plot, units) + panelwidth}),
  units="cm",
  width = 20,
  height = pmap_dbl(list(plot, units, panelheight), function(plot, units, panelheight){plotHeight(plot, units) + plotNpanelrows(plot)*panelheight}),
) %>%
mutate(
  pmap(list(
      filename=filename,
      plot=plot,
      path=path,
      width=width, height=height, units=units, limitsize=FALSE, scale=0.7
    ),
    ggsave)
  )

## Plot cumulative event status plot
vars_df %>%
  transmute(
    plot = pmap(lst(var, var_descr), plot_event_counts),
    plot = patchwork::align_patches(plot),
    filename = paste0("eventcounts_",var,".svg"),
    path=here::here("output", cohort, "descr", "plots"),
    panelwidth = 10,
    panelheight = 5,
    units="cm",
    #width = pmap_dbl(list(plot, units, panelwidth), function(plot, units, panelwidth){plotWidth(plot, units) + panelwidth}),
    width = 20,
    height = pmap_dbl(list(plot, units, panelheight), function(plot, units, panelheight){plotHeight(plot, units) + plotNpanelrows(plot)*panelheight}),
  ) %>%
  mutate(
    pmap(list(
      filename=filename,
      path=path,
      plot=plot,
      width=width, height=height, units=units, limitsize=FALSE, scale=0.7
    ),
    ggsave)
  )


## Plot event rates
vars_df %>%
  transmute(
    plot = pmap(lst(var, var_descr), plot_event_rates),
    plot = patchwork::align_patches(plot),
    filename = paste0("eventrates_",var,".svg"),
    path=here::here("output", cohort, "descr", "plots"),
    panelwidth = 10,
    panelheight = 5,
    units="cm",
    #width = pmap_dbl(list(plot, units, panelwidth), function(plot, units, panelwidth){plotWidth(plot, units) + panelwidth}),
    width = 20,
    height = pmap_dbl(list(plot, units, panelheight), function(plot, units, panelheight){plotHeight(plot, units) + plotNpanelrows(plot)*panelheight}),
  ) %>%
  mutate(
    pmap(list(
      filename=filename,
      path=path,
      plot=plot,
      width=width, height=height, units=units, limitsize=FALSE, scale=0.7
    ),
    ggsave)
  )

