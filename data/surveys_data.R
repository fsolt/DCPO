library(readr)

detach("package:DCPO", unload=TRUE)
surveys_data <- read_csv("data/surveys_data.csv")
save(surveys_data, file = "data/surveys_data.rda")
f <- devtools::build(); system(paste0("R CMD INSTALL --build ", f))
library(DCPO)

# devtools::use_data(surveys_data, internal = TRUE, overwrite = TRUE)
