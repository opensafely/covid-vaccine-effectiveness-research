
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports fitted MSMs from both over80s and in70s cohorts
# meta-analyses them using inverse-variance weights
# only works for "all" strata
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('lubridate')
library('survival')
library('splines')
library('parglm')
library('gtsummary')
library("sandwich")
library("lmtest")

## Import custom user functions from lib
source(here("lib", "utility_functions.R"))
source(here("lib", "redaction_functions.R"))
source(here("lib", "survival_functions.R"))


fs::dir_create(here("output", "combined"))

# import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)

# Import metadata for outcome ----
metadata_outcomes <- read_rds(here("output", "metadata", "metadata_outcomes.rds"))

### import outcomes, exposures, and covariate formulae ----

params <-
  crossing(
    brand = nesting(
      brand = fct_inorder(c("any", "pfizer", "az")),
      brand_descr = fct_inorder(c("Any vaccine", "BNT162b2", "ChAdOx1"))
    ),
    cohort = tibble(
      cohort = fct_inorder(c("over80s", "in70s")),
      cohort_descr = fct_inorder(c("Over 80s", "70-79s")),
    ),
    outcome = fct_inorder(c(
      "postest",
      "covidadmitted",
      #"coviddeath",
      #"noncoviddeath",
      "death"
    )),
    recent_postestperiod = c(0),
  ) %>%
  unpack(c(cohort, brand)) %>%
  filter(
    !(recent_postestperiod == 0 & outcome %in% c("coviddeath", "noncoviddeath")),
    #!(recent_postestperiod == Inf & outcome %in% c("postest")),
    brand != "any",
  )

estimates <- params %>%
  left_join(metadata_outcomes, by=c("outcome")) %>%
  mutate(
    outcome = fct_inorder(outcome),
    outcome_descr = fct_inorder(map_chr(outcome_descr, ~paste(stringi::stri_wrap(., width=14, simplify=TRUE, whitespace_only=TRUE), collapse="\n")))
  ) %>%
  mutate(
    estimates = pmap(list(cohort, recent_postestperiod, brand, outcome), ~read_csv(here("output", ..1, "all", ..2, ..3, ..4, glue("stcoxestimates_timesincevax.csv"))))
    #estimates = pmap(list(brand, outcome), ~read_csv(here("output", "over80s", "all", "0", "pfizer", "postest", glue("estimates_timesincevax.csv"))))
  ) %>%
  unnest(estimates) %>%
  mutate(
    model_descr = fct_inorder(model_descr),
    term = fct_inorder(term)
  )

meta_estimates <-
  estimates %>%
  group_by(
    outcome, outcome_descr,
    brand, brand_descr,
    recent_postestperiod,
    model, model_descr, model_descr_wrap,
    term, term_left, term_right, term_midpoint,
  ) %>%
  summarise(
    estimate = weighted.mean(estimate, std.error^-2),
    std.error = sqrt(1/sum(std.error^-2)),
    statistic = estimate/std.error,
    p.value = 2 * pmin(pnorm(statistic), pnorm(-statistic)),
    conf.low = estimate + qnorm(0.025)*std.error,
    conf.high = estimate + qnorm(0.975)*std.error,

    or = exp(estimate),
    or.ll = exp(conf.low),
    or.ul = exp(conf.high),

    ve = 1-or,
    ve.ll = 1-or.ul,
    ve.ul = 1-or.ll,

    HR =scales::label_number(accuracy = .01, trim=TRUE)(or),
    HR_CI = paste0("(", scales::label_number(accuracy = .01, trim=TRUE)(or.ll), "-", scales::label_number(accuracy = .01, trim=TRUE)(or.ul), ")"),
    VE = scales::label_number(accuracy = .1, trim=FALSE, scale=100)(ve),
    VE_CI = paste0("(", scales::label_number(accuracy = .1, trim=TRUE, scale=100)(ve.ll), "-", scales::label_number(accuracy = .1, trim=TRUE, scale=100)(ve.ul), ")"),

    HR_ECI = paste0(HR, " ", HR_CI),
    VE_ECI = paste0(VE, " ", VE_CI),
  )


meta_estimates_wide <- meta_estimates %>%
  select(recent_postestperiod, outcome_descr, brand_descr, model, term, HR_ECI, VE_ECI) %>%
  pivot_wider(
    id_cols=c(recent_postestperiod, outcome_descr, brand_descr, term),
    names_from = model,
    values_from = c(HR_ECI, VE_ECI),
    names_glue = "{model}_{.value}"
  )
write_csv(meta_estimates, path = here("output", "combined", glue("stcoxmeta_estimates.csv")))
write_csv(meta_estimates_wide, path = here("output", "combined", glue("stcoxmeta_estimates_wide.csv")))


formatpercent100 <- function(x,accuracy){
  formatx <- scales::label_percent(accuracy)(x)

  if_else(
    formatx==scales::label_percent(accuracy)(1),
    paste0(">",scales::label_percent(1)((100-accuracy)/100)),
    formatx
  )
}

# create forest plot
msmmod_effect_data <- meta_estimates %>%
  rowwise() %>%
  mutate(
    term=str_replace(term, pattern="timesincevax\\_pw", ""),
    term=fct_inorder(term),
    term_left = as.numeric(str_extract(term, "\\d+"))-1,
    term_right = as.numeric(str_extract(term, "\\d+$")),
    maxend = as.numeric(as.Date(gbl_vars$end_date) - as.Date(gbl_vars[[glue("start_date_over80s")]]))+1,
    term_right = if_else(is.na(term_right), 56, term_right),
    term_midpoint = (term_left + term_right)/2,
    #stratum = if_else(stratum=="all", "", stratum)
  ) %>%
  ungroup()


msmmod_effect_data_plot <- msmmod_effect_data %>%
  filter(
    or !=Inf, or !=0
  )


makeplot <- function(recent_postestperiod){
  recent_postestperiodd<-recent_postestperiod

  msmmod_effect <-
    msmmod_effect_data_plot %>%
    filter(recent_postestperiod==recent_postestperiodd) %>%
    ggplot(aes(colour=model_descr)) +
    geom_hline(aes(yintercept=1), colour='black')+
    geom_vline(aes(xintercept=0), colour='black')+
    geom_point(aes(y=or, x=term_midpoint), position = position_dodge(width = 2), size=0.8)+
    geom_linerange(aes(ymin=or.ll, ymax=or.ul, x=term_midpoint), position = position_dodge(width = 2))+
    facet_grid(rows=vars(outcome_descr), cols=vars(brand_descr), switch="y")+
    scale_y_log10(
      breaks = c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5),
      limits = c(0.05, max(c(1, msmmod_effect_data_plot$or.ul))),
      oob = scales::oob_keep,
      sec.axis = sec_axis(
        ~(1-.),
        name="Effectiveness",
        breaks = c(-4, -1, 0, 0.5, 0.80, 0.9, 0.95, 0.98, 0.99),
        labels = function(x){formatpercent100(x, 1)}
      )
    )+
    scale_x_continuous(
      breaks=unique(c(msmmod_effect_data_plot$term_left, max(msmmod_effect_data_plot$term_midpoint)+7)),
      labels=c(unique(msmmod_effect_data_plot$term_left), paste0("<",max(msmmod_effect_data_plot$maxend))),
      expand=expansion(mult=c(0), add=c(0,7)), limits=c(0,NA)
    )+
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

  msmmod_effect
  ## save plot
  ggsave(filename=here("output", "combined", glue("stcoxVE_plot_metaanalysis_{recent_postestperiod}.svg")), msmmod_effect, width=18, height=20, units="cm")
  ggsave(filename=here("output", "combined", glue("stcoxVE_plot_metaanalysis_{recent_postestperiod}.png")), msmmod_effect, width=18, height=20, units="cm")


  msmmod_effect_free <-
    msmmod_effect_data_plot %>%
    filter(recent_postestperiod==recent_postestperiodd) %>%
    ggplot(aes(colour=model_descr)) +
    geom_hline(aes(yintercept=0), colour='black')+
    geom_vline(aes(xintercept=0), colour='black')+
    geom_point(aes(y=log(or), x=term_midpoint), position = position_dodge(width = 2), size=0.8)+
    geom_linerange(aes(ymin=log(or.ll), ymax=log(or.ul), x=term_midpoint), position = position_dodge(width = 2))+
    facet_grid(rows=vars(outcome_descr), cols=vars(brand_descr), switch="y")+
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
    scale_x_continuous(
      breaks=unique(c(msmmod_effect_data_plot$term_left, max(msmmod_effect_data_plot$term_midpoint)+7)),
      labels=c(unique(msmmod_effect_data_plot$term_left), paste0("<",max(msmmod_effect_data_plot$maxend))),
      expand=expansion(mult=c(0), add=c(0,7)), limits=c(0,NA)
    )+
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
  ggsave(filename=here("output", "combined", glue("stcoxVE_plot_metaanalysis_free_{recent_postestperiod}.svg")), msmmod_effect_free, width=18, height=20, units="cm")
  ggsave(filename=here("output", "combined", glue("stcoxVE_plot_metaanalysis_free_{recent_postestperiod}.png")), msmmod_effect_free, width=18, height=20, units="cm")

}

#makeplot(Inf)
makeplot(0)
