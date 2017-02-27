library(gesis)  #
library(tidyverse)
library(stringr)#
library(rio)    #
library(purrr)  #
library(icpsrdata)
library(pewdata)
library(rvest)
library(RSelenium)

#' @import rio
#' @import icpsrdata
#' @import rvest
#' @import RSelenium
#' @importFrom gesis login download_dataset download_codebook
#' @importFrom stringr str_replace str_subset str_detect
#' @importFrom purrr walk
#' @importFrom haven read_por
#' @importFrom foreign read.spss

s <- login()
ds <- read_csv("data/new_surveys_data.csv")[23,]

walk(seq_len(nrow(ds)), function(i) {
  archive <- ds$archive[i]
  surv_program <- ds$surv_program[i]
  file_id <- ds$file_id[i]
  data_link <- ds$data_link[i]
  cb_link <- ds$cb_link[i]

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
  if (archive=="misc" & file_id!="ess_combo") {
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
})

# Roper Center
# UK Data Service


# Poland GSS
pgss_dir <- "../data/dcpo_surveys/misc_files/pgss_files/pgss"
dir.create(pgss_dir, recursive = TRUE, showWarnings = FALSE)

login_link <- "http://www.ads.org.pl/log.php?id=91"
s <- html_session(login_link)
s1 <- html_form(s)[[1]] %>%
  set_values(log = getOption("ads_login"),
             pas = getOption("ads_password"))
s2 <- submit_form(s, s1) %>%
  jump_to("http://www.ads.org.pl/dnldal.php?id=91&nazwa=P0091SAV.zip")

file_dir <- file.path(pgss_dir, "P0091SAV.zip")
writeBin(httr::content(s2$response, "raw"), file_dir)

unzip(file_dir, exdir = pgss_dir)
unlink(file_dir)
data_file <- list.files(path = pgss_dir) %>%
  str_subset("\\.sav") %>%
  last()
suppressWarnings(
  foreign::read.spss(file.path(pgss_dir, data_file),
                     to.data.frame = TRUE,
                     use.value.labels = FALSE) %>%
    export(paste0(tools::file_path_sans_ext(file.path(pgss_dir, data_file)), ".RData"))
)


# WVS
dl_dir <- file.path("../data/dcpo_surveys",
                    "misc_files",
                    "wvs_files")
new_dir <- file.path(dl_dir, "wvs_combo")
dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
nd_old <- list.files(new_dir)

fprof <- RSelenium::makeFirefoxProfile(list(
  browser.download.dir = file.path(getwd(), new_dir),
  browser.download.folderList = 2L,
  browser.download.manager.showWhenStarting = FALSE,
  browser.helperApps.neverAsk.saveToDisk = "application/x-zip-compressed"))

wvs_page <- "http://www.worldvaluessurvey.org/WVSDocumentationWVL.jsp"
rD <- RSelenium::rsDriver(browser = "firefox", extraCapabilities = fprof)
remDr <- rD[["client"]]
remDr$navigate(wvs_page)
webElem <- remDr$findElement(using = "tag name", "body")
webElem$clickElement()
webElem$sendKeysToElement(list(key = "end"))
elem <- remDr$findElements(using = "tag name", "iframe")
remDr$switchToFrame(elem[[3]])
elem1 <- remDr$findElements(using = "tag name", "iframe")
remDr$switchToFrame(elem1[[1]])
remDr$findElement(using = "link text",
                  "WVS_Longitudinal_1981-2014_stata_dta_v_2015_04_18")$clickElement()
Sys.sleep(3)
remDr$findElement(using = "name", "LINOMBRE")$sendKeysToElement(list(getOption("pew_name")))
remDr$findElement(using = "name", "LIEMPRESA")$sendKeysToElement(list(getOption("pew_org")))
remDr$findElement(using = "name", "LIEMAIL")$sendKeysToElement(list(getOption("pew_email")))
acad_proj <- "a"
remDr$findElement(using = 'xpath', "//select")$sendKeysToElement(list(acad_proj))
webElem <- remDr$findElement(using = "tag name", "body")
webElem$clickElement()
webElem$sendKeysToElement(list(key = "end"))
remDr$findElement(using = "name", "LIAGREE")$clickElement()
remDr$findElement(using = "class", "AJDocumentDownloadBtn")$clickElement()
remDr$acceptAlert()

# check that download has completed
nd_new <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
wait <- TRUE
tryCatch(
  while(all.equal(str_detect(nd_new, "\\.part$"), logical(0))) {
    Sys.sleep(1)
    nd_new <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
  }, error = function(e) 1 )
while(any(str_detect(nd_new, "\\.part$"))) {
  Sys.sleep(1)
  nd_new <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
}

# unzip and convert to .RData
dl_file <- list.files(new_dir, ".zip$")
unzip(file.path(new_dir, dl_file), exdir = new_dir)
unlink(file.path(new_dir, dl_file))
data_file <- list.files(path = new_dir) %>%
  str_subset("\\.dta") %>%
  last()
convert(file.path(new_dir, data_file),
        paste0(tools::file_path_sans_ext(file.path(new_dir, data_file)), ".RData"))

remDr$close()
rD[["server"]]$stop()


# LatinoBarometro
walk2(c(2015, 2013, 2011:2000, 1998:1995), 2:19, function(file_year, li_no) {
    dl_dir <- file.path("../data/dcpo_surveys",
                      "misc_files",
                      "lb_files")
  new_dir <- file.path(dl_dir, paste0("lb", file_year))
  dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
  nd_old <- list.files(new_dir)

  fprof <- RSelenium::makeFirefoxProfile(list(
    browser.download.dir = file.path(getwd(), new_dir),
    browser.download.folderList = 2L,
    browser.download.manager.showWhenStarting = FALSE,
    browser.helperApps.neverAsk.saveToDisk = "application/x-zip-compressed"))

  lb_link <- "http://www.latinobarometro.org/latContents.jsp"
  rD <- RSelenium::rsDriver(browser = "firefox", extraCapabilities = fprof)
  remDr <- rD[["client"]]

  # download file
  remDr$navigate(lb_link)
  remDr$findElement(using = "css selector", "#left_column_content li:nth-child(2) a")$clickElement()
  Sys.sleep(3)
  css_selector <- paste0("li:nth-child(",li_no,") a:nth-child(", 3+(between(li_no, 12, 18)), ")")
  remDr$findElement(using = "css selector", css_selector)$clickElement()
  Sys.sleep(3)
  if (file_year!=2015) {
    remDr$findElement(using = "name", "FANOMBRE")$sendKeysToElement(list(getOption("pew_name")))
    remDr$findElement(using = "name", "FAEMPRESA")$sendKeysToElement(list(getOption("pew_org")))
    remDr$findElement(using = "name", "FAEMAIL")$sendKeysToElement(list(getOption("pew_email")))
    proj_acad <- "p"
    remDr$findElement(using = 'xpath', "//select")$sendKeysToElement(list(proj_acad))
    remDr$findElement(using = "name", "FAAGREE")$clickElement()
    remDr$findElement(using = "class", "LATBoton")$clickElement()
    Sys.sleep(3)
    remDr$findElement(using = "class", "LATBoton")$clickElement()
  }

  # check that download has completed
  nd_new <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
  wait <- TRUE
  tryCatch(
    while(all.equal(str_detect(nd_new, "\\.part$"), logical(0))) {
      Sys.sleep(1)
      nd_new <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
    }, error = function(e) 1 )
  while(any(str_detect(nd_new, "\\.part$"))) {
    Sys.sleep(1)
    nd_new <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
  }

  # unzip and convert to .RData
  dl_file <- list.files(new_dir, ".zip$")
  unzip(file.path(new_dir, dl_file), exdir = new_dir)
  unlink(file.path(new_dir, dl_file))
  data_file <- list.files(path = new_dir) %>%
    str_subset(".*[Ee]ng.*\\.dta") %>%
    last()
  convert(file.path(new_dir, data_file),
          paste0(tools::file_path_sans_ext(file.path(new_dir, data_file)), ".RData"))

  # close session
  remDr$close()
  rD[["server"]]$stop()
})


# ess_combo (last because slooooow site)
dl_dir <- file.path("../data/dcpo_surveys",
                    "misc_files",
                    "ess_files")
new_dir <- file.path(dl_dir, "ess_combo")
dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
nd_old <- list.files(new_dir)

fprof <- RSelenium::makeFirefoxProfile(list(
  browser.download.dir = file.path(getwd(), new_dir),
  browser.download.folderList = 2L,
  browser.download.manager.showWhenStarting = FALSE,
  browser.helperApps.neverAsk.saveToDisk = "application/octet-stream"))

ess_signin <- "http://www.europeansocialsurvey.org/user/login?from=/downloadwizard/"
rD <- RSelenium::rsDriver(browser = "firefox", extraCapabilities = fprof)
remDr <- rD[["client"]]
remDr$navigate(ess_signin)
remDr$findElement(using = "name", "u")$sendKeysToElement(list(getOption("ess_email")))
remDr$findElement(using = "name", "submit")$clickElement()
Sys.sleep(5)

checkboxes <- c(3, 4, 10, 15, 16, 24:27, 30)
walk(checkboxes, function(checkbox) {
  remDr$findElement(using = "id", paste0("VG", checkbox))$clickElement()
})
remDr$findElement(using = "css selector", ".table__stub-center:nth-child(9)")$clickElement()
remDr$findElement(using = "css selector", ".dataset-download:nth-child(2) .button")$clickElement()

# check that download has completed
nd_new <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
wait <- TRUE
tryCatch(
  while(all.equal(str_detect(nd_new, "\\.part$"), logical(0))) {
    Sys.sleep(1)
    nd_new <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
  }, error = function(e) 1 )
while(any(str_detect(nd_new, "\\.part$"))) {
  Sys.sleep(1)
  nd_new <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
}

remDr$close()
rD[["server"]]$stop()

dl_file <- list.files(new_dir, ".zip")
unzip(file.path(new_dir, dl_file), exdir = new_dir)
unlink(file.path(new_dir, dl_file))
data_file <- list.files(path = new_dir) %>%
  str_subset("\\.dta") %>%
  last()
convert(file.path(new_dir, data_file),
        paste0(tools::file_path_sans_ext(file.path(new_dir, data_file)), ".RData"))

# Asia Barometer (2005, 2006, 2007) can't automate--permission to download lasts only 72 hrs
