# Import libraries ----
library('tidyverse')
library('lubridate')

source(here::here("lib", "redaction_functions.R"))

# Import processed data ----

data_vaccinated <- read_rds(here::here("output", "data", "data_vaccinated.rds"))

#data_vaccinated$empty_date = date(NA)

# output redacted summaries ----

dir.create(here::here("output", "variable_summary"), showWarnings = FALSE, recursive=TRUE)
dir.create(here::here("output", "variable_summary", "tables"), showWarnings = FALSE, recursive=TRUE)

## categorical ----


sumtabs_cat <-
  data_vaccinated %>%
  select(where(is.character), where(is.logical), where(is.factor)) %>%
  map(redacted_summary_cat) %>%
  enframe()

capture.output(
  walk2(sumtabs_cat$value, sumtabs_cat$name, print_cat),
  file = here::here("output", "variable_summary", "categorical.txt"),
  append=FALSE
)

sumtabs_cat %>%
  unnest(value) %>%
  write_csv(path=here::here("output", "variable_summary", "categorical.csv"), na="")

sumtabs_cat %>%
  transmute(
    x=value,
    path=paste0(here::here("output", "variable_summary", "tables", paste0("categorical_", name, ".csv"))),
    na=""
  ) %>%
  pwalk(write_csv)



## continuous ----

sumtabs_num <-
  data_vaccinated %>%
  select(where(~ {!is.logical(.x) & is.numeric(.x) & !is.Date(.x)})) %>%
  map(redacted_summary_num) %>%
  enframe()

capture.output(
  walk2(sumtabs_num$value, sumtabs_num$name, print_num),
  file = here::here("output", "variable_summary", "numeric.txt"),
  append=FALSE
)

data_vaccinated %>%
  select(where(~ {!is.logical(.x) & is.numeric(.x) & !is.Date(.x)})) %>%
  map(redacted_summary_num) %>%
  enframe() %>%
  unnest(value) %>%
  write_csv(path=here::here("output", "variable_summary", "continuous.csv"), na="")

## dates ----



sumtabs_date <-
  data_vaccinated %>%
  select(where(is.Date)) %>%
  map(redacted_summary_date) %>%
  enframe()

capture.output(
  walk2(sumtabs_date$value, sumtabs_date$name, print_num),
  file = here::here("output", "variable_summary", "date.txt"),
  append=FALSE
)

# this doesn't work because date attribute isn't kept for NA vectors in OPENSAFELY version of ??rlang

#sumtabs_date %>%
#  unnest(value) %>%
#  write_csv(path=here::here("output", "variable_summary", "date.csv"), na="")



# summary stats for report ----

# won't been needed when we can run R via notebook

vars_list <- jsonlite::fromJSON(txt=here::here("lib", "global-variables.json"))

summary_stats <- append (
  vars_list,
  list(
    total_vaccinated = sum(!is.na(data_vaccinated$covid_vacc_date)),
    total_vaccinated_oxford = sum(!is.na(data_vaccinated$vaccine_first_dose_type=="Ox/AZ")),
    total_vaccinated_pfizer = sum(!is.na(data_vaccinated$vaccine_first_dose_type=="P/B"))
  )
)

#write_rds(summary_stats, here::here("output", "data_summary", "summary_stats.rds"))

jsonlite::write_json(summary_stats, path=here::here("output", "data_summary", "summary_stats.json"), auto_unbox = TRUE,  pretty=TRUE)



