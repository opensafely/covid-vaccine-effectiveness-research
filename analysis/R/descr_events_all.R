
## Import libraries ----
library('tidyverse')
library('lubridate')
library('survival')

## Import custom user functions from lib
source(here::here("lib", "utility_functions.R"))
source(here::here("lib", "redaction_functions.R"))

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
} else {
  # use for actions
  removeobs <- TRUE
}


if(cohort=="over80s"){
  start_date = "2020-12-08"
} else if(cohort=="in70s"){
  start_date= "2021-01-05"
}



plot_data_over80s <- read_rds(here::here("output", "over80s", "descriptive", "plots", paste0("vaxcounts12.rds"))) %>% mutate(cohort_descr="80+")
plot_data_in70s <- read_rds(here::here("output", "in70s", "descriptive", "plots", paste0("vaxcounts12.rds"))) %>% mutate(cohort_descr="70-79")

plot_data <- bind_rows(
  plot_data_over80s,
  plot_data_in70s
)




plot <- plot_data %>%
  ggplot() +
  geom_area(aes(x=date, y=n_per_10000,
                group=group,
                fill=vaxbrand12_status,
                alpha=lastfup_status
  )
  )+
  facet_grid(rows=vars(fct_rev(cohort_descr)))+
  scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"))+
  scale_fill_manual(values=c("#d95f02", "#7570b3", "#9590D3", "#1b9e77",  "#4BBA93"))+
  scale_alpha_manual(values=c(0.9,0.1), breaks=c(0.1))+
  labs(
    x="Date",
    y="Status per 10,000 people",
    colour=NULL,
    fill=NULL,
    alpha=NULL
  ) +
  plot_theme+
  theme(legend.position = "bottom")

ggsave(
  plot = plot,
  filename = paste0("brandcounts12.svg"),
  path=here::here("output"),
  units="cm",
  width = 25,
  height = 25
)


ggsave(
  plot = plot,
  filename = paste0("brandcounts12.png"),
  path=here::here("output"),
  units="cm",
  width = 25,
  height = 25
)
