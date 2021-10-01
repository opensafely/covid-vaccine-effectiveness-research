library('tidyverse')
library('yaml')
library('here')
library('glue')

# create action functions ----

## generic action function ----
action <- function(
  name,
  run,
  arguments=NULL,
  needs=NULL,
  highly_sensitive=NULL,
  moderately_sensitive=NULL
){

  outputs <- list(
    highly_sensitive = highly_sensitive,
    moderately_sensitive = moderately_sensitive
  )
  outputs[sapply(outputs, is.null)] <- NULL

  action <- list(
    run = paste(c(run, arguments), collapse=" "),
    needs = needs,
    outputs = outputs
  )
  action[sapply(action, is.null)] <- NULL

  action_list <- list(name = action)
  names(action_list) <- name

  action_list
}


## create comment function ----
comment <- function(...){
  list_comments <- list(...)
  comments <- map(list_comments, ~paste0("## ", ., " ##"))
  comments
}


## create function to convert comment "actions" in a yaml string into proper comments
convert_comment_actions <-function(yaml.txt){
  yaml.txt %>%
    str_replace_all("\\\n(\\s*)\\'\\'\\:(\\s*)\\'", "\n\\1")  %>%
    #str_replace_all("\\\n(\\s*)\\'", "\n\\1") %>%
    str_replace_all("([^\\'])\\\n(\\s*)\\#\\#", "\\1\n\n\\2\\#\\#") %>%
    str_replace_all("\\#\\#\\'\\\n", "\n")
}

## actions that extract and process data ----

actions_process <- function(cohort, sample_proc){
  splice(


    action(
      name = glue("extract_{cohort}"),
      run = glue("cohortextractor:latest generate_cohort --study-definition study_definition_{cohort} --output-format feather"),
      highly_sensitive = list(
        cohort = glue("output/input_{cohort}.feather")
      )
    ),

    action(
      name = glue("data_process_{cohort}"),
      run = "r:latest analysis/R/data_process.R",
      arguments = c(cohort),
      needs = list(glue("extract_{cohort}")),
      highly_sensitive = list(
        data = glue("output/{cohort}/data/data_processed.rds"),
        datavaxlong = glue("output/{cohort}/data/data_long_vax_dates.rds"),
        datavaxwide = glue("output/{cohort}/data/data_wide_vax_dates.rds")
      )
    ),

    action(
      name = glue("data_process_long_{cohort}"),
      run = "r:latest analysis/R/data_process_long.R",
      arguments = c(cohort),
      needs = list(glue("data_process_{cohort}")),
      highly_sensitive = list(
        data2 = glue("output/{cohort}/data/data_long_admission_dates.rds"),
        data3 = glue("output/{cohort}/data/data_long_admission_infectious_dates.rds"),
        data4 = glue("output/{cohort}/data/data_long_admission_noninfectious_dates.rds"),
        data5 = glue("output/{cohort}/data/data_long_pr_probable_covid_dates.rds"),
        data6 = glue("output/{cohort}/data/data_long_pr_suspected_covid_dates.rds"),
        data7 = glue("output/{cohort}/data/data_long_postest_dates.rds")
      )
    ),

    action(
      name = glue("data_properties_{cohort}"),
      run = "r:latest analysis/R/data_properties.R",
      arguments = c(glue("output/{cohort}/data/data_processed.rds"), glue("output/{cohort}/data_properties")),
      needs = list(glue("data_process_{cohort}")),
      moderately_sensitive = list(
        txt = glue("output/{cohort}/data_properties/data_processed*.txt")
      )
    ),

    action(
      name = glue("data_selection_{cohort}"),
      run = "r:latest analysis/R/data_selection.R",
      arguments = c(cohort),
      needs = list(glue("data_process_{cohort}")),
      highly_sensitive = list(
        cohort = glue("output/{cohort}/data/data_cohort.rds")
      ),
      moderately_sensitive = list(
        flow = glue("output/{cohort}/data/flowchart.csv")
      )
    ),

    action(
      name = glue("data_stset_{cohort}"),
      run = "r:latest analysis/R/data_stset.R",
      arguments = c(cohort),
      needs = list("design", glue("data_selection_{cohort}"), glue("data_process_long_{cohort}")),
      highly_sensitive = list(
        fixed = glue("output/{cohort}/data/data_fixed.rds"),
        tte = glue("output/{cohort}/data/data_tte.rds"),
        pt = glue("output/{cohort}/data/data_pt.rds")
      )
    )#,


    # action(
    #   name = glue("data_samples_{cohort}"),
    #   run = "r:latest analysis/R/data_samples.R",
    #   arguments = c(cohort, sample_proc),
    #   needs = list("design", glue("data_stset_{cohort}")),
    #   highly_sensitive = list(
    #     data = glue("output/{cohort}/data/data_samples.rds")
    #   )
    # )

  )
}

## actions that describe data, pre-modelling ----

actions_descriptive <- function(cohort){
  splice(

    action(
      name = glue("check_ethnicity_{cohort}"),
      run = "r:latest analysis/R/check_ethnicity.R",
      arguments = c(cohort),
      needs = list(glue("data_process_{cohort}")),
      moderately_sensitive = list(
        tab = glue("output/{cohort}/data/ethnicity_table*.txt")
      )
    ),

    action(
      name = glue("descr_table1_{cohort}"),
      run = "r:latest analysis/R/descr_table1.R",
      arguments = c(cohort),
      needs = list("design", glue("data_selection_{cohort}")),
      highly_sensitive = list(
        rds = glue("output/{cohort}/descriptive/tables/*.rds")
      ),
      moderately_sensitive = list(
        html = glue("output/{cohort}/descriptive/tables/table1.html")
      )
    ),


    action(
      name = glue("descr_tableirr_{cohort}_0"),
      run = "r:latest analysis/R/descr_tableirr_lite.R",
      arguments = c(cohort, "0"),
      needs = list("design", glue("data_selection_{cohort}")),
      moderately_sensitive = list(
        html = glue("output/{cohort}/descriptive/tables/table_irr_0.html"),
        csv = glue("output/{cohort}/descriptive/tables/table_irr_0.csv")
      )
    ),

    action(
      name = glue("descr_tableirr_{cohort}_Inf"),
      run = "r:latest analysis/R/descr_tableirr_lite.R",
      arguments = c(cohort, "Inf"),
      needs = list("design", glue("data_selection_{cohort}")),
      moderately_sensitive = list(
        html = glue("output/{cohort}/descriptive/tables/table_irr_Inf.html"),
        csv = glue("output/{cohort}/descriptive/tables/table_irr_Inf.csv")
      )
    ),

    action(
      name = glue("descr_events_{cohort}"),
      run = "r:latest analysis/R/descr_events.R",
      arguments = c(cohort),
      needs = list("design", glue("data_stset_{cohort}")),
      highly_sensitive = list(
        rds = glue("output/{cohort}/descriptive/plots/*.rds")
      ),
      moderately_sensitive = list(
        plots = glue("output/{cohort}/descriptive/plots/*.svg"),
        tables = glue("output/{cohort}/descriptive/tables/*.csv")
      )
    )

  )
}


preflight_checks <- function(
  cohort, strata, recentpostest_period
){
  action(
    name = glue("descr_preflight_{cohort}_{strata}_{recentpostest_period}"),
    run = "r:latest analysis/R/preflight.R",
    arguments = c(cohort, strata, recentpostest_period, "150000", "50000"),
    needs = list("design", glue("data_stset_{cohort}")),
    moderately_sensitive = list(
      html = glue("output/{cohort}/descriptive/model-checks/{strata}/{recentpostest_period}/*.html"),
      csv = glue("output/{cohort}/descriptive/model-checks/{strata}/{recentpostest_period}/*.csv")
    )
  )
}

## actions that run the models ----
actions_models <- function(
  cohort, strata, recentpostest_period, brand, outcome, sample_random_n, sample_nonoutcome_n
){

  splice(
    action(
      name = glue("model_{cohort}_{strata}_{recentpostest_period}_{brand}_{outcome}"),
      run = glue("r:latest analysis/R/dose_1/model_msm.R"),
      arguments = c(cohort, strata, recentpostest_period, brand, outcome, sample_random_n, sample_nonoutcome_n),
      needs = list("design", glue("data_stset_{cohort}")),# glue("data_samples_{cohort}")),
      highly_sensitive = list(
        models = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/model*.rds"),
        data = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/data*.rds")
      ),
      moderately_sensitive = list(
        weights = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/weights*")
      )
    ),

    action(
      name = glue("report_ipw_{cohort}_{strata}_{recentpostest_period}_{brand}_{outcome}"),
      run = glue("r:latest analysis/R/dose_1/report_ipw.R"),
      arguments = c(cohort, strata, recentpostest_period, brand, outcome),
      needs = list("design", glue("model_{cohort}_{strata}_{recentpostest_period}_{brand}_{outcome}")),
      highly_sensitive = list(
        broom = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/broom*.rds")
        #gt = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/gt*.rds")
      ),
      moderately_sensitive = list(
        #plots = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/plot*.svg"),
        #tables = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/tab*.html"),
        data = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/broom*.csv")
      )
    ),


    action(
      name = glue("report_msm_{cohort}_{strata}_{recentpostest_period}_{brand}_{outcome}"),
      run = glue("r:latest analysis/R/dose_1/report_msm.R"),
      arguments = c(cohort, strata, recentpostest_period, brand, outcome),
      needs = list("design", glue("model_{cohort}_{strata}_{recentpostest_period}_{brand}_{outcome}")),
      moderately_sensitive = list(
        svg = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/VE_plot.svg"),
        png = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/VE_plot.png"),
        tables = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/estimates*.csv")
      )
    ),


    action(
      name = glue("report_incidence_{cohort}_{strata}_{recentpostest_period}_{brand}_{outcome}"),
      run = glue("r:latest analysis/R/dose_1/report_incidence.R"),
      arguments = c(cohort, strata, recentpostest_period, brand, outcome),
      needs = list("design", glue("model_{cohort}_{strata}_{recentpostest_period}_{brand}_{outcome}")),
      highly_sensitive = list(
        data = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/data_incidence.rds")
      ),
      moderately_sensitive = list(
        cmlsvg = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/cml_incidence*.svg"),
        cmlpng = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/cml_incidence*.png"),
        trendsvg = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/time*.svg"),
        trendpng = glue("output/{cohort}/{strata}/{recentpostest_period}/{brand}/{outcome}/time*.png")
      )
    )
  )
}



## actions that combine results of the models in one place ----

actions_combine_models <- function(
  cohort, strata, recentpostest_period, outcomes
){

  splice(

    action(
      name = glue("report_ipw_{cohort}_{strata}_{recentpostest_period}"),
      run = glue("r:latest analysis/R/dose_1/report_ipw_combined.R"),
      arguments = c(cohort, strata, recentpostest_period, "death"),
      needs = splice(
        "design",
        as.list(
          glue_data(
            .x=expand_grid(brand=c("any", "pfizer", "az")),
            "report_ipw_{cohort}_{strata}_{recentpostest_period}_{brand}_death"
          )
        )
      ),
      moderately_sensitive = list(
        svg = glue("output/{cohort}/{strata}/{recentpostest_period}/combined/plot_vax1.svg"),
        csv = glue("output/{cohort}/{strata}/{recentpostest_period}/combined/tab_vax1.csv"),
        csv_wide = glue("output/{cohort}/{strata}/{recentpostest_period}/combined/tab_vax1_wide.csv")
      )
    ),



    action(
      name = glue("report_msm_{cohort}_{strata}_{recentpostest_period}"),
      run = glue("r:latest analysis/R/dose_1/report_msm_combined.R"),
      arguments = c(cohort, strata, recentpostest_period),
      needs = splice(
        "design",
        as.list(
          glue_data(
            .x=expand_grid(brand=c("any", "pfizer", "az"), outcome=outcomes),
            "report_msm_{cohort}_{strata}_{recentpostest_period}_{brand}_{outcome}"
          )
        )
      ),
      moderately_sensitive = list(
        svg = glue("output/{cohort}/{strata}/{recentpostest_period}/combined/VE*.svg"),
        png = glue("output/{cohort}/{strata}/{recentpostest_period}/combined/VE*.png"),
        csv = glue("output/{cohort}/{strata}/{recentpostest_period}/combined/*.csv")
      )
    ),

    action(
      name = glue("report_incidence_{cohort}_{strata}_{recentpostest_period}"),
      run = glue("r:latest analysis/R/dose_1/report_incidence_combined.R"),
      arguments = c(cohort, strata, recentpostest_period),
      needs = splice(
        "design",
        as.list(
          glue_data(
            .x=expand_grid(brand=c("any", "pfizer", "az"), outcome=outcomes),
            "report_incidence_{cohort}_{strata}_{recentpostest_period}_{brand}_{outcome}"
          )
        )
      ),
      moderately_sensitive = list(
        svg = glue("output/{cohort}/{strata}/{recentpostest_period}/combined/cml_incidence*.svg"),
        png = glue("output/{cohort}/{strata}/{recentpostest_period}/combined/cml_incidence*.png")
      )
    )

  )
}


# specify project ----

## defaults ----
defaults_list <- list(
  version = "3.0",
  expectations= list(population_size=50000L)
)

## actions ----
actions_list <- splice(

  action(
    name = "design",
    run = "r:latest analysis/R/design.R",
    moderately_sensitive = list(
      metadata = "output/metadata/metadata*",
      chars = "output/metadata/baseline_characteristics.rds",
      formula = "output/metadata/list_formula.rds",
      strata = "output/metadata/list_strata*.rds",
      reweight = "output/metadata/reweight_death.rds"
    )
  ),


  ## OVER 80s

  comment("####################################", "over80s", "####################################"),

  actions_process("over80s", "0.1"),
  actions_descriptive("over80s"),

  comment("####################################", "All", "natural estimand", "####################################"),

  preflight_checks("over80s", "all", "0"),

  actions_models("over80s", "all", "0", "any",    "postest", "150000", "50000"),
  actions_models("over80s", "all", "0", "pfizer", "postest", "150000", "50000"),
  actions_models("over80s", "all", "0", "az",     "postest", "150000", "50000"),

  actions_models("over80s", "all", "0", "any",    "covidadmitted", "150000", "50000"),
  actions_models("over80s", "all", "0", "pfizer", "covidadmitted", "150000", "50000"),
  actions_models("over80s", "all", "0", "az",     "covidadmitted", "150000", "50000"),

  # actions_models("over80s", "all", "0", "any",    "coviddeath", "150000", "50000"),
  # actions_models("over80s", "all", "0", "pfizer", "coviddeath", "150000", "50000"),
  # actions_models("over80s", "all", "0", "az",     "coviddeath", "150000", "50000"),
  #
  # actions_models("over80s", "all", "0", "any",    "noncoviddeath", "150000", "50000"),
  # actions_models("over80s", "all", "0", "pfizer", "noncoviddeath", "150000", "50000"),
  # actions_models("over80s", "all", "0", "az",     "noncoviddeath", "150000", "50000"),

  actions_models("over80s", "all", "0", "any",    "death", "150000", "50000"),
  actions_models("over80s", "all", "0", "pfizer", "death", "150000", "50000"),
  actions_models("over80s", "all", "0", "az",     "death", "150000", "50000"),

  actions_combine_models("over80s", "all", "0", c("postest", "covidadmitted", "death")),

  comment("####################################", "All", "modified estimand", "####################################"),

  preflight_checks("over80s", "all", "Inf"),

  actions_models("over80s", "all", "Inf", "any",    "postest",  "150000", "50000"),
  actions_models("over80s", "all", "Inf", "pfizer", "postest", "150000", "50000"),
  actions_models("over80s", "all", "Inf", "az",     "postest", "150000", "50000"),

  actions_models("over80s", "all", "Inf", "any",    "covidadmitted", "150000", "50000"),
  actions_models("over80s", "all", "Inf", "pfizer", "covidadmitted", "150000", "50000"),
  actions_models("over80s", "all", "Inf", "az",     "covidadmitted", "150000", "50000"),

  actions_models("over80s", "all", "Inf", "any",    "coviddeath", "150000", "50000"),
  actions_models("over80s", "all", "Inf", "pfizer", "coviddeath", "150000", "50000"),
  actions_models("over80s", "all", "Inf", "az",     "coviddeath", "150000", "50000"),

  actions_models("over80s", "all", "Inf", "any",    "noncoviddeath", "150000", "50000"),
  actions_models("over80s", "all", "Inf", "pfizer", "noncoviddeath", "150000", "50000"),
  actions_models("over80s", "all", "Inf", "az",     "noncoviddeath", "150000", "50000"),

  actions_models("over80s", "all", "Inf", "any",    "death", "150000", "50000"),
  actions_models("over80s", "all", "Inf", "pfizer", "death", "150000", "50000"),
  actions_models("over80s", "all", "Inf", "az",     "death", "150000", "50000"),

  actions_combine_models("over80s", "all", "Inf", c("postest", "covidadmitted", "coviddeath", "noncoviddeath", "death")),




  # comment("####################################", "Immunosuppressed", "####################################"),
  #
  # preflight_checks("over80s", "any_immunosuppression"),
  #
  # actions_models("over80s", "any_immunosuppression", "any",    "postest", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "pfizer", "postest", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "az",     "postest", "150000", "50000"),
  #
  # actions_models("over80s", "any_immunosuppression", "any",    "covidadmitted", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "pfizer", "covidadmitted", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "az",     "covidadmitted", "150000", "50000"),
  #
  # actions_models("over80s", "any_immunosuppression", "any",    "coviddeath", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "pfizer", "coviddeath", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "az",     "coviddeath", "150000", "50000"),
  #
  # actions_models("over80s", "any_immunosuppression", "any",    "noncoviddeath", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "pfizer", "noncoviddeath", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "az",     "noncoviddeath", "150000", "50000"),
  #
  # actions_models("over80s", "any_immunosuppression", "any",    "death", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "pfizer", "death", "150000", "50000"),
  # actions_models("over80s", "any_immunosuppression", "az",     "death", "150000", "50000"),
  #
  # actions_combine_models("over80s", "any_immunosuppression"),

  ## 70-79s
  comment("####################################", "in70s", "####################################"),

  actions_process("in70s", "0.05"),
  actions_descriptive("in70s"),

  comment("####################################", "all", "natural estimand", "####################################"),

  preflight_checks("in70s", "all", "0"),

  actions_models("in70s", "all", "0", "any",    "postest", "150000", "50000"),
  actions_models("in70s", "all", "0", "pfizer", "postest", "150000", "50000"),
  actions_models("in70s", "all", "0", "az",     "postest", "150000", "50000"),

  actions_models("in70s", "all", "0", "any",    "covidadmitted", "150000", "50000"),
  actions_models("in70s", "all", "0", "pfizer", "covidadmitted", "150000", "50000"),
  actions_models("in70s", "all", "0", "az",     "covidadmitted", "150000", "50000"),

  # actions_models("in70s", "all", "0", "any",    "coviddeath", "150000", "50000"),
  # actions_models("in70s", "all", "0", "pfizer", "coviddeath", "150000", "50000"),
  # actions_models("in70s", "all", "0", "az",     "coviddeath", "150000", "50000"),
  #
  # actions_models("in70s", "all", "0", "any",    "noncoviddeath", "150000", "50000"),
  # actions_models("in70s", "all", "0", "pfizer", "noncoviddeath", "150000", "50000"),
  # actions_models("in70s", "all", "0", "az",     "noncoviddeath", "150000", "50000"),

  actions_models("in70s", "all", "0", "any",    "death", "150000", "50000"),
  actions_models("in70s", "all", "0", "pfizer", "death", "150000", "50000"),
  actions_models("in70s", "all", "0", "az",     "death", "150000", "50000"),


  actions_combine_models("in70s", "all", "0",  c("postest", "covidadmitted", "death")),


  comment("####################################", "All", "modified estimand", "####################################"),

  preflight_checks("in70s", "all", "Inf"),

  actions_models("in70s", "all", "Inf", "any",    "postest", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "pfizer", "postest", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "az",     "postest", "150000", "50000"),

  actions_models("in70s", "all", "Inf", "any",    "covidadmitted", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "pfizer", "covidadmitted", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "az",     "covidadmitted", "150000", "50000"),

  actions_models("in70s", "all", "Inf", "any",    "coviddeath", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "pfizer", "coviddeath", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "az",     "coviddeath", "150000", "50000"),

  actions_models("in70s", "all", "Inf", "any",    "noncoviddeath", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "pfizer", "noncoviddeath", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "az",     "noncoviddeath", "150000", "50000"),

  actions_models("in70s", "all", "Inf", "any",    "death", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "pfizer", "death", "150000", "50000"),
  actions_models("in70s", "all", "Inf", "az",     "death", "150000", "50000"),


  actions_combine_models("in70s", "all", "Inf",  c("postest", "covidadmitted", "coviddeath", "noncoviddeath", "death")),

  comment("####################################", "Combine info across cohorts", "####################################"),

  action(
    name = "descr_events_allcohorts",
    run = "r:latest analysis/R/descr_events_all.R",
    needs = list("descr_events_over80s","descr_events_in70s"),
    moderately_sensitive = list(
      plots = "output/combined/brandcounts12*"
    )
  ),

  action(
    name = "report_msm_allcohorts",
    run = "r:latest analysis/R/dose_1/report_msm_combined_0Inf.R",
    needs = splice(
      "design",
      as.list(
        glue_data(
          .x=expand_grid(
            cohort=c("over80s", "in70s"),
            recent_postestperiod = c("0","Inf"),
            brand=c("pfizer", "az"),
            outcome=c("postest", "covidadmitted", "death")
          ),
          "report_msm_{cohort}_all_{recent_postestperiod}_{brand}_{outcome}"
        )
      )
    ),
    moderately_sensitive = list(
      plots = "output/combined/VE_plot*"
    )
  ),

  action(
    name = "report_msm_metacohorts",
    run = "r:latest analysis/R/dose_1/report_msm_meta.R",
    needs = splice(
      "design",
      as.list(
        glue_data(
          .x=expand_grid(
            cohort=c("over80s", "in70s"),
            recent_postestperiod = c("0","Inf"),
            brand=c("any", "pfizer", "az"),
            outcome=c("postest", "covidadmitted", "death")
          ),
          "report_msm_{cohort}_all_{recent_postestperiod}_{brand}_{outcome}"
        )
      )
    ),
    moderately_sensitive = list(
      plots = "output/combined/VE_plot_metaanalysis*",
      estimates = "output/combined/meta_estimates*"
    )
  )

)

## combine everything ----
project_list <- splice(
  defaults_list,
  list(actions = actions_list)
)

## convert list to yaml, reformat comments and whitespace,and output ----
as.yaml(project_list, indent=2) %>%
  # convert comment actions to comments
  convert_comment_actions() %>%
  # add one blank line before level 1 and level 2 keys
  str_replace_all("\\\n(\\w)", "\n\n\\1") %>%
  str_replace_all("\\\n\\s\\s(\\w)", "\n\n  \\1") %>%
  writeLines(here("project.yaml"))


## grab all action names and send to a txt file

names(actions_list) %>% tibble(action=.) %>%
  mutate(
    model = str_detect(action, "model"),
    model_number = cumsum(model)
  ) %>%
  group_by(model_number) %>%
  summarise(
    sets = paste(action, collapse=" ")
  ) %>% pull(sets) %>%
  paste(collapse="\n") %>%
  writeLines(here("actions.txt"))

