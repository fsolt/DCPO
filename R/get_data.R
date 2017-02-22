library(gesis)  #
library(tidyverse)
library(stringr)#
library(rio)    #
library(purrr)  #
library(icpsrdata)
library(pewdata)

#' @import rio
#' @import icpsrdata
#' @importFrom gesis login download_dataset download_codebook
#' @importFrom stringr str_replace str_subset str_detect
#' @importFrom purrr pwalk
#' @importFrom haven read_por

s <- login()
ds <- read_csv("data/new_surveys_data.csv")

pwalk(list(ds$archive, ds$surv_program, ds$file_id), function(archive, surv_program, file_id) {
  dl_dir <- file.path("../data/dcpo_surveys",
                      paste0(archive, "_files"),
                      paste0(surv_program, "_files"))
  if (archive=="gesis") {
    new_dir <- file.path(dl_dir, file_id)
    dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
    doi <- str_replace(file_id, "ZA", "")
    download_dataset(s, doi = doi, path = new_dir)
    try(download_codebook(doi = doi, path = new_dir))
    data_file <- list.files(path = new_dir) %>% str_subset(".dta") %>% last()
    if(data_file %>% str_detect(".zip$")) {
      unzip(file.path(new_dir, data_file), exdir = new_dir)
      unlink(file.path(new_dir, data_file))
      data_file <- list.files(path = new_dir) %>%
        str_subset(".dta") %>%
        last()
    }
    convert(file.path(new_dir, data_file),
            str_replace(file.path(new_dir, data_file), ".dta", ".RData"))
  } # end gesis
  if (archive=="icpsr") {
    file_id <- file_id %>% str_replace("ICPSR_", "") %>% as.numeric(file_id)
    icpsr_download(file_id, download_dir = dl_dir)
    new_dir <- file.path(dl_dir, paste0("ICPSR_", file_id %>% sprintf("%05d", .)))
    new_dir2 <- file.path(dl_dir, paste0("ICPSR_", file_id %>% sprintf("%05d", .)), "DS0001")
    data_file <- list.files(path = new_dir2) %>% str_subset(".dta") %>% last()
    if (is.na(data_file)) {
      data_file <- list.files(path = new_dir2) %>%
        str_subset(".por") %>%
        last()
    }
    if (str_detect(data_file, ".por")) {
      # workaround for rio bug importing .por
      haven::read_por(file.path(new_dir2, data_file)) %>%
        export(str_replace(file.path(new_dir, data_file), ".por", ".RData"))
    } else {
      convert(file.path(new_dir2, data_file),
              str_replace(file.path(new_dir, data_file), ".dta", ".RData"))
    }
  } # end icpsr
  if (archive=="pew") {
    dir.create(dl_dir, recursive = TRUE, showWarnings = FALSE)
    old_files <- list.files(dl_dir)
    pew_download(surv_program, file_id, download_dir = dl_dir, delete_zip = FALSE)
    new_dir <- list.files(dl_dir, ".zip")[!list.files(dl_dir, ".zip") %in% old_files] %>%
      str_replace(".zip", "")
    unlink(file.path(dl_dir, list.files(dl_dir, ".zip")[!list.files(dl_dir, ".zip") %in% old_files]))
    t <- file.rename(file.path(dl_dir, new_dir), file.path(dl_dir, file_id))
    data_file <- list.files(path = file.path(dl_dir, file_id)) %>%
      str_subset(".sav") %>%
      last()
    tryCatch(convert(file.path(dl_dir, file_id, data_file),
                     file.path(dl_dir, file_id, paste0(file_id, ".RData"))),
             error = function(c) suppressWarnings(
               foreign::read.spss(file.path(dl_dir, file_id, data_file),
                                                    to.data.frame = TRUE,
                                                    use.value.labels = FALSE) %>%
               export(file.path(dl_dir, file_id, paste0(file_id, ".RData")))
             )
    )
  } #end pew
})

