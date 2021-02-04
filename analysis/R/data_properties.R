# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)

rds_file <- args[[1]]
output_dir <- args[[2]]

rds_file <- "output/data/data_vaccinated.rds"
output_dir <- "output/data_properties"

stopifnot("must pass an .rds file" = fs::path_ext(rds_file)=="rds")
#stopifnot("must pass a valid output directory" = fs::is_dir(output_dir))

filenamebase <- fs::path_ext_remove(fs::path_file(rds_file))

# Import processed data ----

data <- readr::read_rds(here::here(rds_file))

# Output summary .txt ----

options(width=200) # set output width for capture.output

dir.create(here::here(output_dir), showWarnings = FALSE, recursive=TRUE)

capture.output(skimr::skim_without_charts(data), file = here::here(output_dir, paste0(filenamebase, "_colsummary", ".txt")), split=FALSE)
capture.output(lapply(data, class), file = here::here(output_dir, paste0(filenamebase, "_coltypes", ".txt")))

