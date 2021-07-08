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


as.yaml(list(a="c", b="'c'", comment("fff")))


## create function to convert comment "actions" in a yaml string into proper comments
convert_comment_actions <-function(yaml.txt){
  yaml.txt %>%
    str_replace_all("\\\n(\\s*)\\'\\'\\:(\\s*)\\'", "\n\\1")  %>%
    #str_replace_all("\\\n(\\s*)\\'", "\n\\1") %>%
    str_replace_all("([^\\'])\\\n(\\s*)\\#\\#", "\\1\n\n\\2\\#\\#") %>%
    str_replace_all("\\#\\#\\'\\\n", "\n")
}
as.yaml(splice(a="c", b="'c'", comment("fff")))
convert_comment_actions(as.yaml(splice(a="c", b="'c'", comment("fff"))))

## actions that extract and process data ----

actions_process <- function(cohort){
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
        data = glue("output/{cohort}/data/data_processed.rds")
      )
    ),

    action(
      name = glue("data_process_long_{cohort}"),
      run = "r:latest analysis/R/data_process_long.R",
      arguments = c(cohort),
      needs = list(glue("data_process_{cohort}")),
      highly_sensitive = list(
        data1 = glue("output/{cohort}/data/data_long_vax_dates.rds"),
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
      arguments = c(cohort, "0.1"),
      needs = list("design", glue("data_selection_{cohort}"), glue("data_process_long_{cohort}")),
      highly_sensitive = list(
        fixed = glue("output/{cohort}/data/data_fixed.rds"),
        tte = glue("output/{cohort}/data/data_tte.rds"),
        pt = glue("output/{cohort}/data/data_pt.rds")
      )
    ),


    action(
      name = glue("data_samples_{cohort}"),
      run = "r:latest analysis/R/data_samples.R",
      arguments = c(cohort, "0.1"),
      needs = list("design", glue("data_stset_{cohort}")),
      highly_sensitive = list(
        data = glue("output/{cohort}/data/data_samples.rds")
      )
    )

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
      name = glue("descr_tableirr_{cohort}"),
      run = "r:latest analysis/R/descr_tableirr.R",
      arguments = c(cohort),
      needs = list("design", glue("data_selection_{cohort}")),
      moderately_sensitive = list(
        html = glue("output/{cohort}/descriptive/tables/table_irr.html"),
        csv = glue("output/{cohort}/descriptive/tables/table_irr.csv")
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
    )#,


    # action(
    #   name = glue("descr_preflight_{cohort}"),
    #   run = "r:latest analysis/R/preflight.R",
    #   arguments = c(cohort, "all", "0.1"),
    #   needs = list("design", glue("data_stset_{cohort}")),
    #   moderately_sensitive = list(
    #     html = glue("output/{cohort}/descriptive/model-checks/*/*.html"),
    #     csv = glue("output/{cohort}/descriptive/model-checks/*/*.csv")
    #   )
    # )
  )
}





## actions that run the models ----
actions_models <- function(
  cohort, outcome, brand, strata
){

  splice(
    action(
      name = glue("model_{cohort}_{strata}_{brand}_{outcome}"),
      run = glue("r:latest analysis/R/dose_1/model_msm.R"),
      arguments = c(cohort, strata, brand, outcome),
      needs = list("design", glue("data_stset_{cohort}"), glue("data_samples_{cohort}")),
      highly_sensitive = list(
        models = glue("output/{cohort}/{strata}/{brand}/{outcome}/model*.rds"),
        data = glue("output/{cohort}/{strata}/{brand}/{outcome}/data*.rds")
      ),
      moderately_sensitive = list(
        weights = glue("output/{cohort}/{strata}/{brand}/{outcome}/weights*")
      )
    ),

    action(
      name = glue("report_ipw_{cohort}_{strata}_{brand}_{outcome}"),
      run = glue("r:latest analysis/R/dose_1/report_ipw.R"),
      arguments = c(cohort, strata, brand, outcome),
      needs = list("design", glue("model_{cohort}_{strata}_{brand}_{outcome}")),
      highly_sensitive = list(
        broom = glue("output/{cohort}/{strata}/{brand}/{outcome}/broom*.rds")
        #gt = glue("output/{cohort}/{strata}/{brand}/{outcome}/gt*.rds")
      ),
      moderately_sensitive = list(
        #plots = glue("output/{cohort}/{strata}/{brand}/{outcome}/plot*.svg"),
        #tables = glue("output/{cohort}/{strata}/{brand}/{outcome}/tab*.html"),
        data = glue("output/{cohort}/{strata}/{brand}/{outcome}/broom*.csv")
      )
    ),


    action(
      name = glue("report_msm_{cohort}_{strata}_{brand}_{outcome}"),
      run = glue("r:latest analysis/R/dose_1/report_msm.R"),
      arguments = c(cohort, strata, brand, outcome),
      needs = list("design", glue("model_{cohort}_{strata}_{brand}_{outcome}")),
      moderately_sensitive = list(
        svg = glue("output/{cohort}/{strata}/{brand}/{outcome}/VE_plot.svg"),
        png = glue("output/{cohort}/{strata}/{brand}/{outcome}/VE_plot.png"),
        tables = glue("output/{cohort}/{strata}/{brand}/{outcome}/estimates*.csv")
      )
    ),


    action(
      name = glue("report_incidence_{cohort}_{strata}_{brand}_{outcome}"),
      run = glue("r:latest analysis/R/dose_1/report_incidence.R"),
      arguments = c(cohort, strata, brand, outcome),
      needs = list("design", glue("model_{cohort}_{strata}_{brand}_{outcome}")),
      moderately_sensitive = list(
        cmlsvg = glue("output/{cohort}/{strata}/{brand}/{outcome}/cml_incidence*.svg"),
        cmlpng = glue("output/{cohort}/{strata}/{brand}/{outcome}/cml_incidence*.png"),
        trendsvg = glue("output/{cohort}/{strata}/{brand}/{outcome}/time*.svg"),
        trendpng = glue("output/{cohort}/{strata}/{brand}/{outcome}/time*.png")
      )
    )
  )
}



## actions that combine results of the models in one place ----

actions_combine_models <- function(
  cohort, strata
){

  splice(

    action(
      name = glue("report_ipw_{cohort}_{strata}"),
      run = glue("r:latest analysis/R/dose_1/report_vaxmodel.R"),
      arguments = c(cohort, strata, "death"),
      needs = list(
        "design",
        glue("report_ipw_{cohort}_{strata}_any_death"),
        glue("report_ipw_{cohort}_{strata}_pfizer_death"),
        glue("report_ipw_{cohort}_{strata}_az_death")
      ),
      moderately_sensitive = list(
        svg = glue("output/{cohort}/{strata}/plot_vax1.svg"),
        csv = glue("output/{cohort}/{strata}/tab_vax1.csv"),
        csv_wide = glue("output/{cohort}/{strata}/tab_vax1_wide.csv")
      )
    ),



    action(
      name = glue("report_{cohort}_{strata}"),
      run = glue("r:latest analysis/R/dose_1/report_msm_combined.R"),
      arguments = c(cohort, strata),
      needs = list(
        "design",
        glue("report_msm_{cohort}_{strata}_any_postest"),
        glue("report_msm_{cohort}_{strata}_any_covidadmitted"),
        glue("report_msm_{cohort}_{strata}_any_coviddeath"),
        glue("report_msm_{cohort}_{strata}_any_noncoviddeath"),
        glue("report_msm_{cohort}_{strata}_pfizer_postest"),
        glue("report_msm_{cohort}_{strata}_pfizer_covidadmitted"),
        glue("report_msm_{cohort}_{strata}_pfizer_coviddeath"),
        glue("report_msm_{cohort}_{strata}_pfizer_noncoviddeath"),
        glue("report_msm_{cohort}_{strata}_az_postest"),
        glue("report_msm_{cohort}_{strata}_az_covidadmitted"),
        glue("report_msm_{cohort}_{strata}_az_coviddeath"),
        glue("report_msm_{cohort}_{strata}_az_noncoviddeath")
      ),
      moderately_sensitive = list(
        svg = glue("output/{cohort}/{strata}/*.svg"),
        png = glue("output/{cohort}/{strata}/combined/*.png"),
        csv = glue("output/{cohort}/{strata}/combined/*.csv")
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
      strata = "output/metadata/list_strata.rds",
      reweight = "output/metadata/reweight_death.rds",
      exclude_recentpostest = "output/metadata/exclude_recentpostest.rds"
    )
  ),


  ## OVER 80s

  comment("####################################", "over80s", "####################################"),

  actions_process("over80s"),
  actions_descriptive("over80s"),

  comment("####################################", "All", "####################################"),

  actions_models("over80s", "postest", "any", "all"),
  actions_models("over80s", "postest", "pfizer", "all"),
  actions_models("over80s", "postest", "az", "all"),

  actions_models("over80s", "covidadmitted", "any", "all"),
  actions_models("over80s", "covidadmitted", "pfizer", "all"),
  actions_models("over80s", "covidadmitted", "az", "all"),

  actions_models("over80s", "coviddeath", "any", "all"),
  actions_models("over80s", "coviddeath", "pfizer", "all"),
  actions_models("over80s", "coviddeath", "az", "all"),

  actions_models("over80s", "noncoviddeath", "any", "all"),
  actions_models("over80s", "noncoviddeath", "pfizer", "all"),
  actions_models("over80s", "noncoviddeath", "az", "all"),

  actions_models("over80s", "death", "any", "all"),
  actions_models("over80s", "death", "pfizer", "all"),
  actions_models("over80s", "death", "az", "all"),

  actions_combine_models("over80s", "all"),

  comment("####################################", "Immunosuppressed", "####################################"),

  actions_models("over80s", "postest", "any", "any_immunosuppression"),
  actions_models("over80s", "postest", "pfizer", "any_immunosuppression"),
  actions_models("over80s", "postest", "az", "any_immunosuppression"),

  actions_models("over80s", "covidadmitted", "any", "any_immunosuppression"),
  actions_models("over80s", "covidadmitted", "pfizer", "any_immunosuppression"),
  actions_models("over80s", "covidadmitted", "az", "any_immunosuppression"),

  actions_models("over80s", "coviddeath", "any", "any_immunosuppression"),
  actions_models("over80s", "coviddeath", "pfizer", "any_immunosuppression"),
  actions_models("over80s", "coviddeath", "az", "any_immunosuppression"),

  actions_models("over80s", "noncoviddeath", "any", "any_immunosuppression"),
  actions_models("over80s", "noncoviddeath", "pfizer", "any_immunosuppression"),
  actions_models("over80s", "noncoviddeath", "az", "any_immunosuppression"),

  actions_models("over80s", "death", "any", "any_immunosuppression"),
  actions_models("over80s", "death", "pfizer", "any_immunosuppression"),
  actions_models("over80s", "death", "az", "any_immunosuppression"),

  actions_combine_models("over80s", "any_immunosuppression"),

  ## 70-79s
  comment("####################################", "in70s, all", "####################################"),

  actions_process("in70s"),
  actions_descriptive("in70s"),

  actions_models("in70s", "postest", "any", "all"),
  actions_models("in70s", "postest", "pfizer", "all"),
  actions_models("in70s", "postest", "az", "all"),

  actions_models("in70s", "covidadmitted", "any", "all"),
  actions_models("in70s", "covidadmitted", "pfizer", "all"),
  actions_models("in70s", "covidadmitted", "az", "all"),

  actions_models("in70s", "coviddeath", "any", "all"),
  actions_models("in70s", "coviddeath", "pfizer", "all"),
  actions_models("in70s", "coviddeath", "az", "all"),

  actions_models("in70s", "noncoviddeath", "any", "all"),
  actions_models("in70s", "noncoviddeath", "pfizer", "all"),
  actions_models("in70s", "noncoviddeath", "az", "all"),

  actions_models("in70s", "death", "any", "all"),
  actions_models("in70s", "death", "pfizer", "all"),
  actions_models("in70s", "death", "az", "all"),

  actions_combine_models("in70s", "all")

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


