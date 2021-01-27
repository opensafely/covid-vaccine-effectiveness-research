library('tidyverse')
library('flexsurv')

tidy_surv <-
  function(
    survfit,
    times = NULL,
    addtimezero=FALSE
  ) {



    mintime <- min(survfit$time)
    timezero <- min(0, mintime-1)


    if (is.null(times)) {
      output <-
        survfit %>%
        broom::tidy() %>%
        transmute(
          time,
          leadtime = lead(time),
          interval = leadtime - time,

          n.risk,
          n.event,
          n.censor,

          sumerand = n.event / ((n.risk - n.event) * n.risk),

          surv=cumprod(1 - n.event / n.risk),
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
    }

    else {

      output <-
        survfit %>%
        broom::tidy() %>%
        complete(
          time = times,
          fill = list(n.event = 0, n.censor = 0)
        ) %>%
        fill(n.risk, .direction = c("up")) %>%
        transmute(
          time,
          leadtime = lead(time),
          interval = leadtime - time,

          n.risk,
          n.event,
          n.censor,

          sumerand = n.event / ((n.risk - n.event) * n.risk),

          surv=cumprod(1 - n.event / n.risk),
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
    }

    if(addtimezero){
      output <- output %>%
        add_row(
          time = timezero,
          leadtime = mintime,
          interval = leadtime-time,
          sumerand=0,

          #estimate=1, std.error=0, conf.high=1, conf.low=1,

          surv=1,
          se.surv_greenwood=0,

          haz_km=0, se.haz_km=0, cml.haz_km=0,
          haz_ac=0, se.haz_ac=0, cml.haz_ac=0,
          .before=1
        )
    }

    return(output)
  }

survobj(data_vaccinated, "tte_seconddose", "ind_seconddose", group_vars="sex") %>% View()



tidy_flexsurvspline <- function(
  flexsurvsplinefit,
  times=NULL,
  addtimezero=FALSE
){

  if(is.null(times)){
    times <- unique(flexsurvsplinefit$data$Y[,"time"])
  }

  if(addtimezero){
    mintime <- min(times)
    timezero <- min(0, mintime-1)
    times <- unique(c(timezero, times))
  }

  sumfs_survival <- setNames(summary(flexsurvsplinefit, type="survival", t=times, tidy=TRUE), c("time", "smooth_surv", "smooth_surv.ll", "smooth_surv.ul"))
  sumfs_hazard <- setNames(summary(flexsurvsplinefit, type="hazard", t=times, tidy=TRUE), c("time", "smooth_haz", "smooth_haz.ll", "smooth_haz.ul"))
  sumfs_cmlhazard <- setNames(summary(flexsurvsplinefit, type="cumhaz", t=times, tidy=TRUE), c("time", "smooth_cml.haz", "smooth_cml.haz.ll", "smooth_cml.haz.ul"))

  output <- reduce(list(sumfs_survival,sumfs_hazard,sumfs_cmlhazard), full_join, by='time')

  return(output)

}