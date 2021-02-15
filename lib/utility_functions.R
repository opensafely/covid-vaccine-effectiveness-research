


fct_case_when <- function(...) {
  # uses dplyr::case_when but converts the output to a factor,
  # with factors ordered as they appear in the case_when's  ... argument
  args <- as.list(match.call())
  levels <- sapply(args[-1], function(f) f[[3]])  # extract RHS of formula
  levels <- levels[!is.na(levels)]
  factor(dplyr::case_when(...), levels=levels)
}



censor <- function(event_date, censor_date, na.censor=TRUE){
  # censors event_date to on or before censor_date
  # if na.censor = TRUE then returns NA if event_date>censor_date, otherwise returns min(event_date, censor_date)
  if (na.censor)
    dplyr::if_else(event_date>censor_date, as.Date(NA_character_), as.Date(event_date))
  else
    dplyr::if_else(event_date>censor_date, as.Date(censor_date), as.Date(event_date))
}

censor_indicator <- function(event_date, censor_date){
  # returns 0 if event_date is censored by censor_date, or if event_date is NA. Otherwise 1
  dplyr::if_else((event_date>censor_date) | is.na(event_date), FALSE, TRUE)
}

tte <- function(origin_date, event_date, censor_date, na.censor=FALSE){
  # returns time-to-event date or time to censor date, which is earlier

  if (na.censor)
    time <- event_date-origin_date
  else
    time <- pmin(event_date-origin_date, censor_date-origin_date, na.rm=TRUE)
    as.numeric(time)
}



round_tte <- function(time, width=7){
  # group follow-up time to be in periods of size `width`
  # eg, convert to weekly instead of dail with width=7
  # follow-up time of zero is always mapped to zero
  # then first period is mapped to `1`, second period is mapped to `2`, etc
  ceiling(time/width)
}


postvax_cut <- function(event_time, time, breaks, prelabel="pre", prefix=""){

  # this function defines post-vaccination time-periods at `time`,
  # for a vaccination occurring at time `event_time`
  # delimited by `breaks`

  # note, intervals are open on the left and closed on the right
  # so at the exact time point the vaccination occurred, it will be classed as "pre-dose".

  event_time <- as.numeric(event_time)
  event_time <- if_else(!is.na(event_time), event_time, Inf)

  diff <- time - event_time
  breaks_aug <- unique(c(-Inf, breaks, Inf))
  labels0 <- cut(c(breaks, Inf), breaks_aug)
  labels <- paste0(prefix, c(prelabel, as.character(labels0[-1])))
  period <- cut(diff, breaks=breaks_aug, labels=labels, include.lowest=TRUE)


  period
}
