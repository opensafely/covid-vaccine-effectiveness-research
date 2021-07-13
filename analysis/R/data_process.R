######################################

# This script:
# imports data extracted by the cohort extractor
# fills in unknown ethnicity from GP records with ethnicity from SUS (secondary care)
# tidies missing values
# re-orders date variables so no negative time differences (only actually does anything for dummy data)
# standardises some variables (eg convert to factor) and derives some new ones
# saves processed one-row-per-patient dataset
# saves one-row-per-patient dataset for vaccines and for hospital admissions

######################################




# Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('arrow')
library('lubridate')
#library('arrow')

# Import custom user functions from lib
source(here("lib", "utility_functions.R"))

# import globally defined repo variables from
gbl_vars <- jsonlite::fromJSON(
  txt="./analysis/global-variables.json"
)
gbl_vars$run_date =date(file.info(here("metadata", "extract_over80s.log"))$ctime)
#list2env(gbl_vars, globalenv())


## import command-line arguments ----
args <- commandArgs(trailingOnly=TRUE)
if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  cohort <- "over80s"

} else {
  removeobs <- TRUE
  cohort <- args[[1]]
}


# output processed data to rds ----

fs::dir_create(here("output", cohort, "data"))


# process ----

# use externally created dummy data if not running in the server
# check variables are as they should be
if(Sys.getenv("OPENSAFELY_BACKEND") %in% c("", "expectations")){

  # ideally in future this will check column existence and types from metadata,
  # rather than from a cohort-extractor-generated dummy data

  data_studydef_dummy <- read_feather(here("output", glue("input_{cohort}.feather")))
  data_custom_dummy <- read_feather(here("output", "dummyinput.feather"))

  not_in_studydef <- names(data_custom_dummy)[!( names(data_custom_dummy) %in% names(data_studydef_dummy) )]
  not_in_custom  <- names(data_studydef_dummy)[!( names(data_studydef_dummy) %in% names(data_custom_dummy) )]


  if(length(not_in_custom)!=0) stop(
    paste(
      "These variables are in studydef but not in custom: ",
      paste(not_in_custom, collapse=", ")
    )
  )


  if(length(not_in_studydef)!=0) stop(
    paste(
      "These variables are in custom but not in studydef: ",
      paste(not_in_studydef, collapse=", ")
    )
  )

  # reorder columns
  data_studydef_dummy <- data_studydef_dummy[,names(data_custom_dummy)]

  unmatched_types <- cbind(
    map_chr(data_studydef_dummy, class) ,
    map_chr(data_custom_dummy, class)
  )[ (map_chr(data_studydef_dummy, class) != map_chr(data_custom_dummy, class)) ,] %>%
    as.data.frame() %>% rownames_to_column()


  if(nrow(unmatched_types)>0) stop(
    #unmatched_types
    "inconsistent typing in studydef : dummy dataset\n",
    apply(unmatched_types, 1, function(row) paste(paste(row, collapse=" : "), "\n"))
  )

  data_extract0 <- data_custom_dummy
} else {
  data_extract0 <- read_feather(here("output", glue("input_{cohort}.feather")))
}


#convert date-strings to dates
data_extract <- data_extract0 %>%
  mutate(across(
    .cols = ends_with("_date"),
    .fns = as.Date
  ))


##  SECTION TO SORT OUT BAD DUMMY DATA ----
# this rearranges so events are in date order

data_dates_reordered_long <- data_extract %>%
  select(patient_id, matches("^(.*)_([1-9]+)_date"), -starts_with("covid_vax")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", "index"),
    names_pattern = "^(.*)_([1-9]+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, event, date) %>%
  group_by(patient_id, event) %>%
  mutate(
    index = row_number(),
    name = paste0(event,"_",index,"_date")
  ) %>%
  ungroup() %>%
  select(
    patient_id, name, event, index, date
  )


data_dates_reordered_wide <- data_dates_reordered_long %>%
  arrange(name, patient_id) %>%
  pivot_wider(
    id_cols=c(patient_id),
    names_from = name,
    values_from = date
  )

data_extract_reordered <- left_join(
  data_extract %>% select(-names(data_dates_reordered_wide)[-1]),
  data_dates_reordered_wide,
  by="patient_id"
)


data_processed <- data_extract_reordered %>%
  mutate(

    start_date = as.Date(gbl_vars[[glue("start_date_{cohort}")]]), # this is interpreted later as [midnight at the _end of_ the start date] = [midnight at the _start of_ start date + 1], So that for example deaths on start_date+1 occur at t=1, not t=0.
    end_date = as.Date(gbl_vars$end_date),
    censor_date = pmin(end_date, death_date, na.rm=TRUE),

    sex = fct_case_when(
      sex == "F" ~ "Female",
      sex == "M" ~ "Male",
      #sex == "I" ~ "Inter-sex",
      #sex == "U" ~ "Unknown",
      TRUE ~ NA_character_
    ),

    ageband = cut(
      age,
      breaks=c(-Inf, 18, 50, 60, 70, 80, Inf),
      labels=c("under 18", "18-49", "50s", "60s", "70s", "80+"),
      right=FALSE
    ),

    # Fill in unknown ethnicity from GP records with ethnicity from SUS (secondary care)
    ethnicity_combined = if_else(is.na(ethnicity), ethnicity_6_sus, ethnicity),
    ethnicity_combined = fct_case_when(
      ethnicity_combined == "1" ~ "White",
      ethnicity_combined == "4" ~ "Black",
      ethnicity_combined == "3" ~ "South Asian",
      ethnicity_combined == "2" ~ "Mixed",
      ethnicity_combined == "5" ~ "Other",
      #TRUE ~ "Unknown",
      TRUE ~ NA_character_

    ),


    imd = na_if(imd, "0"),
    imd = fct_case_when(
      imd == 1 ~ "1 most deprived",
      imd == 2 ~ "2",
      imd == 3 ~ "3",
      imd == 4 ~ "4",
      imd == 5 ~ "5 least deprived",
      #TRUE ~ "Unknown",
      TRUE ~ NA_character_
    ),

    care_home_combined = care_home_tpp | care_home_code, # any carehome flag

    any_immunosuppression = (permanant_immunosuppression | asplenia | dmards | solid_organ_transplantation | sickle_cell_disease | temporary_immunosuppression | bone_marrow_transplant | chemo_or_radio),

    multimorb =
      (bmi %in% c("Obese II (35-39.9)", "Obese III (40+)")) +
      (chronic_cardiac_disease | heart_failure | other_heart_disease) +
      (dialysis) +
      (diabetes) +
      (chronic_liver_disease)+
      (current_copd | other_resp_conditions)+
      (lung_cancer | haematological_cancer | cancer_excl_lung_and_haem)+
      (any_immunosuppression)+
      (dementia | other_neuro_conditions)+
      (LD_incl_DS_and_CP)+
      (psychosis_schiz_bipolar),
    multimorb = cut(multimorb, breaks = c(0, 1, 2, 3, 4, Inf), labels=c("0", "1", "2", "3", "4+"), right=FALSE),

    efi_cat = fct_case_when(
      is.na(efi) | (efi <= 0.12) ~ "None",
      efi <= 0.24 ~ "Mild",
      efi <= 0.36 ~ "Moderate",
      TRUE ~ "Severe"
    ),

    cause_of_death = fct_case_when(
      !is.na(coviddeath_date) ~ "covid-related",
      !is.na(death_date) ~ "not covid-related",
      TRUE ~ NA_character_
    ),

    noncoviddeath_date = if_else(!is.na(death_date) & is.na(coviddeath_date), death_date, as.Date(NA_character_)),

  ) %>%
  droplevels()


##  reformat covid vaccine data


data_vax <- local({

  # data_vax_all <- data_processed %>%
  #   select(patient_id, matches("covid\\_vax\\_\\d+\\_date")) %>%
  #   pivot_longer(
  #     cols = -patient_id,
  #     names_to = c(NA, "vax_index"),
  #     names_pattern = "^(.*)_(\\d+)_date",
  #     values_to = "date",
  #     values_drop_na = TRUE
  #   ) %>%
  #   arrange(patient_id, date)

  data_vax_pfizer <- data_processed %>%
    select(patient_id, matches("covid\\_vax\\_pfizer\\_\\d+\\_date")) %>%
    pivot_longer(
      cols = -patient_id,
      names_to = c(NA, "vax_pfizer_index"),
      names_pattern = "^(.*)_(\\d+)_date",
      values_to = "date",
      values_drop_na = TRUE
    ) %>%
    arrange(patient_id, date)

  data_vax_az <- data_processed %>%
    select(patient_id, matches("covid\\_vax\\_az\\_\\d+\\_date")) %>%
    pivot_longer(
      cols = -patient_id,
      names_to = c(NA, "vax_az_index"),
      names_pattern = "^(.*)_(\\d+)_date",
      values_to = "date",
      values_drop_na = TRUE
    ) %>%
    arrange(patient_id, date)

  data_vax_moderna <- data_processed %>%
    select(patient_id, matches("covid\\_vax\\_moderna\\_\\d+\\_date")) %>%
    pivot_longer(
      cols = -patient_id,
      names_to = c(NA, "vax_moderna_index"),
      names_pattern = "^(.*)_(\\d+)_date",
      values_to = "date",
      values_drop_na = TRUE
    ) %>%
    arrange(patient_id, date)


  data_vax <-
  data_vax_pfizer %>%
    full_join(data_vax_az, by=c("patient_id", "date")) %>%
    full_join(data_vax_moderna, by=c("patient_id", "date")) %>%
    mutate(
      type = fct_case_when(
        (!is.na(vax_az_index)) & is.na(vax_pfizer_index) & is.na(vax_moderna_index) ~ "az",
        is.na(vax_az_index) & (!is.na(vax_pfizer_index)) & is.na(vax_moderna_index) ~ "pfizer",
        is.na(vax_az_index) & is.na(vax_pfizer_index) & (!is.na(vax_moderna_index)) ~ "moderna",
        (!is.na(vax_az_index)) + (!is.na(vax_pfizer_index)) + (!is.na(vax_moderna_index)) > 1 ~ "duplicate",
        TRUE ~ NA_character_
      )
    ) %>%
    arrange(patient_id, date) %>%
    group_by(patient_id) %>%
    mutate(
      vax_index=row_number()
    ) %>%
    ungroup()

  data_vax

})

data_vax_wide = data_vax %>%
  pivot_wider(
    id_cols= patient_id,
    names_from = c("vax_index"),
    values_from = c("date", "type"),
    names_glue = "covid_vax_{vax_index}_{.value}"
  )


write_rds(data_vax, here("output", cohort, "data", "data_long_vax_dates.rds"), compress="gz")
write_rds(data_vax_wide, here("output", cohort, "data", "data_wide_vax_dates.rds"), compress="gz")

data_processed <- data_processed %>%
  left_join(data_vax_wide, by ="patient_id")

write_rds(data_processed, here("output", cohort, "data", "data_processed.rds"), compress="gz")
