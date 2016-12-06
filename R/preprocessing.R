library(tidyverse)

library(foreign)
library(haven)
library(reshape2)
library(beepr)
library(rstan)
library(stringr)


datasets_table <- read_csv("data-raw/datasets_table.csv")
gm0 <- read_csv("data-raw/surveys_gm.csv")
gm <- dcpo_setup(gm0)
write_csv(gm, "data/all_data_gm.csv")

gm <- read_csv("data/all_data_gm.csv") %>%
  group_by(ccode) %>%
  mutate(tq = length(unique(paste(tcode, qcode))),
         year_obs = length(unique(tcode))) %>%
  ungroup()
gm_2y <- gm %>%
  filter(year_obs >= 2) %>%
  mutate(ccode = as.numeric(factor(ccode)))
gm_3y <- gm %>%
  filter(year_obs >= 3) %>%
  mutate(ccode = as.numeric(factor(ccode)))


red0 <- read_csv("../Redistribution/data-raw/redist_vars.csv")
red <- dcpo_setup(red0)
write_csv(red, "../Redistribution/data/all_data_red.csv")
