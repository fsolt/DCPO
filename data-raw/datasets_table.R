library(readr)

datasets_table <- read_csv("data-raw/datasets_table.csv")

devtools::use_data(x, mtcars, internal = TRUE)
