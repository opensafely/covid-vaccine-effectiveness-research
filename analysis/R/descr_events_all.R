
## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('lubridate')
library('survival')

## Import custom user functions from lib
source(here("lib", "utility_functions.R"))
source(here("lib", "redaction_functions.R"))

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
} else {
  # use for actions
  removeobs <- TRUE
}


plot_data_over80s <- read_rds(here("output", "over80s", "descriptive", "plots", paste0("vaxcounts12.rds"))) %>% mutate(cohort_descr="80+")
plot_data_in70s <- read_rds(here("output", "in70s", "descriptive", "plots", paste0("vaxcounts12.rds"))) %>% mutate(cohort_descr="70-79")

plot_data <- bind_rows(
  plot_data_over80s,
  plot_data_in70s
)


plot_theme <-
  theme_minimal()+
  theme(
    legend.position = "left",
    panel.border=element_rect(colour='black', fill=NA),
    strip.text.y.right = element_text(angle = 0),
    axis.line.x = element_line(colour = "black"),
    axis.text.x = element_text(angle = 70, vjust = 1, hjust=1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.ticks.x = element_line(colour = 'black')
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

fs::dir_create(here("output", "combined"))

ggsave(
  plot = plot,
  filename = paste0("brandcounts12.svg"),
  path=here("output", "combined"),
  units="cm",
  width = 25,
  height = 25
)


ggsave(
  plot = plot,
  filename = paste0("brandcounts12.png"),
  path=here("output", "combined"),
  units="cm",
  width = 25,
  height = 25
)
