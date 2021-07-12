
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports reported MSM estimates for ALL outcomes
# calculates robust CIs taking into account patient-level clustering
# outputs forest plots for the primary vaccine-outcome relationship
# outputs plots showing model-estimated spatio-temporal trends
#
# The script should only be run via an action in the project.yaml only
# The script must be accompanied by four arguments: cohort and stratum
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('glue')
library('here')
library('lubridate')
library('survival')
library('splines')
library('parglm')
library('gtsummary')
library("sandwich")
library("lmtest")
library('gt')

## Import custom user functions from lib
source(here("lib", "utility_functions.R"))
source(here("lib", "redaction_functions.R"))
source(here("lib", "survival_functions.R"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)



if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"
  strata_var <- "all"
} else{
  removeobs <- TRUE
  cohort <- args[[1]]
  strata_var <- args[[2]]
}



# import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)

# Import metadata for outcomes ----
## these are created in data_define_cohorts.R script

metadata_outcomes <- read_rds(here("output", "metadata", "metadata_outcomes.rds"))


fs::dir_create(here("output", cohort, strata_var, "combined"))

strata <- read_rds(here("output", "metadata", "list_strata.rds"))[[strata_var]]
summary_list <- vector("list", length(strata))
names(summary_list) <- strata

# import models ----


curves <-
  metadata_outcomes %>%
  filter(outcome %in% c(
    "postest",
    "covidadmitted",
    "coviddeath",
    "noncoviddeath",
    NULL
  )) %>%
  mutate(
    outcome = fct_inorder(outcome),
    outcome_descr = fct_inorder(outcome_descr),
  ) %>%
  crossing(
    tibble(
      brand = c("any", "pfizer", "az"),
      brand_descr = c("Any vaccine", "BNT162b2", "ChAdOx1")
    ) %>%
    mutate(
      brand = fct_inorder(brand),
      brand_descr = fct_inorder(brand_descr),
    )
  ) %>%
  mutate(
    curves = map2(brand, outcome, ~read_rds(here("output", cohort, strata_var, .x, .y, glue("data_incidence.rds"))))
  ) %>%
  unnest(curves) %>%
  mutate(
    stratum=fct_inorder(stratum),
    paired = factor(
      paste0(vax_status,", ",stratum),
      levels= map_chr(
        cross2(c("Unvaccinated", "Vaccinated"), levels(stratum)),
        ~paste(., sep = ":", collapse = ", ")
      )
    ),
   paired=factor(str_remove(paired, "\\, all$"), levels=c("Unvaccinated", "Vaccinated"))
  )

cml_inc <- ggplot(curves)+
  geom_step(aes(x=date, y=1-survival4, group=paired, alpha=vax_status, colour=stratum))+
  facet_grid(rows=vars(outcome_descr), cols=vars(brand_descr), switch="y")+
  scale_x_date(
    breaks = seq(min(curves$date),max(curves$date)+1,by=14),
    limits = c(lubridate::floor_date((min(curves$date)), "1 month"), NA),
    labels = scales::date_format("%d/%m"),
    expand = expansion(0),
    sec.axis = sec_axis(
      trans = ~as.Date(.),
      breaks=as.Date(seq(floor_date(min(curves$date), "month"), ceiling_date(max(curves$date), "month"),by="month")),
      labels = scales::date_format("%b %y")
    )
  )+
  scale_alpha_discrete(range=c(0.4,1), breaks=c("Unvaccinated", "Vaccinated"), limits=c("Unvaccinated", "Vaccinated"))+
  scale_colour_brewer(type="qual", palette="Set2")+
  labs(
    x="Date",
    y="Cumulative risk",
    colour=NULL,
    alpha=NULL
  ) +
  theme_bw()+
  theme(
    panel.border = element_blank(),
    axis.line.y = element_line(colour = "black"),

    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    strip.background = element_blank(),
    strip.placement = "outside",
    #strip.text.y.left = element_text(angle = 0),

    panel.spacing = unit(1, "lines"),

    plot.title = element_text(hjust = 0),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0, face= "italic"),

    legend.position="bottom",
    axis.text.x.top=element_text(hjust=0)
  )
cml_inc

ggsave(filename=here("output", cohort, strata_var, "combined", glue("cml_incidence_plot.svg")), cml_inc, width=20, height=15, units="cm")
ggsave(filename=here("output", cohort, strata_var, "combined", glue("cml_incidence_plot.png")), cml_inc, width=20, height=15, units="cm")



cml_inc_pair <- ggplot(curves)+
  geom_hline(aes(yintercept=0), colour='black') +
  geom_step(aes(x=date, y=1-survival4, group=paired, colour=paired))+
  facet_grid(rows=vars(outcome_descr), cols=vars(brand_descr), switch="y", scales="free_y")+
  scale_x_date(
    breaks = seq(min(curves$date),max(curves$date)+27,by=28),
    limits = c(lubridate::floor_date((min(curves$date)), "1 month"), NA),
    labels = scales::date_format("%d/%m"),
    expand = expansion(0),
    sec.axis = sec_axis(
      trans = ~as.Date(.),
      breaks=as.Date(seq(floor_date(min(curves$date), "month"), ceiling_date(max(curves$date), "month"),by="month")),
      labels = scales::date_format("%b %y")
    )
  )+
  scale_y_continuous(limits=c(0,NA), expand=expansion(c(0,NA)),  breaks=seq(0,0.5,0.02))+
  scale_colour_brewer(type="qual", palette="Paired", guide=guide_legend(ncol=2))+
  labs(
    x="Date",
    y="Cumulative risk",
    colour=NULL,
    alpha=NULL
  ) +
  theme_bw(base_size = 11)+
  theme(
    panel.border = element_blank(),
    #axis.line.x = element_line(colour = "black"),
    #axis.line.y = element_line(colour = "black"),

    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    strip.background = element_blank(),
    strip.placement = "outside",
    #strip.text.y.left = element_text(angle = 0),

    panel.spacing = unit(1, "lines"),

    plot.title = element_text(hjust = 0),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0, face= "italic"),

    legend.position="bottom",
    axis.text.x.top=element_text(hjust=0)
  )
cml_inc_pair

ggsave(filename=here("output", cohort, strata_var, "combined", glue("cml_incidence_plot_pair.svg")), cml_inc_pair, width=20, height=20, units="cm")
ggsave(filename=here("output", cohort, strata_var, "combined", glue("cml_incidence_plot_pair.png")), cml_inc_pair, width=20, height=20, units="cm")

