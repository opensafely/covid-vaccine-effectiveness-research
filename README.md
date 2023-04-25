# covid-vaccine-effectiveness-research

You can run this project via [Gitpod](https://gitpod.io) in a web browser by clicking on this badge: [![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/covid-vaccine-effectiveness-research)

[View on OpenSAFELY](https://jobs.opensafely.org/repo/https%253A%252F%252Fgithub.com%252Fopensafely%252Fcovid-vaccine-effectiveness-research)

Details of the purpose and any published outputs from this project can be found at the link above.

The contents of this repository MUST NOT be considered an accurate or valid representation of the study or its purpose. 
This repository may reflect an incomplete or incorrect analysis with no further ongoing work.
The content has ONLY been made public to support the OpenSAFELY [open science and transparency principles](https://www.opensafely.org/about/#contributing-to-best-practice-around-open-science) and to support the sharing of re-usable code for other subsequent users.
No clinical, policy or safety conclusions must be drawn from the contents of this repository.

# About the OpenSAFELY framework

The OpenSAFELY framework is a Trusted Research Environment (TRE) for electronic
health records research in the NHS, with a focus on public accountability and
research quality.

Read more at [OpenSAFELY.org](https://opensafely.org).

# Licences
As standard, research projects have a MIT license. 


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
