library('tidyverse')


args <- commandArgs(trailingOnly=TRUE)
if(length(args)==0){
  # use for interactive testing
  cohort <- "over80s"

} else{
  cohort <- args[[1]]
}


data_processed <- read_rds(here::here("output", cohort, "data", "data_processed.rds"))

tabout<-capture.output(table("primary care eth"=data_processed$ethnicity, "sus eth"=data_processed$ethnicity_6_sus, useNA='ifany'))
cat(tabout, sep="\n", file = here::here("output", cohort, "data","ethnicity_table.txt"))

tabout<-capture.output(table("primary care eth"=data_processed$ethnicity, "sus eth"=data_processed$ethnicity_6_sus, "combined eth"= data_processed$ethnicity_combined, useNA='ifany'))
cat(tabout, sep="\n", file = here::here("output", cohort, "data","ethnicity_table_combined.txt"))
