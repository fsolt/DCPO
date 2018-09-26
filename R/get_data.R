library(gesis)
library(tidyverse)
library(stringr)
library(rio)
library(purrr)
library(icpsrdata)
library(pewdata)
library(ropercenter)
library(rvest)
library(RSelenium)
library(ukds)
library(essurvey)

#' @import rio
#' @import icpsrdata
#' @import rvest
#' @import RSelenium
#' @importFrom gesis login download_dataset download_codebook
#' @importFrom stringr str_replace str_subset str_detect
#' @importFrom purrr walk
#' @importFrom haven read_por
#' @importFrom foreign read.spss

ds <- read_csv("data/surveys_data.csv", col_types = cols(year = "i", .default = "c"))

s <- gesis::login()
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
    gesis::download_dataset(s, doi = doi, path = new_dir)
    try(gesis::download_codebook(doi = doi, path = new_dir))
    data_file <- list.files(path = new_dir) %>% str_subset(".dta") %>% last()
    if (data_file %>% str_detect(".zip$")) {
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
    icpsrdata::icpsr_download(file_id, download_dir = dl_dir)
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
    pewdata::pew_download(surv_program, file_id, download_dir = dl_dir, delete_zip = FALSE)
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
  misc_special <- c("ess", "pgss", "wvs", "roper_request")
  if (archive=="misc" & !(surv_program %in% misc_special)) {
    new_dir <- file.path(dl_dir, file_id)
    dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
    dl_file <- str_extract(data_link, "[^//]*$")
    download.file(data_link, file.path(new_dir, dl_file))
    if (str_detect(dl_file, "zip$")) {
      unzip(file.path(new_dir, dl_file), exdir = new_dir)
      unlink(file.path(new_dir, list.files(new_dir, ".zip")))
    }
    data_file <- list.files(path = new_dir) %>%
      str_subset("\\.dta") %>%
      last()
    if (is.na(data_file)) {
      data_file <- list.files(path = new_dir) %>%
        str_subset("\\.sav") %>%
        last()
    }
    if (tools::file_ext(data_file)!="") {
      convert(file.path(new_dir, data_file),
              paste0(file.path(new_dir, file_id), ".RData"))
    }
    if (!is.na(cb_link)) {
      download.file(cb_link, file.path(new_dir, paste0(file_id, ".pdf")))
    }
  }
})


# Roper Center
roper_ds <- ds %>%
  filter(archive == "roper")
roper_sp <- roper_ds %>%
  select(surv_program) %>%
  unique() %>%
  unlist()
walk(roper_sp, function(sp) {
  roper_sp_files <- roper_ds %>%
    filter(surv_program == sp) %>%
    select(file_id) %>%
    unlist()
  ropercenter::roper_download(file_id = roper_sp_files,
                              download_dir = file.path("../data/dcpo_surveys/roper_files",
                                                       paste0(sp, "_files")))
  Sys.sleep(5)
})


# Roper ASCII files
roper_ascii_files <- ds %>%
  filter(!is.na(read_ascii_args)) %>%
  pull(file_id)

walk(roper_ascii_files, function(file) {
  ra_ds <- ds %>%
    filter(file_id %in% file)
  file_path <- file.path("../data/dcpo_surveys/roper_files",
                         paste0(ra_ds$surv_program, "_files"),
                         file,
                         paste0(file, ".dat"))
  x <- do.call(read_ascii, eval(parse(text = ra_ds$read_ascii_args)))
  if (!is.na(ra_ds$wt)) {
    x <- x %>%
      mutate(weight0 = as.numeric(weight),
             weight = weight0/mean(weight0))
  }
  export(x, str_replace(file_path, "dat$", "RData"))
})


# UK Data Service
ukds_ds <- ds %>%
  filter(archive == "ukds")
ukds_sp <- ukds_ds %>%
  select(surv_program) %>%
  unique() %>%
  unlist()
walk(ukds_sp, function(sp) {
  ukds_sp_files <- ukds_ds %>%
    filter(surv_program == sp) %>%
    select(file_id) %>%
    unlist()
  ukds::ukds_download(file_id = ukds_sp_files,
                              download_dir = file.path("../data/dcpo_surveys/ukds_files",
                                                       paste0(sp, "_files")))
})

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


# European Social Survey
dl_dir <- file.path("../data/dcpo_surveys",
                    "misc_files",
                    "ess_files")
dir.create(dl_dir, recursive = TRUE, showWarnings = FALSE)
ess_rounds <- essurvey::show_rounds()

walk(ess_rounds, function(round) {
  new_dir <- file.path(dl_dir, paste0("ess", round))
  dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
  suppressWarnings(essurvey::download_rounds(rounds = round, output_dir = dl_dir))
  data_file <- list.files(path = new_dir) %>%
    str_subset("\\.dta") %>%
    last()
  convert(file.path(new_dir,  data_file),
          paste0(tools::file_path_sans_ext(file.path(new_dir, data_file)), ".RData"))
})


# AsiaBarometer (2005, 2006, 2007) can't automate download--permission lasts only 72 hrs
walk(c(2005, 2006, 2007), function(yr) {
  yr_dir <- paste0("../data/dcpo_surveys/misc_files/asiab_files/asiabarometer", yr)
  data_file <- list.files(path = yr_dir) %>%
    str_subset("\\.sav") %>%
    last()
  rio::convert(file.path(yr_dir, data_file),
          paste0(tools::file_path_sans_ext(file.path(yr_dir, data_file)), ".RData"))
})


# CCES
dl_dir <- file.path("../data/dcpo_surveys",
                    "misc_files",
                    "cces_files")

cces_files <- ds %>%
  filter(surv_program == "cces") %>%
  select(file_id, data_link)

pwalk(cces_files, function(file_id, data_link) {
  dir.create(file.path(dl_dir, file_id), recursive = TRUE, showWarnings = FALSE)
  cces_info <- dataverse::get_dataset(data_link)
  cces_ids <- cces_info$files %>%
    janitor::clean_names() %>%
    select(label, id)
  walk2(cces_ids$label, cces_ids$id, function(name, id) {
    name2 <- ifelse(tools::file_ext(name) == "tab", paste0(tools::file_path_sans_ext(name), ".dta"), name)
    f <- dataverse::get_file(file = id, dataset = data_link)
    writeBin(as.vector(f), file.path(dl_dir, file_id, name2))
  })
  data_file <- list.files(path = file.path(cces_dir, file_id)) %>% str_subset("dta") %>% last()
  haven::read_dta(file.path(dl_dir, file_id, data_file), encoding = "latin1") %>%
    export(file.path(dl_dir, file_id, paste0(file_id, ".RData")))
})

# Australian Election Study
dl_dir <- file.path("../data/dcpo_surveys",
                    "misc_files",
                    "aes_files")

aes_page <- "http://www.australianelectionstudy.org/voter_studies.html"
aes_data_links <- read_html(aes_page) %>%
  html_nodes(xpath = "//a[contains(.,'Data (SPSS)')]") %>%
  html_attr("href")
aes_codebook_links <- read_html(aes_page) %>%
  html_nodes(xpath = "//a[contains(.,'Codebook')]") %>%
  html_attr("href")
walk2(aes_data_links, aes_codebook_links, function(data_link, codebook_link) {
  file_id <- data_link %>%
    str_replace("^.*/", "") %>%
    str_replace("\\.sav", "")
  dir.create(file.path(dl_dir, file_id), recursive = TRUE, showWarnings = FALSE)
  dl_data <- html_session(aes_page) %>%
    jump_to(data_link)
  writeBin(httr::content(dl_data$response, "raw"), file.path(dl_dir, file_id, paste0(file_id, ".sav")))

  tryCatch(
    {x <- tryCatch(haven::read_por(file.path(dl_dir, file_id, paste0(file_id, ".sav"))),
                   error = function(e) {
                     foreign::read.spss(file.path(dl_dir, file_id, paste0(file_id, ".sav")),
                                        to.data.frame = TRUE,
                                        use.value.labels = FALSE)
                   })
    save(x, file = file.path(dl_dir, file_id, paste0(file_id, ".RData")))},
    error = function(e) warning(paste("Conversion from .por to .RData failed for", item))
  )

  dl_cb <- html_session(aes_page) %>%
    jump_to(codebook_link)

  pdf_file <- paste0(file_id, "_cb.pdf")
  writeBin(httr::content(dl_cb$response, "raw"), file.path(dl_dir, file_id, pdf_file))
})

# ANPAS (forerunner to AES)
dl_dir <- file.path("../data/dcpo_surveys",
                    "misc_files",
                    "aes_files")
aes_page <- "http://www.australianelectionstudy.org/anpas.html"
aes_data_links <- read_html(aes_page) %>%
  html_nodes(xpath = "//a[contains(.,'Data (SPSS)')]") %>%
  html_attr("href")
aes_codebook_links <- read_html(aes_page) %>%
  html_nodes(xpath = "//a[contains(.,'Codebook')]") %>%
  html_attr("href")
walk2(aes_data_links, aes_codebook_links, function(data_link, codebook_link) {
  file_id <- data_link %>%
    str_replace("^.*/", "") %>%
    str_replace("\\.sav", "")
  dir.create(file.path(dl_dir, file_id), recursive = TRUE, showWarnings = FALSE)
  dl_data <- html_session(aes_page) %>%
    jump_to(data_link)
  writeBin(httr::content(dl_data$response, "raw"), file.path(dl_dir, file_id, paste0(file_id, ".sav")))

  tryCatch(
    {x <- tryCatch(haven::read_por(file.path(dl_dir, file_id, paste0(file_id, ".sav"))),
                   error = function(e) {
                     foreign::read.spss(file.path(dl_dir, file_id, paste0(file_id, ".sav")),
                                        to.data.frame = TRUE,
                                        use.value.labels = FALSE)
                   })
    save(x, file = file.path(dl_dir, file_id, paste0(file_id, ".RData")))},
    error = function(e) warning(paste("Conversion from .por to .RData failed for", item))
  )

  dl_cb <- html_session(aes_page) %>%
    jump_to(codebook_link)

  pdf_file <- paste0(file_id, "_cb.pdf")
  writeBin(httr::content(dl_cb$response, "raw"), file.path(dl_dir, file_id, pdf_file))
})

# Austrian National Election Study 2017 (can't automate download--dataverse)
# https://data.aussda.at/dataset.xhtml?persistentId=doi:10.11587/I7QIYJ
rio::convert("../data/dcpo_surveys/misc_files/autnes_files/autnes2017/10017_da_en_v1_0.dta",
               paste0("../data/dcpo_surveys/misc_files/autnes_files/autnes2017/autnes2017.RData"))


# Roper by Request
roper_request_dir <- "../data/dcpo_surveys/misc_files/roper_request_files"
roper_request_files <- c("GBSSLT1981-CQ792", "GBSSLT1985-CQ958A", "GBSSLT1986-CQ044A", "USAIPOGNS1999-9902009")

walk(roper_request_files, function(file_id) {
  data_file <- list.files(path = file.path(roper_request_dir, file_id)) %>% str_subset("por|sav") %>% last()

  tryCatch(convert(file.path(roper_request_dir, file_id, data_file),
                   file.path(roper_request_dir, file_id, paste0(file_id, ".RData"))),
           error = function(c) suppressWarnings(
             foreign::read.spss(file.path(roper_request_dir, file_id, data_file),
                                to.data.frame = TRUE,
                                use.value.labels = FALSE) %>%
               export(file.path(roper_request_dir, file_id, paste0(file_id, ".RData")))
           ))
})
