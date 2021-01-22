# Import libraries ----
library('tidyverse')
library('survival')
library('patchwork')

# import data ----

data_processed <- read_rds(
  here::here("output", "data", "data_processed.rds")
)

# time to readmission or death ##################

survobj <- function(.data, time, indicator, group_vars){

  dat_surv <- .data %>%
    group_by(across(all_of(group_vars))) %>%
    transmute(
      .time = .data[[time]],
      .indicator = .data[[indicator]]
    ) %>%
    filter(
      !is.na(.time)
    )

  if(nrow(dat_surv)==0){
    dat_surv <- tibble(time=0, estimate=NA_real_, std.error=NA_real_, conf.high=NA_real_, conf.low=NA_real_, leadtime=NA_real_)
  } else {

    dat_surv <- dat_surv %>%
    nest() %>%
    mutate(
      surv_obj = map(data, ~survfit(Surv(.time, .indicator) ~ 1, data = .)),
      surv_obj_tidy = map(surv_obj, ~broom::tidy(.)),
      surv_obj_tidy_augmented = map(surv_obj_tidy, ~add_row(., time=0, estimate=1, std.error=0, conf.high=1, conf.low=1, .before=1))
    ) %>%
    select(surv_obj_tidy_augmented) %>%
    unnest(surv_obj_tidy_augmented) %>%
    mutate(
      leadtime = lead(time, n=1, default = NA)
    )

  }

  dat_surv
}



plot_surv <- function(.surv_data, colour_var, colour_name, title=""){

  surv_plot <- .surv_data %>%
  ggplot(aes_string(group=colour_var, colour=colour_var, fill=colour_var)) +
  geom_step(aes(x=time, y=1-estimate))+
 # geom_rect(aes(xmin=time, xmax=leadtime, ymin=1-conf.high, ymax=1-conf.low), alpha=0.1, colour="transparent")+
  scale_fill_viridis_d(guide=FALSE)+
  scale_colour_viridis_d()+
  scale_y_continuous(expand = expansion(mult=c(0,0.1)))+
  labs(
    x="Days",
    y="Event rate",
    colour=colour_name,
    title=title
  )+
  theme_minimal(base_size=9)+
  theme(
    axis.line.x = element_line(colour = "black"),
    panel.grid.minor.x = element_blank()
  )

  surv_plot
}

survobj(data_processed, "tte_coviddeath", "ind_coviddeath", "stp")

test<-
data_processed %>%
  select(stp, tte_coviddeath, ind_coviddeath) %>%
  group_by(stp) %>%
  nest()

metadata_variables <- tibble(
    variable = c("sex", "ageband", "ethnicity", "imd", "stp"),
    variable_name = c("Sex", "Age", "Ethnicity", "IMD", "STP")
)

metadata_outcomes <- tibble(
    outcome = c("posSGSS", "posPC", #"admitted",
                "coviddeath", "death"),
    outcome_name = c("positive SGSS test", "primary care case", #"covid-related admission",
                     "covid-related death", "death")
)

metadata_crossed <- crossing(metadata_variables, metadata_outcomes)



dir.create(here::here("output", "tte", "figures"), showWarnings = FALSE, recursive=TRUE)

plot_combinations <- metadata_crossed %>%
  mutate(
    survobj = pmap(
      list(variable, outcome),
      function(variable, outcome){
        survobj(data_processed, paste0("tte_", outcome), paste0("ind_", outcome), group_vars=c(variable))
      }
    ),
    plot = pmap(
      list(survobj, variable, variable_name, outcome_name),
      plot_surv
    )
  )

# save individual plots
plot_combinations %>%
  transmute(
    plot,
    units = "cm",
    height = 10,
    width = 15,
    limitsize=FALSE,
    filename = str_c("plot_each_", variable, "_", outcome, ".svg"),
    path = here::here("output", "tte", "figures"),
  ) %>%
  pwalk(ggsave)


# patch plots together by variable and save

plot_combinations %>%
  group_by(variable, variable_name) %>%
  summarise(patch_plot = list(plot)) %>%
  mutate(
    patch_plot = map(
      patch_plot,
      ~{wrap_plots(.x, ncol=2, guides="collect")}
    )
  ) %>%
  ungroup() %>%
  transmute(
    plot=patch_plot,
    units = "cm",
    height = 10,
    width = 15,
    limitsize=FALSE,
    filename = str_c("plot_patch_", variable, ".svg"),
    path = here::here("output", "tte", "figures"),
  ) %>%
  pwalk(ggsave)
