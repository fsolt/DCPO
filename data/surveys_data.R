library(readr)

surveys_data <- read_csv("data/surveys_data.csv")
save(surveys_data, file = "data/surveys_data.rda")


# devtools::use_data(surveys_data, internal = TRUE, overwrite = TRUE)
