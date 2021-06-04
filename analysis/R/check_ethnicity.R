library('tidyverse')

if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"

} else{
  cohort <- args[[1]]
}


data_all <- read_rds(here::here("output", cohort, "data", "data_all.rds"))

tabout<-capture.output(table("primary care eth"=data_all$ethnicity, "sus eth"=data_all$ethnicity_6_sus, useNA='ifany'))
cat(tabout, sep="\n", file = here::here("output", cohort, "data","ethnicity_table.txt"))

tabout<-capture.output(table("primary care eth"=data_all$ethnicity, "sus eth"=data_all$ethnicity_6_sus, "combined eth"= data_all$ethnicity_combined, useNA='ifany'))
cat(tabout, sep="\n", file = here::here("output", cohort, "data","ethnicity_table_combined.txt"))
