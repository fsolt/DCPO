## code to prepare `demsup_data` dataset goes here
demsup <- read_csv(system.file("extdata", "all_data_demsupport.csv", package = "DCPOtools"))

demsup_data <- format_dcpo(with_min_yrs(demsup, 3),
                           scale_q = "church_21",
                           scale_cp = 2)

usethis::use_data("demsup_data")
