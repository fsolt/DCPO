#' Get Survey Datasets for DCPO
#'
#' \code{get_surveys} downloads the survey datasets to be used to estimate public opinion across countries and over time
#'
#' @param vars a data frame (or, optionally, a vector of survey names or a .csv file) of survey items
#' @param datapath path to the directory that will house the raw survey datasets
#' @param chime play chime when complete?
#
#' @details \code{get_surveys}, when passed a data frame of survey items, downloads the
#' source survey datasets, converts them to .RData format, and saves them to a specified
#' directory for later use by \code{dcpo_setup}.  When constructing a list of surveys, one
#' should be use the name employed in \code{DCPO}'s built-in \code{surveys_data} database:
#' \code{View(surveys_data)}.
#'
#' @return the function downloads datasets
#'
#' @import icpsrdata
#' @import pewdata
#' @import ropercenter
#' @import rvest
#' @import RSelenium
#' @importFrom rio convert export
#' @importFrom gesis login download_dataset download_codebook
#' @importFrom stringr str_replace str_subset str_detect
#' @importFrom essurvey download_rounds
#' @importFrom dataverse get_dataset get_file
#' @importFrom purrr walk walk2 pwalk
#' @importFrom haven read_por
#' @importFrom foreign read.spss
#' @importFrom tools file_ext file_path_sans_ext
#'
#' @export

get_surveys <- function(vars,
                        datapath = "../data/dcpo_surveys",
                        file = "",
                        chime = TRUE) {
  if ("data.frame" %in% class(vars)) {
    vars_table <- vars
  } else if (file.exists(vars)) {
    vars_table <- readr::read_csv(vars, col_types = "cccc")
  } else {
    vars_table <- tibble(survey = vars)
  }

  ds <- surveys_data %>%
    filter(survey %in% vars_table$survey) %>%
    mutate(dl_dir = file.path(datapath,
                              paste0(archive, "_files"),
                              paste0(surv_program, "_files")),
           new_dir = file.path(dl_dir, file_id),
           file_exists = list.files(path = new_dir) %>%
             str_subset(".RData") %>%
             length() > 0) %>%
    filter(!file_exists)

  # Gesis
  gesis_ds <- ds %>%
    filter(archive == "gesis")
  if (nrow(gesis_ds) > 0) {
    s <- gesis::login()
    pwalk(gesis_ds, function(file_id, new_dir, ...) {
      dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
      doi <- str_replace(file_id, "ZA", "")
      tryCatch(gesis::download_dataset(s, doi = doi, path = new_dir),
               error = function(c) {
                 gesis::download_dataset(s, doi = doi, path = new_dir, filetype = ".zip")
                 zip_file <- list.files(path = new_dir) %>% str_subset(".zip") %>% last()
                 unzip(file.path(new_dir, zip_file), exdir = new_dir)
                 unlink(file.path(new_dir, zip_file))
               }
      )
      try(gesis::download_codebook(doi = doi, path = new_dir))
      data_file <- list.files(path = new_dir) %>% str_subset(".dta") %>% last()
      if (data_file %>% str_detect(".zip$")) {
        unzip(file.path(new_dir, data_file), exdir = new_dir)
        unlink(file.path(new_dir, data_file))
        data_file <- list.files(path = new_dir) %>%
          str_subset(".dta") %>%
          last()
      }
      rio::convert(file.path(new_dir, data_file),
                   str_replace(file.path(new_dir, data_file), ".dta", ".RData"))
    })
  }

  # ICPSR
  icpsr_ds <- ds %>%
    filter(archive == "icpsr")
  if (nrow(icpsr_ds) > 0) {
    pwalk(gesis_ds, function(file_id, dl_dir, read_ascii_args, wt, ...) {
      icpsr_id <- file_id %>% str_replace("ICPSR_", "") %>% as.numeric(file_id)
      icpsrdata::icpsr_download(icpsr_id, download_dir = dl_dir)
      new_dir <- file.path(dl_dir, paste0("ICPSR_", file_id %>% sprintf("%05d", .)))
      new_dir2 <- file.path(dl_dir, paste0("ICPSR_", file_id %>% sprintf("%05d", .)), "DS0001")
      data_file <- list.files(path = new_dir2) %>% str_subset("\\.dta") %>% last()
      if (is.na(data_file)) {
        data_file <- list.files(path = new_dir2) %>%
          str_subset("\\.por") %>%
          last()
      }
      if (is.na(data_file)) {
        data_file <- list.files(path = new_dir2) %>%
          str_subset("\\.txt") %>%
          last()
        file_path <- file.path(new_dir2, data_file)
        x <- do.call(ropercenter::read_ascii, eval(parse(text = read_ascii_args)))
        if (!is.na(wt)) {
          x <- x %>%
            mutate(weight0 = as.numeric(weight %>% stringr::str_trim()),
                   weight = weight0/mean(weight0))
        }
        rio::export(x, file.path(new_dir, str_replace(data_file, "txt$", "RData")))
      }
      if (str_detect(data_file, ".por")) {
        # workaround for rio bug importing .por
        haven::read_por(file.path(new_dir2, data_file)) %>%
          rio::export(str_replace(file.path(new_dir, data_file), ".por", ".RData"))
      } else {
        tryCatch(rio::convert(file.path(new_dir2, data_file),
                              str_replace(file.path(new_dir, data_file), ".por", ".RData")),
                 error = function(c) suppressWarnings(
                   foreign::read.dta(file.path(new_dir2, data_file),
                                     convert.factors = FALSE) %>%
                     rio::export(str_replace(file.path(new_dir, data_file), ".dta", ".RData"))
                 )
        )
      }
    })
  }

  # Pew
  pew_ds <- ds %>%
    filter(archive == "pew")
  if (nrow(pew_ds) > 0) {
    pew_sp <- pew_ds %>%
      select(surv_program) %>%
      unique() %>%
      unlist()
    walk(pew_sp, function(sp) {
      pew_sp_files <- pew_ds %>%
        filter(surv_program == sp) %>%
        select(file_id) %>%
        unlist()
      pewdata::pew_download(area = sp,
                            file_id = pew_sp_files,
                            download_dir = file.path(datapath,
                                                     "pew_files",
                                                     paste0(sp, "_files")))
      Sys.sleep(2)
    })
  }

  # Roper Center
  roper_ds <- ds %>%
    filter(archive == "roper")
  if (nrow(roper_ds) > 0) {
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
      Sys.sleep(2)
    })
  }

  # Roper ASCII files
  roper_ascii_files <- roper_ds %>%
    filter(!is.na(read_ascii_args)) %>%
    pull(file_id)
  if (nrow(roper_ascii_files) > 0) {
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
          mutate(weight0 = as.numeric(weight %>% stringr::str_trim()),
                 weight = weight0/mean(weight0))
      }
      rio::export(x, str_replace(file_path, "dat$", "RData"))
    })
  }

  # European Social Survey
  ess_ds <- ds %>%
    filter(surv_program == "ess" & is.na(data_link))
  if (nrow(ess_ds) > 0) {
    pwalk(ess_ds, function(survey, new_dir, dl_dir, ...) {
      dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
      suppressWarnings(essurvey::download_rounds(rounds = str_extract(survey, "\\d+"),
                                                 output_dir = dl_dir))
      data_file <- list.files(path = new_dir) %>%
        str_subset("\\.dta") %>%
        last()
      rio::convert(file.path(new_dir,  data_file),
                   paste0(tools::file_path_sans_ext(file.path(new_dir, data_file)), ".RData"))
    })
  }

  # Dataverse
  dataverse_ds <- ds %>%
    filter(archive == "dataverse")
  if (nrow(dataverse_ds) > 0) {
    pwalk(dataverse_ds, function(file_id, data_link, new_dir, ...) {
      dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
      dataverse_info <- dataverse::get_dataset(data_link)
      dataverse_ids <- dataverse_info$files %>%
        janitor::clean_names() %>%
        select(label, id)
      walk2(dataverse_ids$label, dataverse_ids$id, function(name, id) {
        name2 <- ifelse(tools::file_ext(name) == "tab", paste0(tools::file_path_sans_ext(name), ".dta"), name)
        f <- dataverse::get_file(file = id, dataset = data_link)
        writeBin(as.vector(f), file.path(new_dir, name2))
      })
      data_file <- list.files(path = new_dir) %>% str_subset("dta") %>% last()
      haven::read_dta(file.path(new_dir, data_file), encoding = "latin1") %>%
        rio::export(file.path(new_dir, paste0(file_id, ".RData")))
    })
  }

  # Misc
  misc_ds <- ds %>%
    filter(archive == "misc" & !(is.na(data_link)))
  if (nrow(misc_ds > 0)) {
    pwalk(misc_ds, function(new_dir, data_link, cb_link, ...) {
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
      if (tools::file_ext(data_file) != "") {
        rio::convert(file.path(new_dir, data_file),
                     paste0(file.path(new_dir, file_id), ".RData"))
      }
      if (!is.na(cb_link)) {
        download.file(cb_link, file.path(new_dir, paste0(file_id, ".pdf")))
      }
    })
  }

# UK Data Service
# ukds_ds <- ds %>%
#   filter(archive == "ukds")
# ukds_sp <- ukds_ds %>%
#   select(surv_program) %>%
#   unique() %>%
#   unlist()
# walk(ukds_sp, function(sp) {
#   ukds_sp_files <- ukds_ds %>%
#     filter(surv_program == sp) %>%
#     select(file_id) %>%
#     unlist()
#   ukds::ukds_download(file_id = ukds_sp_files,
#                               download_dir = file.path("../data/dcpo_surveys/ukds_files",
#                                                        paste0(sp, "_files")))
# })

  # Poland GSS
  pgss_ds <- ds %>%
    filter(survey == "pgss")
  if (nrow(pgss_ds > 0)) {
    new_dir <- pgss_ds$new_dir[1]
    dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)

    login_link <- "http://www.ads.org.pl/log.php?id=91"
    s <- html_session(login_link)
    s1 <- html_form(s)[[1]] %>%
      set_values(log = getOption("ads_login"),
                 pas = getOption("ads_password"))
    s2 <- submit_form(s, s1) %>%
      jump_to("http://www.ads.org.pl/dnldal.php?id=91&nazwa=P0091SAV.zip")

    file_dir <- file.path(new_dir, "P0091SAV.zip")
    writeBin(httr::content(s2$response, "raw"), file_dir)

    unzip(file_dir, exdir = new_dir)
    unlink(file_dir)
    data_file <- list.files(path = new_dir) %>%
      str_subset("\\.sav") %>%
      last()
    suppressWarnings(
      foreign::read.spss(file.path(new_dir, data_file),
                         to.data.frame = TRUE,
                         use.value.labels = FALSE) %>%
        rio::export(paste0(tools::file_path_sans_ext(file.path(new_dir, data_file)), ".RData"))
    )
  }


  # WVS
  wvs_ds <- ds %>%
    filter(survey == "wvs_combo")
  if (nrow(wvs_ds > 0)) {
    new_dir <- wvs_ds$new_dir[1]

    # build path to chrome's default download directory
    if (Sys.info()[["sysname"]]=="Linux") {
      default_dir <- file.path("home", Sys.info()[["user"]], "Downloads")
    } else {
      default_dir <- file.path("", "Users", Sys.info()[["user"]], "Downloads")
    }

    # create target directory if necessary
    dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
    nd_old <- list.files(new_dir)

    # get list of current default download directory contents
    dd_old <- list.files(default_dir)

    wvs_page <- "http://www.worldvaluessurvey.org/WVSDocumentationWVL.jsp"
    rD <- RSelenium::rsDriver(browser = "chrome")
    remDr <- rD[["client"]]
    remDr$navigate(wvs_page)
    webElem <- remDr$findElement(using = "tag name", "body")
    webElem$clickElement()
    webElem$sendKeysToElement(list(key = "end"))
    elem <- remDr$findElements(using = "tag name", "iframe")
    remDr$switchToFrame(elem[[2]])
    elem1 <- remDr$findElements(using = "tag name", "iframe")
    remDr$switchToFrame(elem1[[1]])
    remDr$findElement(using = "partial link text", "stata")$clickElement()
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
    dd_new <- list.files(default_dir)[!list.files(default_dir) %in% dd_old]
    wait <- TRUE
    tryCatch(
      while(all.equal(stringr::str_detect(dd_new, "\\.part$"), logical(0))) {
        Sys.sleep(1)
        dd_new <- list.files(default_dir)[!list.files(default_dir) %in% dd_old]
      }, error = function(e) 1 )
    while(any(stringr::str_detect(dd_new, "\\.crdownload$"))) {
      Sys.sleep(1)
      dd_new <- list.files(default_dir)[!list.files(default_dir) %in% dd_old]
    }

    # unzip into specified directory and convert to .RData
    unzip(file.path(default_dir, dd_new), exdir = file.path(new_dir))
    unlink(file.path(default_dir, dd_new))

    data_file <- list.files(new_dir)[!list.files(new_dir) %in% nd_old]
    haven::read_dta(file.path(new_dir, data_file), encoding = "latin1") %>%
      rio::export(file.path(new_dir, paste0(wvs_ds$survey[1], ".RData")))

    remDr$close()
    rD[["server"]]$stop()
  }


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
  rio::convert(file.path(new_dir, data_file),
          paste0(tools::file_path_sans_ext(file.path(new_dir, data_file)), ".RData"))

  # close session
  remDr$close()
  rD[["server"]]$stop()
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
