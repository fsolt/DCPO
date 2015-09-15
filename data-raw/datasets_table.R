library(readr)

datasets_table <- read_csv("data-raw/datasets_table.csv")

devtools::use_data(datasets_table, internal = TRUE)
