
library('tidyverse')
library("flexsurv")


vignette('flexsurv')
head(bc, 2)

fs1 <- flexsurvspline(
  Surv(recyrs, censrec) ~ 1, data = bc,
  scale="hazard",
  timescale="log",
  k=4
)

times <- unique(fs1$data$Y[,"time"])

mintime <- min(times)
timezero <- min(0, mintime-1)
times <- unique(c(timezero, times))

sumfs_survival <- setNames(summary(fs1, type="survival", t=times, tidy=TRUE), c("time", "smooth_surv", "smooth_surv.ll", "smooth_surv.ul"))
sumfs_hazard <- setNames(summary(fs1, type="hazard", t=times, tidy=TRUE), c("time", "smooth_haz", "smooth_haz.ll", "smooth_haz.ul"))
sumfs_cmlhazard <- setNames(summary(fs1, type="cumhaz", t=times, tidy=TRUE), c("time", "smooth_cml.haz", "smooth_cml.haz.ll", "smooth_cml.haz.ul"))

output <- reduce(list(sumfs_survival,sumfs_hazard,sumfs_cmlhazard), full_join, by='time')


tidy_flexsurvspline(fs1)

surv <- survfit(Surv(recyrs, censrec) ~ group, data = bc)






surv$time

summary(fs1, type="survival", tidy=TRUE)

sumfs_survival <- setNames(summary(fs1, type="survival", tidy=TRUE), c("time", "smooth_surv", "smooth_surv.ll", "smooth_surv.ul"))
sumfs_hazard <- setNames(summary(fs1, type="hazard")[[1]], c("time", "smooth_haz", "smooth_haz.ll", "smooth_haz.ul"))
sumfs_cmlhazard <- setNames(summary(fs1, type="cumhaz")[[1]], c("time", "smooth_cml.haz", "smooth_cml.haz.ll", "smooth_cml.haz.ul"))

tab <- reduce(list(sumfs_survival,sumfs_hazard,sumfs_cmlhazard), full_join, by='time')

sumfs_survival <- setNames(summary(fs1, type="survival", t=0:10)[[1]], c("time", "smooth_surv", "smooth_surv.ll", "smooth_surv.ul"))
sumfs_hazard <- setNames(summary(fs1, type="hazard", t=0:10)[[1]], c("time", "smooth_haz", "smooth_haz.ll", "smooth_haz.ul"))
sumfs_cmlhazard <- setNames(summary(fs1, type="cumhaz", t=0:10)[[1]], c("time", "smooth_cml.haz", "smooth_cml.haz.ll", "smooth_cml.haz.ul"))

tab <- reduce(list(sumfs_survival,sumfs_hazard,sumfs_cmlhazard), full_join, by='time')


sumfs1

sumfs1$time

ggplot(sumfs1) +
  geom_line(aes(x=time, y=est))



plot(fs1)
class(fs1)

plot(fs1, )

lines(fs1)

str(fs1)
model.frame(fs1) %>% View()
plot(fs1, type='hazard')
plot(fs1, est=TRUE)





