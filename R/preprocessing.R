library(tidyverse)

library(foreign)
library(haven)
library(reshape2)
library(beepr)
library(rstan)
library(stringr)


datasets_table <- read_csv("data-raw/datasets_table.csv")
gm <- dcpo_setup(vars = "data-raw/surveys_gm.csv",
                 file = "data/all_data_gm.csv")

gm <- read_csv("data/all_data_gm.csv")
gm_2y <- gm %>%
  filter(year_obs >= 2) %>%
  mutate(ccode = as.numeric(factor(ccode)))
gm_3y <- gm %>%
  filter(year_obs >= 3) %>%
  mutate(ccode = as.numeric(factor(ccode)))

