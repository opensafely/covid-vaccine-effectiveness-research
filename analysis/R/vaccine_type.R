# Import libraries ----
library('tidyverse')
library('survival')

source(here::here("lib", "redaction_functions.R"))

# import data ----

data_vaccinated <- read_rds(
  here::here("output", "data", "data_vaccinated.rds")
)


# crosstabs ----

dir.create(here::here("output", "vaccine_type", "tables"), showWarnings = FALSE, recursive=TRUE)

c("sex", "ageband", "imd", "ethnicity", "region") %>%
  set_names(.) %>%
  map(~{
    redacted_summary_catcat(
      data_vaccinated[[.x]],
      data_vaccinated$vaccine_first_dose_type,
      redaction_threshold = 0L,
      redaction_accuracy=7L
    )
  }) %>%
  enframe() %>%
  transmute(
    x=value,
    path=paste0(here::here("output", "vaccine_type", "tables", paste0("vaccine_type_", name, ".csv"))),
    na="-"
  ) %>%
  pwalk(write_csv)
