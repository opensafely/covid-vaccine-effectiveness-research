# Import libraries ----
library('tidyverse')
library('survival')

source(here::here("lib", "redaction_functions.R"))

# import data ----

data_processed <- read_rds(
  here::here("output", "data", "data_processed.rds")
)


redacted_summary_catcat(data_processed$ageband, as.character(data_processed$vaccine_type))



dir.create(here::here("output", "vaccine_type", "tables"), showWarnings = FALSE, recursive=TRUE)

c("sex", "ageband", "imd", "stp", "ethnicity") %>%
  set_names(.) %>%
  map(~{redacted_summary_catcat(data_processed[[.x]], data_processed$vaccine_type)}) %>%
  enframe() %>%
  transmute(
    x=value,
    path=paste0(here::here("output", "vaccine_type", "tables", paste0("vaccine_type_", name, ".csv"))),
    na="-"
  ) %>%
  pwalk(write_csv)
