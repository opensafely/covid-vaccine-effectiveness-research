# Import libraries ----
library('tidyverse')
library('survival')

source(here::here("lib", "redaction_functions.R"))

# import data ----

data_vaccinated <- read_rds(
  here::here("output", "data", "data_vaccinated.rds")
)


# 30-day event rates ----


eventrate_table_1 <- function(data, outcome, variable, days=30L){

  dat <- data %>%
    filter(tte_end >= days)

  tab <- redacted_summary_catcat(
    as.character((dat[[paste0("tte_", outcome)]] <= days)*dat[[paste0("ind_", outcome)]]),
    dat[[variable]]
  ) %>%
    filter(.level1=="1") %>%
  select(
    .level2, n, pct
  )

  names(tab) <- c(variable, glue::glue("{outcome}_n"), glue::glue("{outcome}_%"))

  tab
}

eventrate_table_all <- function(data, variable, days=30L){

  total_followup <- data %>%
    filter(tte_end >= days) %>%
    {redacted_summary_cat(.[[variable]])} %>%
    select(.level, n) %>%
    set_names(c(variable, "n"))

  list(
    total_followup,
    eventrate_table_1(data, "seconddose", variable, days),
    eventrate_table_1(data, "posPC", variable, days),
    eventrate_table_1(data, "posSGSS", variable, days),
    eventrate_table_1(data, "admitted", variable, days),
    eventrate_table_1(data, "coviddeath", variable, days),
    eventrate_table_1(data, "death", variable, days)
  ) %>%
  reduce(full_join, by=variable)

}


# output tables ----

dir.create(here::here("output", "tte", "tables"), showWarnings = FALSE, recursive=TRUE)

c("sex", "ageband", "imd", "ethnicity", "region") %>%
  set_names(.) %>%
  map(~{eventrate_table_all(data_vaccinated, ., 7)}) %>%
  enframe() %>%
  transmute(
    x=value,
    path=paste0(here::here("output", "tte", "tables", paste0("event_rates_at_7days_", name, ".csv"))),
    na="-"
  ) %>%
  pwalk(write_csv)

