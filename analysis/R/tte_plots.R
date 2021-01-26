# Import libraries ----
library('tidyverse')
library('survival')
library('patchwork')
library('flexsurv')
library('viridis')

# import data ----

data_vaccinated <- read_rds(
  here::here("output", "data", "data_vaccinated.rds")
)

source(here::here("lib", "survival_functions.R"))

# time to readmission or death ##################

survobj <- function(.data, time, indicator, group_vars){

  dat_filtered <- .data %>%
    mutate(
      .time = .data[[time]],
      .indicator = .data[[indicator]]
    ) %>%
    filter(
      !is.na(.time),
      .time>0
    )

  unique_times <- unique(c(dat_filtered[[time]]))

  dat_surv <- dat_filtered %>%
    group_by(across(all_of(group_vars))) %>%
    transmute(
      .time = .data[[time]],
      .indicator = .data[[indicator]]
    )

  if(nrow(dat_surv)==0){
    dat_surv <- tibble(time=0, estimate=NA_real_, std.error=NA_real_, conf.high=NA_real_, conf.low=NA_real_, leadtime=NA_real_)
  } else {

    dat_surv <- dat_surv %>%
      nest() %>%
      mutate(
        surv_obj = map(data, ~survfit(Surv(.time, .indicator) ~ 1, data = .)),
        surv_obj_tidy = map(surv_obj, ~tidy_surv(., times= unique_times)),
        flexsurv_obj = map(data, ~{
          flexsurvspline(
            Surv(.time, .indicator) ~ 1,
            data = .,
            scale="hazard",
            timescale="log",
            k=4
          )
        }),
        flexsurv_obj_tidy = map(flexsurv_obj, ~tidy_flexsurvspline(., times=unique_times)),
        merged = map2(surv_obj_tidy, flexsurv_obj_tidy, ~full_join(.x, .y, by="time"))
      ) %>%
      select(merged) %>%
      unnest(merged)
  }

  dat_surv
}

#surv <- survfit(Surv(tte_seconddose, ind_seconddose) ~ 1, data = data_vaccinated)
#tidy_surv(surv)

survobj(data_vaccinated, "tte_seconddose", "ind_seconddose", group_vars="sex") %>% View()



## select colour_type

get_colour_scales <- function(colour_type = "qual"){

  if(colour_type == "qual"){
    list(
      scale_color_brewer(type="qual", palette="Set3"),
      scale_fill_brewer(type="qual", palette="Set3", guide=FALSE)
      #ggthemes::scale_color_colorblind(),
      #ggthemes::scale_fill_colorblind(guide=FALSE),
      #rcartocolor::scale_color_carto_d(palette = "Safe"),
      #rcartocolor::scale_fill_carto_d(palette = "Safe", guide=FALSE),
      #ggsci::scale_color_simpsons(),
      #ggsci::scale_fill_simpsons(guide=FALSE)
    )
  } else if(colour_type == "cont"){
    list(
      scale_colour_viridis(discrete = FALSE),
      scale_fill_viridis(discrete = FALSE, guide = FALSE)
    )
  } else if(colour_type == "ordinal"){
    list(
      scale_colour_viridis(discrete = TRUE),
      scale_fill_viridis(discrete = TRUE, guide = FALSE)
    )
  } else
    stop("colour_type not supported -- must be qual, cont, or ordinal")
}


plot_surv <- function(.surv_data, colour_var, colour_name, colour_type="qual",  title=""){

  surv_plot <- .surv_data %>%
  ggplot(aes_string(group=colour_var, colour=colour_var, fill=colour_var)) +
  geom_step(aes(x=time, y=1-surv))+
  geom_line(aes(x=time, y=1-smooth_surv), linetype='dotted')+
 # geom_rect(aes(xmin=time, xmax=leadtime, ymin=1-conf.high, ymax=1-conf.low), alpha=0.1, colour="transparent")+
  get_colour_scales(colour_type)+
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


plot_hazard <- function(.surv_data, colour_var, colour_name, colour_type="qual", title=""){


  surv_plot <- .surv_data %>%
    ggplot(aes_string(group=colour_var, colour=colour_var, fill=colour_var)) +
    geom_step(aes(x=time, y=haz_km))+
    geom_line(aes(x=time, y=smooth_haz), linetype='dotted')+
    get_colour_scales(colour_type)+
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
    variable = c("sex"),# "ageband", "ethnicity", "imd", "region"),
    variable_name = c("Sex"),# "Age", "Ethnicity", "IMD", "Region"),
    colour_type = c("qual")#, "ordinal", "qual", "ordinal", "", "qual")
)

metadata_outcomes <- tibble(
    outcome = c("seconddose"#,
                #"posSGSS", "posPC", #"admitted",
                #"coviddeath", "death"
                ),
    outcome_name = c("second dose"#,
                     #"positive SGSS test", "primary care case", #"covid-related admission",
                    # "covid-related death", "death"
                     )
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
      list(survobj, variable, variable_name, colour_type, outcome_name),
      plot_surv
    ),
    plot_hazard = pmap(
      list(survobj, variable, variable_name, colour_type, outcome_name),
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
  summarise(patch_plot = list(plot_surv)) %>%
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
