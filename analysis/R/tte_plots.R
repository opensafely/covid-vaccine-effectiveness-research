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

  dat_surv1 <- dat_surv %>%
    nest() %>%
    mutate(
      n_events = map_int(data, ~sum(.x$.indicator, na.rm=TRUE)),
      surv_obj = map(data, ~{
        survfit(Surv(.time, .indicator) ~ 1, data = .x, conf.type="log-log")
      }),
      surv_obj_tidy = map(surv_obj, ~tidy_surv(.x, times= unique_times)),
      flexsurv_obj = map(data, ~{
        possflex <- possibly(flexsurvspline, NA)
        possflex(
          Surv(.time, .indicator) ~ 1,
          data = .x,
          scale="hazard",
          timescale="log",
          k=4
        )
      }),
      flexsurv_obj_tidy = map(flexsurv_obj, ~{
        if(!("flexsurvreg" %in% class(.x))){
          tibble(
            time=0,
            smooth_surv=1, smooth_surv.ll=1, smooth_surv.ul=1,
            smooth_haz=0, smooth_haz.ll=0, smooth_haz.ul=0,
            smooth_cml.haz=0, smooth_cml.haz.ll=0, smooth_cml.haz.ul=0
          )
        } else {
          tidy_flexsurvspline(.x, times=unique_times)
        }
      }),
      merged = map2(surv_obj_tidy, flexsurv_obj_tidy, ~full_join(.x, .y, by="time"))
    ) %>%
    select(merged) %>%
    unnest(merged)

  dat_surv1
}

## select colour type based on variable it maps
get_colour_scales <- function(colour_type = "qual"){

  if(colour_type == "qual"){
    list(
      scale_color_brewer(type="qual", palette="Set1", na.value="grey"),
      scale_fill_brewer(type="qual", palette="Set1", guide=FALSE, na.value="grey")
      #ggthemes::scale_color_colorblind(),
      #ggthemes::scale_fill_colorblind(guide=FALSE),
      #rcartocolor::scale_color_carto_d(palette = "Safe"),
      #rcartocolor::scale_fill_carto_d(palette = "Safe", guide=FALSE),
      #ggsci::scale_color_simpsons(),
      #ggsci::scale_fill_simpsons(guide=FALSE)
    )
  } else if(colour_type == "cont"){
    list(
      viridis::scale_colour_viridis(discrete = FALSE, na.value="grey"),
      viridis::scale_fill_viridis(discrete = FALSE, guide = FALSE, na.value="grey")
    )
  } else if(colour_type == "ordinal"){
    list(
      viridis::scale_colour_viridis(discrete = TRUE, na.value="grey"),
      viridis::scale_fill_viridis(discrete = TRUE, guide = FALSE, na.value="grey")
    )
  } else
    stop("colour_type '", colour_type, "' not supported -- must be 'qual', 'cont', or 'ordinal'")
}

ggplot_surv <- function(.surv_data, colour_var, colour_name, colour_type="qual", smooth=FALSE, ci=FALSE, title=""){

  if(smooth){
    lines <- list(geom_line(aes(x=time, y=1-smooth_surv)))
    if(ci){
      lines <- append(lines, list(geom_ribbon(aes(x=time, ymin=1-smooth_surv.ul, ymax=1-smooth_surv.ll), alpha=0.1, colour="transparent")))
    }
  } else{
    lines <- list(geom_step(aes(x=time, y=1-surv)))
    if(ci){
      lines <- append(lines, list(geom_rect(aes(xmin=time, xmax=leadtime, ymin=1-surv.ul, ymax=1-surv.ll), alpha=0.1, colour="transparent")))
    }
  }

  surv_plot <- .surv_data %>%
  ggplot(aes_string(group=colour_var, colour=colour_var, fill=colour_var)) +
  lines+
  get_colour_scales(colour_type)+
  scale_y_continuous(expand = expansion(mult=c(0,0.01)))+
  labs(
    x="Days",
    y="Cumul. event rate",
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



ggplot_hazard <- function(.surv_data, colour_var, colour_name, colour_type="qual", smooth=FALSE, ci=FALSE, title=""){


  if(smooth){
    lines <- list(geom_line(aes(x=time, y=smooth_haz)))
    if(ci){
      lines <- append(lines, list(geom_ribbon(aes(x=time, ymin=smooth_haz.ll, ymax=smooth_haz.ul), alpha=0.1, colour="transparent")))
    }
  } else{
    lines <- list(geom_step(aes(x=time, y=haz_km)))
    # if(ci){ ## NO EASY SOLUTION FOR CIs FOR HAZARDS JUST YET
    #   lines <- append(lines, list(geom_rect(aes(xmin=time, xmax=leadtime, ymin=haz_km.ll, ymax=haz_km.ul), alpha=0.1, colour="transparent")))
    # }
  }


  surv_plot <- .surv_data %>%
    ggplot(aes_string(group=colour_var, colour=colour_var, fill=colour_var)) +
    lines+
    get_colour_scales(colour_type)+
    scale_y_continuous(expand = expansion(mult=c(0,0.01)))+
    labs(
      x="Days",
      y="Inst. hazard rate",
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


metadata_variables <- tribble(
  ~variable, ~variable_name, ~colour_type,
  "sex", "Sex", "qual",
  "ageband", "Age", "ordinal",
  "ethnicity","Ethnicity", "qual",
  "imd", "IMD", "ordinal",
  "region", "Region", "qual"
)


metadata_outcomes <- tribble(
  ~outcome, ~outcome_name,
  "seconddose", "Second dose",
  "posSGSS",   "Positive PCR test",
  "posPC",     "Primary care case",
  #"admitted",  "covid-related admission",
  "coviddeath","Covid-related death",
  "death",     "All-cause death"
)

metadata_crossed <- crossing(metadata_variables, metadata_outcomes)

# test_data <- data_vaccinated %>%
#  filter(age<=18, tte_posSGSS>0) %>%
#  select(tte_posSGSS, ind_posSGSS, ethnicity)
# test_surv <- survobj(test_data, "tte_posSGSS", "ind_posSGSS", "ethnicity")
#
# ggplot_surv(test_surv, "ethnicity", "ethnicity", "qual", FALSE, TRUE)

plot_combinations <- metadata_crossed %>%
  mutate(
    survobj = pmap(
      list(variable, outcome),
      function(variable, outcome){
        survobj(data_vaccinated, paste0("tte_", outcome), paste0("ind_", outcome), group_vars=c(variable))
      }
    ),
    plot_surv = pmap(
      list(survobj, variable, variable_name, colour_type, smooth=FALSE, ci=FALSE, outcome_name),
      ggplot_surv
    ),
    plot_surv_ci = pmap(
      list(survobj, variable, variable_name, colour_type, smooth=FALSE, ci=TRUE, outcome_name),
      ggplot_surv
    ),
    plot_hazard = pmap(
      list(survobj, variable, variable_name, colour_type, smooth=FALSE, ci=TRUE, outcome_name),
      ggplot_hazard
    ),
    plot_smoothhazard = pmap(
      list(survobj, variable, variable_name, colour_type, smooth=TRUE, ci=FALSE, outcome_name),
      ggplot_hazard
    ),
    plot_smoothhazard_ci = pmap(
      list(survobj, variable, variable_name, colour_type, smooth=TRUE, ci=TRUE, outcome_name),
      ggplot_hazard
    ),
  )


dir.create(here::here("output", "tte", "figures"), showWarnings = FALSE, recursive=TRUE)

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
    plot=plot_surv_ci,
    units = "cm",
    height = 10,
    width = 15,
    limitsize=FALSE,
    filename = str_c("plot_survival_ci_", variable, "_", outcome, ".svg"),
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

plot_combinations %>%
  transmute(
    plot=plot_smoothhazard,
    units = "cm",
    height = 10,
    width = 15,
    limitsize=FALSE,
    filename = str_c("plot_smoothhazard_", variable, "_", outcome, ".svg"),
    path = here::here("output", "tte", "figures"),
  ) %>%
  pwalk(ggsave)

plot_combinations %>%
  transmute(
    plot=plot_smoothhazard_ci,
    units = "cm",
    height = 10,
    width = 15,
    limitsize=FALSE,
    filename = str_c("plot_smoothhazard_ci_", variable, "_", outcome, ".svg"),
    path = here::here("output", "tte", "figures"),
  ) %>%
  pwalk(ggsave)

# patch adverse event rate plots together by variable and save

# plot_combinations %>%
#   filter(outcome != "seconddose") %>%
#   group_by(variable, variable_name) %>%
#   arrange(factor(outcome, levels=c("posSGSS", "posPC", "coviddeath", "death"))) %>%
#   summarise(patch_plot = list(plot_surv)) %>%
#   mutate(
#     patch_plot = map(
#       patch_plot,
#       ~{wrap_plots(.x, ncol=2, guides="collect")}
#     )
#   ) %>%
#   ungroup() %>%
#   transmute(
#     plot=patch_plot,
#     units = "cm",
#     height = 10,
#     width = 15,
#     limitsize=FALSE,
#     filename = str_c("plot_patch_surv_", variable, ".svg"),
#     path = here::here("output", "tte", "figures"),
#   ) %>%
#   pwalk(ggsave)


# patch adverse event hazard plots together by variable and save

# plot_combinations %>%
#   filter(outcome != "seconddose") %>%
#   group_by(variable, variable_name) %>%
#   arrange(factor(outcome, levels=c("posSGSS", "posPC", "coviddeath", "death"))) %>%
#   summarise(patch_plot = list(plot_hazard)) %>%
#   mutate(
#     patch_plot = map(
#       patch_plot,
#       ~{wrap_plots(.x, ncol=2, guides="collect")}
#     )
#   ) %>%
#   ungroup() %>%
#   transmute(
#     plot=patch_plot,
#     units = "cm",
#     height = 10,
#     width = 15,
#     limitsize=FALSE,
#     filename = str_c("plot_patch_hazard_", variable, ".svg"),
#     path = here::here("output", "tte", "figures"),
#   ) %>%
#   pwalk(ggsave)



# patch event rate and hazard rate plots together by variable and save
plot_combinations %>%
  filter(outcome != "seconddose") %>%
  group_by(variable, variable_name) %>%
  arrange(factor(outcome, levels=c("posSGSS", "posPC", "coviddeath", "death"))) %>%
  summarise(
    patch_plot = list(c(plot_surv, plot_hazard))
  ) %>%
  mutate(
    patch_plot = map(
      patch_plot,
      ~{wrap_plots(.x, ncol=2, byrow=FALSE, guides="collect")}
    )
  ) %>%
  ungroup() %>%
  transmute(
    plot=patch_plot,
    units = "cm",
    height = 10,
    width = 15/2,
    scale=2,
    limitsize=FALSE,
    filename = str_c("plot_patch_", variable, ".svg"),
    path = here::here("output", "tte", "figures"),
  ) %>%
  pwalk(ggsave)

