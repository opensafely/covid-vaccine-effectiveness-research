
# # # # # # # # # # # # # # # # # # # # #
# The script should only be run via an action in the project.yaml only
# The script must be accompanied by two arguments: cohort  and stratum
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')
library('splines')
library('gtsummary')
library('gt')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))
source(here::here("lib", "survival_functions.R"))

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


# Import metadata for cohort ----
## these are created in data_define_cohorts.R script

metadata_cohorts <- read_rds(here::here("output", "data", "metadata_cohorts.rds"))
stopifnot("cohort does not exist" = (cohort %in% metadata_cohorts[["cohort"]]))
metadata_cohorts <- metadata_cohorts[metadata_cohorts[["cohort"]]==cohort, ]

list2env(metadata_cohorts, globalenv())

# Import metadata for outcomes ----
## these are created in data_define_cohorts.R script

metadata_outcomes <- read_rds(here::here("output", "data", "metadata_outcomes.rds"))


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "data", "list_formula.rds"))
list2env(list_formula, globalenv())

formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))


strata <- read_rds(here::here("output", "data", "list_strata.rds"))[[strata_var]]
summary_list <- vector("list", length(strata))
names(summary_list) <- strata



forest_from_gtstack <- function(gt_stack_obj, title){

  #jtools::plot_summs(ipwvaxany1)
  #modelsummary::modelplot(ipwvaxany1, coef_omit = 'Interc|tstop', conf.type="wald", exponentiate=TRUE)
  #sjPlot::plot_model(ipwvaxany1)
  #all these methods use broom::tidy to get the coefficients. but tidy.glm only uses profile CIs, not Wald. (yTHO??)
  #profile CIs will take forever on large datasets.
  #so need to write custom function for plotting wald CIs. grr


  plot_data <- gt_stack_obj %>%
    as_gt() %>%
    .$`_data` %>%
    filter(
      !str_detect(variable,fixed("ns(tstop")),
      !str_detect(variable,fixed("region")),
      !is.na(term)
    ) %>%
    mutate(
      var_label = if_else(row_type=="label", "", var_label),
      label = if_else(reference_row %in% TRUE, paste0(label, " (ref)"),label),
      or = if_else(reference_row %in% TRUE, 1, or),
      variable = fct_inorder(variable),
      variable_card = as.numeric(variable)%%2,
    ) %>%
    group_by(variable, groupname_col) %>%
    mutate(
      variable_card = if_else(row_number()!=1, 0, variable_card),
      level = fct_rev(fct_inorder(paste(variable, label, sep="__"))),
      level_label = label,
      variable = factor(str_wrap(variable, width=20), levels=str_wrap(levels(variable), width=20))
    ) %>%
    ungroup() %>%
    droplevels()

  var_lookup <- plot_data$var_label
  names(var_lookup) <- plot_data$variable

  level_lookup <- plot_data$level
  names(level_lookup) <- plot_data$level_label

  ggplot(plot_data) +
    geom_point(aes(x=or, y=level)) +
    geom_linerange(aes(xmin=or.ll, xmax=or.ul, y=level)) +
    geom_vline(aes(xintercept=1), colour='black', alpha=0.8)+
    facet_grid(
      rows=vars(variable),
      cols=vars(groupname_col),
      scales="free_y", switch="y", space="free_y", labeller = labeller(variable = var_lookup)
    )+
    scale_x_log10(
      breaks=c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5),
      limits=c(0.01,3)
    )+
    scale_y_discrete(breaks=level_lookup, labels=names(level_lookup))+
    geom_rect(aes(alpha = variable_card), xmin = -Inf,xmax = Inf, ymin = -Inf, ymax = Inf, fill='grey', colour="transparent") +
    scale_alpha_continuous(range=c(0,0.3), guide=FALSE)+
    labs(
      y="",
      x="Hazard ratio",
      colour=NULL,
      title=title
      #subtitle=cohort_descr
    ) +
    theme_minimal() +
    theme(
      strip.placement = "outside",
      strip.background = element_rect(fill="transparent", colour="transparent"),
      strip.text.y.left = element_text(angle = 0, hjust=1),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.spacing = unit(0, "lines")
    )
}


gts <-
  tibble(
    brand = c("any", "pfizer", "az"),
    brand_descr = c("Any vaccine", "BNT162b2", "ChAdOx1")
  ) %>%
  mutate(
    brand = fct_inorder(brand),
    brand_descr = fct_inorder(brand_descr),
    gt = map(brand, ~read_rds(here::here("output", cohort, "death", .x, strata_var, "all", glue::glue("gt_vax{.x}1.rds"))))
  )


gt_vax_stack <- tbl_stack(
  gts$gt,
  group_header = str_wrap(gts$brand_descr, width=30)
)

plot_vax <- forest_from_gtstack(gt_vax_stack, "Vaccination model")
ggsave(
  here::here("output", cohort, "plot_vax1.svg"),
  plot_vax,
  units="cm", width=30, height=25
)

gt_vax_merge <- tbl_merge(
  gts$gt,
  tab_spanner = gts$brand_descr
)
gtsave(gt_vax_merge %>% as_gt(), here::here("output", cohort, "tab_vax1.html"))
