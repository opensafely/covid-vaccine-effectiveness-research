
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
  theme_bw(base_size = 12)+
  theme(
    legend.position = "left",
    
    panel.border=element_rect(colour='black', fill=NA),
    
    strip.background = element_blank(),
    # strip.text.y.right = element_text(angle = 0),
    
    axis.line.x = element_line(colour = "black"),
    axis.text.x = element_text(angle = 70, vjust = 1, hjust=1),
    
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    
    axis.ticks.x = element_line(colour = 'black')
  )

colour_palette <- c(
  "Not vaccinated" = "#f7f7f7", # light grey
  "BNT162b2\ndose 1" = "#e78ac3", # medium pink / medium grey
  "BNT162b2\ndose 2" = "#e7298a", # dark pink / dark grey
  "ChAdOx1\ndose 1" = "#8da0cb", # medium purple / medium grey
  "ChAdOx1\ndose 2" = "#7570b3" # dark purple / dark grey
)


annotation_data <- tribble(
  ~cohort_descr, ~vaxbrand12_status, ~x_pos, ~y_pos,
  "80+ years", "Not vaccinated", "2020-12-28", 7500,
  "80+ years", "BNT162b2\ndose 1", "2021-03-15", 5000,
  "80+ years", "BNT162b2\ndose 2", "2021-04-05", 2500,
  "80+ years", "ChAdOx1\ndose 1", "2021-03-15", 1250,
  "80+ years", "ChAdOx1\ndose 2", "2021-04-05", 500,
  "70-79 years", "Not vaccinated", "2021-01-25", 7500,
  "70-79 years", "BNT162b2\ndose 1","2021-03-15", 5000,
  "70-79 years", "BNT162b2\ndose 2","2021-04-05",2500,
  "70-79 years", "ChAdOx1\ndose 1","2021-03-15", 1250,
  "70-79 years", "ChAdOx1\ndose 2","2021-04-05",500
) %>%
  mutate(across(x_pos, as.Date)) 

plot <- plot_data %>%
  group_by(date, vaxbrand12_status, cohort_descr) %>%
  summarise(across(n_per_10000, sum)) %>%
  ungroup() %>%
  mutate(across(cohort_descr, ~str_c(.x, " years"))) %>%
  ggplot() +
  geom_area(aes(x=date, y=n_per_10000,
                group=vaxbrand12_status,
                fill=vaxbrand12_status,
                # alpha=lastfup_status,
  ),
  colour="black"
  # outline.type = "full"
  )+
  geom_text(data=annotation_data, aes(x=x_pos,y=y_pos,label=vaxbrand12_status))+
  facet_wrap(vars(fct_rev(cohort_descr)), ncol = 1)+
  # facet_grid(rows=vars(fct_rev(cohort_descr)))+
  scale_x_date(date_breaks = "1 week", labels = scales::date_format("%Y-%m-%d"), expand = c(0,0))+
  scale_y_continuous(expand=c(0,0)) +
  scale_fill_manual(values=colour_palette)+
  # scale_alpha_manual(values=c(0.9,0.1), breaks=c(0.1))+
  labs(
    x="Date",
    y="Status per 10,000 people",
    colour=NULL,
    fill=NULL,
    alpha=NULL
  ) +
  plot_theme+
  theme(legend.position = "none")

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
