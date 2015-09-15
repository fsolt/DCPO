library(readr)

survey_datasets <- read_csv("data-raw/survey_datasets.csv")

save(survey_datasets, file = "data/survey_datasets.rdata")
