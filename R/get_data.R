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

# AmericasBarometer
amb_dir <- "../data/dcpo_surveys/misc_files/amb_files/amb_combo"
dir.create(amb_dir, recursive = TRUE, showWarnings = FALSE)
amb_data_link <- "http://datasets.americasbarometer.org/datasets/746278534AmericasBarometer%20Grand%20Merge%202004-2014%20v3.0_FREE_dta.zip"
download.file(amb_data_link, file.path(amb_dir, "amb_combo.dta.zip"))
unzip(file.path(amb_dir, "amb_combo.dta.zip"), exdir = amb_dir)
unlink(file.path(amb_dir, list.files(amb_dir, ".zip")))
convert(file.path(amb_dir, "AmericasBarometer Grand Merge 2004-2014 v3.0_FREE.dta"),
        file.path(amb_dir, "amb_combo.RData"))
amb_cb_link <- "http://datasets.americasbarometer.org/datasets/12364388022004-2014%20Grand%20Merge%20Codebook_V3.0_Free_W.pdf"
download.file(amb_cb_link, file.path(amb_dir, "amb_combo.pdf"))

# Asia Barometer

# LatinoBarometro
# Poland GSS
pgss_dir <- "../data/dcpo_surveys/misc_files/pgss_files/pgss"
dir.create(pgss_dir, recursive = TRUE, showWarnings = FALSE)
pgss_data_link <- "http://www.ads.org.pl/dnldal.php?id=91&nazwa=P0091SAV.zip"
download.file(pgss_data_link, file.path(pgss_dir, "pgss.sav.zip"))
  # need to login first
# Roper Center
# UK Data Service
# WVS

### ESS (email login, slooooow site, probably should be last)
# combo
# SA

get_misc_no_id <- function(data_link, cb_link) {
  new_dir <- file.path(dl_dir, file_id)
  dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
  dl_file <- str_extract(data_link, "[^//]*$")
  download.file(data_link, file.path(new_dir, dl_file))
  unzip(file.path(new_dir, dl_file), exdir = new_dir)
  unlink(file.path(new_dir, list.files(new_dir, ".zip")))
  data_file <- list.files(path = new_dir) %>%
    str_subset("\\.dta") %>%
    last()
  if (is.na(data_file)) {
    data_file <- list.files(path = new_dir) %>%
      str_subset("\\.sav") %>%
      last()
  }
  convert(file.path(new_dir, data_file),
          paste0(tools::file_path_sans_ext(file.path(new_dir, data_file)), ".RData"))
  download.file(cb_link, file.path(new_dir, paste0(file_id, ".pdf")))
}

sasas2014_dir <- "../data/dcpo_surveys/misc_files/ess_files/sasas2014"
dir.create(sasas2014_dir, recursive = TRUE, showWarnings = FALSE)
sasas2014_data_link <- "http://www.europeansocialsurvey.org/docs/related_studies/SASAS_2014/SASAS14_e01.stata.zip"
download.file(sasas2014_data_link, file.path(sasas2014_dir, "sasas2014.zip"))
unzip(file.path(sasas2014_dir, "sasas2014.zip"), exdir = sasas2014_dir)
unlink(file.path(sasas2014_dir, list.files(sasas2014_dir, ".zip")))
data_file <- list.files(path = sasas2014_dir) %>%
  str_subset(".dta") %>%
  last()
convert(file.path(sasas2014_dir, data_file),
        str_replace(file.path(sasas2014_dir, data_file), ".dta", ".RData"))
sasas2014_cb_link <- "http://www.europeansocialsurvey.org/docs/related_studies/SASAS_2014/sasas2014_questionnaire_q2.pdf"
download.file(sasas2014_cb_link, file.path(sasas2014_dir, "sasas2014.pdf"))


# Russia

