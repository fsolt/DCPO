#' Prepare Data for DCPO
#'
#' \code{dcpo_setup} prepares survey data for use with the \code{dcpo} function.
#'
#' @param vars a data frame (or, optionally, a csv file) of survey items
#' @param datapath path to the directory that houses raw survey datasets
#' @param chime play chime when complete?
#
#' @details \code{dcpo_setup}, when passed a data frame of survey items, collects the
#' responses and formats them for use with the \code{dcpo} function.
#'
#' @return a data frame
#'
#' @import foreign
#' @import haven
#' @import readr
#' @import reshape2
#' @import dplyr
#' @import beepr
#' @import Hmisc::spss.get
#'
#' @export
library(foreign)
library(haven)
library(dplyr)
library(readr)


setwd("C:/Users/Dong/Desktop/Ongoing Project-R/RA-Summer2016/DCPO/data-raw")

#testing the local_cmd command
ae01 <- read_dta("gesis_files/ZA0078/ZA0078_v1-0-1.dta")

#testing the cy_data command:
data_frame(v3 = 1:5,c_dcpo = c("DEUTSCHLAND", "FRANCE", "NEDERLAND", "BELGIQUE", "LUXEMBOURG"), y_dcpo=1962)


#testing the weight command:


