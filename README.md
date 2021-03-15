# Covid vaccine effectiveness study

This is the code and configuration for the OpenSAFELY study investigating the out-of-trial effectiveness of vaccines for Covid-19. 

* Raw model outputs, including charts, crosstabs, etc, are in `released_outputs/`
* If you are interested in how we defined our variables, take a look at the [study definition](analysis/study_definition_all.py); this is written in `python`, but non-programmers should be able to understand what is going on there
* If you are interested in how we defined our code lists, look in the [codelists folder](./codelists/).
* Developers and epidemiologists interested in the framework should review [the OpenSAFELY documentation](https://docs.opensafely.org)


# Repository navigation

* The study definition that defines the data to be extracted from the OpenSAFELY-TPP database is  [study_definition_all.py](analysis/study_definition_all.py).
* The R scripts that process and analyse this extracted data are contained in the [analysis/R/](analysis/R/) folder.

The R scripts run across four different design characteristics:
* Patient cohort (`cohort`) for instance the over 80s or the 70-79s.
* Study outcome (`outcome`) such as positive Covid test or Covid-related hospitalisation
* Vaccine brand (`brand`), currently either any vaccines (`any`), Pfizer-BioNTech vaccine (`pfizer`) or Oxford-AstraZeneca (`az`).
* Analysis strata (`strata`), for example analyses stratified by sex or deprivation status. To run an unstratified analysis, use `all`.

It will be possible to run most sensitivity analyses via the `cohort` argument.

The main scripts are as follows:

* [`data_process_all.R`](analysis/R/data_process_all.R) imports the extracted database data, tidies the data, and creates separate datasets for time-dependent variables occurring throughout the study period, such as hospital admissions and primary care events.
* [`data_define_cohorts.R`](analysis/R/data_define_cohorts.R) creates an indicator variable for each analysis cohort of interest (`cohort`), and creates some cohort metadata used for reporting.
* [`data_stset.R`](analysis/data_stset.R) re-shapes the data to be used for different analyses. It is run once for each `cohort`.
  * Two one row per patient datasets (`data_tte` and `data_fixed`)
  * One one-row-per-patient-per event dataset, AKA "counting process" form (`data_cp`)
  * One one-row-per-patient-per-day dataset, AKA "person-time" form (`data_pt`)
* [`models_msm_dose1.R`](analsis/models_msm_dose1.R). This script is run once for each combination of `cohort`, `outcome`, `brand` and `strata`, fitting marginal structural models that look at the effect of first vaccine dose on outcomes. It: fits logistic regression models on (subsets of the) `data_pt` dataset to predict vaccination and censoring events; uses predictions from these models to creates weights for the substantive vaccine-outcome models; fits the substantive outcome models, also with logistic regression, using different adjustment sets. Each of the models are fit using the `parglm` function, which speeds up the model-fitting procedure by parallelising some of the operations. The script itself is run sequentially (ie, fitting model 2 only starts once model 1 is finished), though in theory some could be run in parallel.
* [`report_msm_dose1.R`](analysis/report_msm_dose1.R). This script is run once for each combination of `cohort`, `outcome`, `brand` and `strata`. It takes the models created in the previous script and outputs some tables and graphs.

* [`plot_status_over_time.R`](analysis/plot_status_over_time.R) creates some descriptive plots looking at vaccination status and outcome status over time across all patients in each cohort. It is run once for each `cohort`.
* [`table1.R`](analysis/table1.R) creates a table 1 type output for each cohort.


# About the OpenSAFELY framework

The OpenSAFELY framework is a secure analytics platform for
electronic health records research in the NHS.

Instead of requesting access for slices of patient data and
transporting them elsewhere for analysis, the framework supports
developing analytics against dummy data, and then running against the
real data *within the same infrastructure that the data is stored*.
Read more at [OpenSAFELY.org](https://opensafely.org).
