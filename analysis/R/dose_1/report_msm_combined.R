
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

##  Create big loop over all categories

strata <- read_rds(here("output", "metadata", "list_strata.rds"))[[strata_var]]
summary_list <- vector("list", length(strata))
names(summary_list) <- strata

# import models ----

estimates <-
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
    #outcome_descr = fct_inorder(stringi::stri_wrap(outcome_descr, width=12L, whitespace_only = TRUE)),
    outcome_descr = fct_inorder(map_chr(outcome_descr, ~paste(stringi::stri_wrap(., width=14, simplify=TRUE, whitespace_only=TRUE), collapse="\n")))
  ) %>%
  crossing(
    tibble(
      brand = c("any", "pfizer", "az"),
      brand_descr = c("Any vaccine", "BNT162b2", "ChAdOx1")
    ) %>%
    mutate(
      brand = fct_inorder(brand),
      brand_descr = fct_inorder(brand_descr)
    )
  ) %>%
  add_column(
    stratum = list(strata),
    .before=1
  ) %>%
  unnest(stratum) %>% arrange(stratum) %>%
  mutate(
    brand = fct_inorder(brand),
    brand_descr = fct_inorder(brand_descr),
    estimates = map2(brand, outcome, ~read_csv(here("output", cohort, strata_var, .x, .y, glue("estimates_timesincevax.csv"))))
  ) %>%
  unnest(estimates) %>%
  mutate(
    model_descr = fct_inorder(model_descr),
  )



estimates_formatted <- estimates %>%
  transmute(
    outcome_descr,
    brand_descr,
    strata,
    model,
    model_descr,
    term=str_replace(term, pattern="timesincevax\\_pw", ""),
    HR =scales::label_number(accuracy = .01, trim=TRUE)(or),
    HR_CI = paste0("(", scales::label_number(accuracy = .01, trim=TRUE)(or.ll), "-", scales::label_number(accuracy = .01, trim=TRUE)(or.ul), ")"),
    VE = scales::label_number(accuracy = .1, trim=FALSE, scale=100)(ve),
    VE_CI = paste0("(", scales::label_number(accuracy = .1, trim=TRUE, scale=100)(ve.ll), "-", scales::label_number(accuracy = .1, trim=TRUE, scale=100)(ve.ul), ")"),

    HR_ECI = paste0(HR, " ", HR_CI),
    VE_ECI = paste0(VE, " ", VE_CI),
  )

estimates_formatted_wide <- estimates_formatted %>%
  select(outcome_descr, brand_descr, strata, model, term, HR_ECI, VE_ECI) %>%
  pivot_wider(
    id_cols=c(outcome_descr, brand_descr, term, strata),
    names_from = model,
    values_from = c(HR_ECI, VE_ECI),
    names_glue = "{model}_{.value}"
  )

write_csv(estimates, path = here("output", cohort, strata_var, "combined", glue("estimates_timesincevax.csv")))
write_csv(estimates_formatted, path = here("output", cohort, strata_var, "combined", glue("estimates_formatted_timesincevax.csv")))
write_csv(estimates_formatted_wide, path = here("output", cohort, strata_var, "combined", glue("estimates_formatted_wide_timesincevax.csv")))



formatpercent100 <- function(x,accuracy){
  formatx <- scales::label_percent(accuracy)(x)

  if(formatx==scales::label_percent(accuracy)(1)){
    paste0(">",scales::label_percent(1)((100-accuracy)/100))
  } else{
    formatx
  }
}

formatpercent100(0.996,1)

# create forest plot
msmmod_effect_data <- estimates %>%
  filter(
    !(outcome %in% c("death") )
  ) %>%
  mutate(
    term=str_replace(term, pattern="timesincevax\\_pw", ""),
    term=fct_inorder(term),
    term_left = as.numeric(str_extract(term, "\\d+"))-1,
    term_right = as.numeric(str_extract(term, "\\d+$")),
    term_right = if_else(is.na(term_right), max(term_left)+7, term_right),
    term_midpoint = term_left + (term_right-term_left)/2,
    strata = if_else(strata=="all", "", strata)
  )

msmmod_effect <-
  ggplot(data = msmmod_effect_data, aes(colour=model_descr)) +
  geom_hline(aes(yintercept=1), colour='grey')+
  geom_point(aes(y=or, x=term_midpoint), position = position_dodge(width = 1.5), size=0.8)+
  geom_linerange(aes(ymin=or.ll, ymax=or.ul, x=term_midpoint), position = position_dodge(width = 1.5))+
  facet_grid(rows=vars(outcome_descr), cols=vars(brand_descr), switch="y")+
  scale_y_log10(
    breaks = c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5),
    limits = c(0.009, max(c(1, msmmod_effect_data$or.ul))),
    oob = scales::oob_keep,
    sec.axis = sec_axis(
      ~(1-.),
      name="Effectiveness",
      breaks = c(-4, -1, 0, 0.5, 0.80, 0.9, 0.95, 0.98, 0.99),
      labels = function(x){formatpercent100(x, 1)}
    )
  )+
  scale_x_continuous(breaks=unique(msmmod_effect_data$term_left))+
  scale_colour_brewer(type="qual", palette="Set2", guide=guide_legend(ncol=1))+
  coord_cartesian() +
  labs(
    y="Hazard ratio, versus no vaccination",
    x="Days since first dose",
    colour=NULL#,
    #title=glue("Outcomes by time since first {brand} vaccine"),
    #subtitle=cohort_descr
  ) +
  theme_bw(base_size=12)+
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

    legend.position = "bottom"
  )

## save plot
ggsave(filename=here("output", cohort, strata_var, "combined", glue("VE_plot.svg")), msmmod_effect, width=20, height=20, units="cm")
ggsave(filename=here("output", cohort, strata_var, "combined", glue("VE_plot.png")), msmmod_effect, width=20, height=20, units="cm")


log(scales::breaks_log(n=6, base=10)(c(min((msmmod_effect_data$or.ll)), max((msmmod_effect_data$or.ul)))))


msmmod_effect_free <-
  ggplot(data = msmmod_effect_data, aes(colour=model_descr)) +
  geom_hline(aes(yintercept=0), colour='grey')+
  geom_point(aes(y=log(or), x=term_midpoint), position = position_dodge(width = 1.5), size=0.8)+
  geom_linerange(aes(ymin=log(or.ll), ymax=log(or.ul), x=term_midpoint), position = position_dodge(width = 1.5))+
  facet_grid(rows=vars(outcome_descr), cols=vars(brand_descr), switch="y", scales="free_y")+
  scale_y_continuous(
    labels = function(x){scales::label_number(0.001)(exp(x))},
    breaks = function(x){log(scales::breaks_log(n=6, base=10)(exp(x)))},
    sec.axis = sec_axis(
      ~(1-exp(.)),
      name="Effectiveness",
      breaks = function(x){1-(scales::breaks_log(n=6, base=10)(1-x))},
      labels = function(x){formatpercent100(x, 1)}
    )
  )+
  scale_x_continuous(breaks=unique(msmmod_effect_data$term_left))+
  scale_colour_brewer(type="qual", palette="Set2", guide=guide_legend(ncol=1))+
  labs(
    y="Hazard ratio, versus no vaccination",
    x="Days since first dose",
    colour=NULL#,
    #title=glue("Outcomes by time since first {brand} vaccine"),
    #subtitle=cohort_descr
  ) +
  theme_bw(base_size=12)+
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

    legend.position = "bottom"
  )
msmmod_effect_free

## save plot
ggsave(filename=here("output", cohort, strata_var, "combined", glue("VE_plot_free.svg")), msmmod_effect_free, width=20, height=20, units="cm")
ggsave(filename=here("output", cohort, strata_var, "combined", glue("VE_plot_free.png")), msmmod_effect_free, width=20, height=20, units="cm")


