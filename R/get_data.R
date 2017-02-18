library(gesis)
library(tidyverse)
library(stringr)
library(rio)
library(purrr)

s <- login()
ds <- read_csv("../DCPO/data/new_surveys_data.csv")[8:9,]

pwalk(list(ds$archive, ds$surv_program, ds$doi), function(archive, surv_program, doi) {
    dl_dir <- file.path("../data",
                        paste0(archive, "_files"),
                        paste0(surv_program, "_files"))
    new_dir <- file.path(dl_dir, doi)
    dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
    doi_no <- str_replace(doi, "ZA", "")
    download_dataset(s, doi = doi_no, path = new_dir)
    try(download_codebook(doi = doi_no, path = new_dir))
    data_file <- list.files(path = new_dir) %>% str_subset(".dta") %>% last()
    if(data_file %>% str_detect(".zip$")) {
        unzip(file.path(new_dir, data_file), exdir = new_dir)
        unlink(file.path(new_dir, data_file))
        data_file <- list.files(path = new_dir) %>% str_subset(".dta") %>% last()
    }
    convert(file.path(new_dir, data_file),
            str_replace(file.path(new_dir, data_file), ".dta", ".RData"))
})


# issp
issp_files <- c("1700", "2150", "2620", "3190", "4950", "5690", "5900")
issp_path <- "../data/gesis_files/issp_files"

walk(issp_files, function(doi) {
    new_dir <- file.path(issp_path, paste0("ZA", doi))
    dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
    download_dataset(s, doi = doi, path = new_dir)
    download_codebook(doi = doi, path = new_dir)
    data_file <- list.files(path = new_dir) %>% str_subset(".dta")
    if(data_file %>% str_detect(".zip$")) {
        unzip(file.path(new_dir, data_file), exdir = new_dir)
        unlink(file.path(new_dir, data_file))
        data_file <- list.files(path = new_dir) %>% str_subset(".dta")
    }
    convert(file.path(new_dir, data_file),
            str_replace(file.path(new_dir, data_file), ".dta", ".RData"))
})




