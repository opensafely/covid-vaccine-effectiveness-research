# Covid vaccine effectiveness study

This is the code and configuration for the OpenSAFELY study investigating the out-of-trial effectiveness of vaccines for Covid-19. 

* Raw model outputs, including tables, figures, etc, are in the [`released_outputs/`](./released_outputs) folder.
* If you are interested in how we defined our variables, take a look at the [common_variables.py](./analysis/common_variables.py) and [study_definition.py](./analysis/study_definition_over80s.py) scripts; these are written in `python`, but non-programmers should be able to understand what is going on there
* If you are interested in how we defined our codelists, look in the [codelists folder](./codelists/).
* Developers and researchers interested in the framework should review [the OpenSAFELY documentation](https://docs.opensafely.org)

## Repository navigation and use

* The [`project.yaml`](./project.yaml) file should _not_ be edited directly. To make changes the the yaml, edit and run the [`create_project.R`](./create_project.R) script instead. 
* The [`design.R`](analysis/R/design.R) script defines some common design elements for the study, such as model outcomes and covariates. 
* The ['global-variables.json`](analysis/global-variables.json) file contains study start and end dates, and vaccine eligibility and roll-out dates.
* The study definitions that define the data to be extracted from the OpenSAFELY-TPP database are the [study_definition_{cohort}.py](./analysis/) files, where `{cohort}` is the analysis cohort of interest. Most of the variables in these study definitions are stored in the [common_variables.py](./analysis/common_variables.py) script. 
  * These study definitions create dummy data, but they are not used. Instead, use the dummy data created by the [analysis/R/dummy/data_makedummy.R](./analysis/R/dummy/data_makedummy.R) script. Creating dummy data independently of the study definition allows more for realistic (or at least, more usable) dummy data, for example by ensuring that second vaccine doses always occur before first doses. If the study definitions are updated, this script must also be updated to ensure variable names and types match. 
* The [`lib/`](./lib) directory contains functions that are used through the code-base.
* The R scripts that process and analyse this extracted data live in the [analysis/R/](./analysis/R/) directory. See the [`project.yaml`](./project.yaml) to understand more about the run order and dependencies of these scripts. At the top of each script is a description of what the script is supposed to do. 

## Local development and testing

GitHub test actions are disabled for this repository. This is because running the project from start to finish takes many hours and eats into the finite processing time allocated the github.com/opensafely organisation. 

The long run time also makes it difficult to test locally. Many actions can be run in parallel, but this use too much memory, so running actions has to be managed carefully. Often it's not worth trying to run every action locally because it takes far too long. But this means downstream actions can't run if they depend on upstream actions that haven't been run. There are some workarounds that make testing possible even when upstream actions haven't been run - ask @wjchulme about these.

## Running actions on the real data

The `stset_{cohort}` and `model_msm_{cohort}_{strata}_{recent_postestperiod}_{brand}_{outcome}` actions take hours to run and use a lot of memory. It's best to only attempt to run one of thse actions at a time. Even then, if there are other actions running on the server, they may crash.

## Pre-modelling scripts

These scripts process the extracted data and produce some descriptive outputs.
* [`data_process.R`](./analysis/R/data_process.R) imports the extracted database data, tidies the data, and creates separate datasets for time-dependent variables occurring throughout the study period, such as hospital admissions and primary care events.
* [`data_selection.R`](./analysis/R/data_selection.R) filters out people who sould not be included in the main analysis, and outputs the data used for the inclusion/exclusion flowchart.
* [`data_stset.R`](./analysis/data_stset.R) re-shapes the data to be used for different analyses. It is run once for each `cohort`.
  * Two one row per patient datasets, `data_tte` (containing time-to-event information) and `data_fixed` (containing info on fixed baseline characteristics).
  * One one-row-per-patient-per-day dataset, AKA "person-time" form (`data_pt`)
* [`descr_table1.R`](./analysis/R/descr_table1.R) creates a "table 1" table describing cohort characteristics at baseline. Since follow-up includes both unexposed and exposed person-time for each participant, there's no exposed/unexposed stratification in the table 1. 
* [`descr_tableirr_lite.R`](./analysis/R/descr_tableirr_lite.R) creates the unadjusted incidence rate and incidence rate ratio tables for various outcomes at different times since vacciation. "lite", because it uses less memory than [`descr_tableirr.R`](./analysis/R/descr_tableirr.R) so doesn't crash with large datasets.
* [`descr_events.R`](./analysis/R/descr_table1.R) outputs some plots of event rates, cumulative vaccination uptake, etc over time. 


## Modelling scripts

These scripts live in the [analysis/R/dose_1](./analysis/R/dose_1) subdirectory, and fit the main analysis models for the study.

* [`models_msm.R`](./analysis/dose_1/models_msm.R). This script fits the marginal structural models that estimate the effect of first vaccine dose on outcomes. It: fits pooled logistic regression models on (subsets of the) `data_pt` dataset to predict vaccination and censoring events; uses predictions from these models to creates weights for the substantive vaccine-outcome models; fits the substantive outcome models, also with pooled logistic regression, using different adjustment sets. Each of the models are fit using the `parglm` function, which speeds up the model-fitting procedure with parallelisation. The script itself is run sequentially (ie, fitting model 2 only starts once model 1 is finished), though in theory the codebase could be refactored to run these in parallel (which would cause all sorts of other problems).
* [`report_ipw.R`](./analysis/dose_1/report_ipw.R) takes the models created in the [`models_msm.R`](./analysis/dose_1/models_msm.R) script and outputs some tables and graphs describing the vaccination models used to derive the inverse probability weights for the main MSM model. 
* [`report_msm.R`](./analysis/dose_1/report_msm.R) takes the models created in the [`models_msm.R`](./analysis/dose_1/models_msm.R) script and outputs some tables and graphs describing the main MSM models. 
* [`report_incidence.R`](./analysis/dose_1/report_incidence.R) takes the models created in the [`models_msm.R`](./analysis/dose_1/models_msm.R) script and calculates the cumulative event incidence assuming that a) everybody was vaccinated on day 1 and b) nobody was vaccinated at all.

These scripts run across five different design characteristics:
  * The patient cohort (`cohort`) for instance the over 80s or the 70-79s.
  * The study outcome (`outcome`) such as positive covid test or covid-related hospitalisation
  * The vaccine brand (`brand`), currently Pfizer-BioNTech (`pfizer`), Oxford-AstraZeneca (`az`), or any of these two vaccines (`any`).
  * The analysis strata variable (`strata`), for example analyses stratified by sex or immunosuppression status. To run an unstratified analysis, use `all`.
  * The exclusion period for vaccination following a positive test (`recent_postestperiod`), during which time vaccinated person-time is coded as unvaccinated. Use `0` to code vaccination time in the natural way (i.e., code vaccination time as unvaccinated time for zero days after a positive test).

In addition, there are some `...combined.R` scripts which combine data across different cohorts and outcomes, and output publication-ready figures. 

# About the OpenSAFELY framework

The OpenSAFELY framework is a secure analytics platform for
electronic health records research in the NHS.

Instead of requesting access for slices of patient data and
transporting them elsewhere for analysis, the framework supports
developing analytics against dummy data, and then running against the
real data *within the same infrastructure that the data is stored*.
Read more at [OpenSAFELY.org](https://opensafely.org).
