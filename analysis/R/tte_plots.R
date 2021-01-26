# Import libraries ----
library('tidyverse')
library('survival')
library('patchwork')

# import data ----

data_vaccinated <- read_rds(
  here::here("output", "data", "data_vaccinated.rds")
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
      surv_obj_tidy_augmented = map(
        surv_obj_tidy,
        ~mutate(
          .,
          leadtime = lead(time, n=1, default = NA),
          interval = leadtime - time,
          sumerand = n.event / ((n.risk - n.event) * n.risk),

          surv=cumprod(1 - n.event / n.risk), # =1-(cml.event/max(n.risk))
          se.surv_greenwood = surv * sqrt(cumsum(sumerand)),

          # kaplan meier hazard estimates
          haz_km = n.event / (n.risk * interval), # =-(surv-lag(surv))/lag(surv)
          cml.haz_km = cumsum(haz_km), # =cumsum(haz_km)
          se.haz_km = haz_km * sqrt((n.risk - n.event) / (n.risk * n.event)),

          # actuarial hazard estimates
          haz_ac = n.event / ((n.risk - (n.censor / 2) - (n.event / 2)) * interval), # =(cml.haz-lag(cml.haz))/interval
          cml.haz_ac = -log(surv), #=cumsum(haz_ac)
          se.haz_ac = (haz_ac * sqrt(1 - (haz_ac * interval / 2)^2)) / sqrt(n.event),

          # log(-log()) scale

          llsurv = log(-log(surv)),
          se.llsurv = sqrt((1 / log(surv)^2) * cumsum(sumerand)),
        )
      ),
      surv_obj_tidy_timezero = map(
        surv_obj_tidy_augmented,
        ~add_row(
          .,
          time=min(0, .$time-1),
          leadtime = min(.$time),
          interval = leadtime-time,
          sumerand=0,
          surv=1,
          se.surv_greenwood=0,
          estimate=1, std.error=0, conf.high=1, conf.low=1,
          haz_km=0, se.haz_km=0, cml.haz_km=0,
          haz_ac=0, se.haz_ac=0, cml.haz_ac=0,
          #se.estimate=0,
          .before=1
        )
      )
    ) %>%
    select(surv_obj_tidy_timezero) %>%
    unnest(surv_obj_tidy_timezero)

  }

  dat_surv
}

survobj(data_vaccinated, "tte_seconddose", "ind_seconddose", group_vars="ageband")


plot_surv <- function(.surv_data, colour_var, colour_name, title=""){

  surv_plot <- .surv_data %>%
  ggplot(aes_string(group=colour_var, colour=colour_var, fill=colour_var)) +
  geom_step(aes(x=time, y=1-surv))+
 # geom_rect(aes(xmin=time, xmax=leadtime, ymin=1-conf.high, ymax=1-conf.low), alpha=0.1, colour="transparent")+
  scale_fill_viridis_d(guide=FALSE)+
  scale_colour_viridis_d()+
  scale_y_continuous(expand = expansion(mult=c(0,0.01)))+
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


plot_hazard <- function(.surv_data, colour_var, colour_name, title=""){

  surv_plot <- .surv_data %>%
    ggplot(aes_string(group=colour_var, colour=colour_var, fill=colour_var)) +
    geom_step(aes(x=time, y=haz_km))+
    geom_step(aes(x=time, y=haz_ac), linetype="dotted")+
    # geom_rect(aes(xmin=time, xmax=leadtime, ymin=1-conf.high, ymax=1-conf.low), alpha=0.1, colour="transparent")+
    scale_fill_viridis_d(guide=FALSE)+
    scale_colour_viridis_d()+
    scale_y_continuous(expand = expansion(mult=c(0,0.01)))+
    labs(
      x="Days",
      y="Hazard rate",
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



metadata_variables <- tibble(
    variable = c("sex", "ageband", "ethnicity", "imd", "region"),
    variable_name = c("Sex", "Age", "Ethnicity", "IMD", "Region")
)

metadata_outcomes <- tibble(
    outcome = c("seconddose", "posSGSS", "posPC", #"admitted",
                "coviddeath", "death"),
    outcome_name = c("second dose", "positive SGSS test", "primary care case", #"covid-related admission",
                     "covid-related death", "death")
)

metadata_crossed <- crossing(metadata_variables, metadata_outcomes)



dir.create(here::here("output", "tte", "figures"), showWarnings = FALSE, recursive=TRUE)

plot_combinations <- metadata_crossed %>%
  mutate(
    survobj = pmap(
      list(variable, outcome),
      function(variable, outcome){
        survobj(data_vaccinated, paste0("tte_", outcome), paste0("ind_", outcome), group_vars=c(variable))
      }
    ),
    plot_surv = pmap(
      list(survobj, variable, variable_name, outcome_name),
      plot_surv
    ),
    plot_hazard = pmap(
      list(survobj, variable, variable_name, outcome_name),
      plot_hazard
    )
  )

# save individual plots
plot_combinations %>%
  transmute(
    plot=plot_surv,
    units = "cm",
    height = 10,
    width = 15,
    limitsize=FALSE,
    filename = str_c("plot_survival_", variable, "_", outcome, ".svg"),
    path = here::here("output", "tte", "figures"),
  ) %>%
  pwalk(ggsave)

plot_combinations %>%
  transmute(
    plot=plot_hazard,
    units = "cm",
    height = 10,
    width = 15,
    limitsize=FALSE,
    filename = str_c("plot_hazard_", variable, "_", outcome, ".svg"),
    path = here::here("output", "tte", "figures"),
  ) %>%
  pwalk(ggsave)


# patch adverse event plots together by variable and save

plot_combinations %>%
  filter(outcome != "seconddose") %>%
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
