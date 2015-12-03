library(readr)
library(dplyr)

library(foreign)
library(haven)
library(reshape2)
library(beepr)
library(rstan)

library(ggplot2)
library(dotwhisker)

datasets_table <- read_csv("data-raw/datasets_table.csv")
gm0 <- read.csv("data-raw/gay_marriage_surveys.csv", as.is = TRUE)
gm <- dcpo_setup(gm0)
write_csv(gm, "data/all_data_gm.csv")

gm <- read_csv("data/all_data_gm.csv")
#gm1 <- gm %>% filter(firstyr!=lastyr)
