library(readr)
library(dplyr)

library(foreign)
library(haven)
library(reshape2)
library(beepr)
library(rstan)
library(stringr)

library(ggplot2)

datasets_table <- read_csv("data-raw/datasets_table.csv")
gm0 <- read_csv("data-raw/surveys_gm.csv")
gm <- dcpo_setup(gm0)
write_csv(gm, "data/all_data_gm.csv")

gm <- read_csv("data/all_data_gm.csv")
gm_a <- gm %>% filter(cc_rank>=5)

red0 <- read_csv("../Redistribution/data-raw/redist_vars.csv")
red <- dcpo_setup(red0)
write_csv(red, "../Redistribution/data/all_data_red.csv")
