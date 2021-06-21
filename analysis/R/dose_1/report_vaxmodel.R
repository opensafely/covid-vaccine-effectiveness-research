
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
  outcome <- "death"
  strata_var <- "all"
} else{
  removeobs <- TRUE
  cohort <- args[[1]]
  outcome <- args[[2]]
  strata_var <- args[[3]]
}



# import global vars ----
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)


# Import metadata for outcomes ----
## these are created in data_define_cohorts.R script

metadata_outcomes <- read_rds(here::here("output", "metadata", "metadata_outcomes.rds"))


### import outcomes, exposures, and covariate formulae ----
## these are created in data_define_cohorts.R script

list_formula <- read_rds(here::here("output", "metadata", "list_formula.rds"))
list2env(list_formula, globalenv())

formula_1 <- outcome ~ 1
formula_remove_strata_var <- as.formula(paste0(". ~ . - ",strata_var))


strata <- read_rds(here::here("output", "metadata", "list_strata.rds"))[[strata_var]]
summary_list <- vector("list", length(strata))
names(summary_list) <- strata



forest_from_broomstack <- function(broomstack, title){

  #jtools::plot_summs(ipwvaxany1)
  #modelsummary::modelplot(ipwvaxany1, coef_omit = 'Interc|tstop', conf.type="wald", exponentiate=TRUE)
  #sjPlot::plot_model(ipwvaxany1)
  #all these methods use broom::tidy to get the coefficients. but tidy.glm only uses profile CIs, not Wald. (yTHO??)
  #profile CIs will take forever on large datasets.
  #so need to write custom function for plotting wald CIs. grr


  plot_data <- broomstack %>%
    filter(
      !str_detect(variable,fixed("ns(tstop")),
      !str_detect(variable,fixed("region")),
      !is.na(term)
    ) %>%
    mutate(
      var_label = if_else(var_class=="integer", "", var_label),
      label = if_else(reference_row %in% TRUE, paste0(label, " (ref)"),label),
      or = if_else(reference_row %in% TRUE, 1, or),
      variable = fct_inorder(variable),
      variable_card = as.numeric(variable)%%2,
    ) %>%
    group_by(variable) %>%
    mutate(
      variable_card = if_else(row_number()!=1, 0, variable_card),
      level = fct_rev(fct_inorder(paste(variable, label, sep="__"))),
      level_label = label
    ) %>%
    ungroup() %>%
    droplevels()

  var_lookup <- str_wrap(plot_data$var_label, 20)
  names(var_lookup) <- plot_data$variable

  level_lookup <- plot_data$level
  names(level_lookup) <- plot_data$level_label

  ggplot(plot_data) +
    geom_point(aes(x=or, y=level)) +
    geom_linerange(aes(xmin=or.ll, xmax=or.ul, y=level)) +
    geom_vline(aes(xintercept=1), colour='black', alpha=0.8)+
    facet_grid(
      rows=vars(variable),
      cols=vars(brand_descr),
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



broomstack <-
  tibble(
    brand = c("any", "pfizer", "az"),
    brand_descr = c("Any vaccine", "BNT162b2", "ChAdOx1")
  ) %>%
  mutate(
    brand = fct_inorder(brand),
    brand_descr = fct_inorder(brand_descr),
    broom = map(brand, ~read_rds(here::here("output", cohort, outcome, .x, strata_var, "all", glue::glue("broom_vax{.x}1.rds"))))
  ) %>%
  unnest(broom)


broomstack_formatted <- broomstack %>%
  transmute(
    brand_descr,
    var_label,
    label,
    HR = scales::label_number(accuracy = .01, trim=TRUE)(or),
    HR = if_else(is.na(HR), "1", HR),
    CI = paste0("(", scales::label_number(accuracy = .01, trim=TRUE)(or.ll), "-", scales::label_number(accuracy = .01, trim=TRUE)(or.ul), ")"),
    CI = if_else(is.na(HR), "", CI),

    HR_ECI = paste0(HR, " ", CI)
  )


broomstack_formatted_wide <- broomstack_formatted %>%
  select(
    brand_descr, var_label, label, HR_ECI
  ) %>%
  pivot_wider(
    id_cols = c(var_label, label),
    names_from = brand_descr,
    values_from = HR_ECI,
    names_glue = "{brand_descr}_{.value}"
  )

write_csv(broomstack_formatted, here::here("output", cohort, "tab_vax1.csv"))
write_csv(broomstack_formatted_wide, here::here("output", cohort, "tab_vax1_wide.csv"))

plot_vax <- forest_from_broomstack(broomstack, "Vaccination model")
ggsave(
  here::here("output", cohort, "plot_vax1.svg"),
  plot_vax,
  units="cm", width=30, height=25
)




#
# gt_vax_merge <- tbl_merge(
#   gts$gt,
#   tab_spanner = gts$brand_descr
# )
# gtsave(gt_vax_merge %>% as_gt(), here::here("output", cohort, "tab_vax1.html"))
