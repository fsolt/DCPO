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
#' @import readr
#' @import reshape2
#' @import dplyr
#' @import beepr
#' @import countrycode
#' @importFrom rio import
#' @importFrom labelled labelled to_factor
#' @importFrom stringr str_detect str_subset str_extract
#' @importFrom plyr mapvalues
#'
#' @export

dcpo_setup <- function(vars,
                       datapath = "../Data",
                       file = "",
                       chime = TRUE) {
  if ("data.frame" %in% class(vars)) {
    vars_table <- vars
  } else {
    vars_table <- read_csv(vars)
  }

  all_sets <- list()
  for (i in seq(dim(vars_table)[1])) {
      cat(i, " ")
      v <- vars_table[i, ]
      ds <- surveys_data[surveys_data$survey==v$survey, ]

      # Get dataset (if necessary)
      if (vars_table[["survey"]][i] != c(0, head(vars_table[["survey"]], -1))[i]) {
          dataset_path <- file.path(datapath,
                                    paste0(ds$archive, "_files"),
                                    paste0(ds$surv_program, "_files"),
                                    ds$doi)
          dataset_file <- list.files(path = dataset_path) %>% str_subset(".RData")
          t_data <- import(file.path(dataset_path, dataset_file))

          # Fix column names (sometimes necessary)
          valid_column_names <- make.names(names=names(t_data), unique=TRUE, allow_ = TRUE)
          names(t_data) <- valid_column_names

          # Get countries
          t_data$c_dcpo <- if(ds$country_var %in% names(t_data)) {
            t_data[[ds$country_var]] %>%
            labelled(., attr(., "labels")) %>%
            to_factor(levels = "labels") %>%
            as.character() %>%
            {if (!is.na(ds$cc_dict))
              countrycode(., "orig", "dest", custom_dict = eval(parse(text = ds$cc_dict)))
              else if (!is.na(ds$cc_origin))
              countrycode(., ds$cc_origin, "country.name")
              else if (!is.na(ds$cc_match))
              suppressWarnings(countrycode(., "country.name", "country.name",
                                           custom_match = eval(parse(text = ds$cc_match))))
              else countrycode(., "country.name", "country.name")} %>%
            str_replace("Republic of (.*)", "\\1") %>%
            str_replace(" of.*|,.*| \\(.*\\)", "") %>%
            str_replace("Russian Federation", "Russia") %>%
            str_replace("United Tanzania", "Tanzania")
          } else ds$country_var

          # Get years
          t_data$y_dcpo <- if (!is.na(ds$cc_year)) {
            t_data[[ds$country_var]] %>%
              labelled(., attr(., "labels")) %>%
              to_factor(levels = "labels") %>%
              as.character() %>%
              countrycode("orig", "year", custom_dict = eval(parse(text = ds$cc_year)))
          } else {
            if (!is.na(ds$year_var)) {
              t_data %>%
                mutate(year = ifelse(between(t_data[[ds$year_var]],
                                             1950, as.numeric(str_extract(Sys.Date(), "\\d{4}"))),
                                     t_data[[ds$year_var]],
                                     str_extract(ds$survey, "\\d{4}") %>% as.numeric())) %>%
                group_by(c_dcpo) %>%
                mutate(y_dcpo = round(mean(year))) %>%
                ungroup() %>%
                .[["y_dcpo"]]
            } else as.numeric(str_extract(ds$survey, "\\d{4}"))
          }

          # Get weights
          if (!is.na(ds$wt)) {
              if (length(unlist(strsplit(ds$wt, split = " "))) == 1) {
                  wt <- with(t_data, get(ds$wt))
              } else eval(parse(text = ds$wt))
              t_data$wt_dcpo <- wt
              rm(wt)
          } else t_data$wt_dcpo <- 1
      }

      # Get variable of interest
      t_data$target <- with(t_data, as.numeric(get(v$variable)))
      if (!is.na(v$to_na)) {
          for (j in eval(parse(text = v$to_na))) {
              t_data$target[t_data$target == j] <- NA
          }
      }
      vals <- eval(parse(text = v$values))
      t_data$target <- plyr::mapvalues(t_data$target, vals, 1:length(vals))
      t_data$target_01 <- (t_data$target - 1)/(max(t_data$target, na.rm = TRUE) - 1)

      # Summarize by country and year at each cutpoint
      for (j in 1:(length(vals) - 1)) {
        vars0 <- t_data %>%
          select(c_dcpo, y_dcpo, wt_dcpo, target) %>%
          group_by(c_dcpo, y_dcpo) %>%
          filter(!is.na(target)) %>%
          summarise(survey = ds$survey,
                    item = weighted.mean(target > j, wt_dcpo),
                    n = length(na.omit(target)),
                    cutpoint = j)
        if (j == 1) vars1 <- vars0 else vars1 <- rbind(vars1, vars0)
      }

      # Rename vars in summary
      names(vars1) <- c("country", "year", "survey", v$item,
                        "n", "cutpoint")
      all_sets[[i]] <- vars1
      rm(vars0, vars1)
  }
  rm(list = c("t_data", "cc", "ds", "v"))

  for (i in seq(length(all_sets))) {
      add <- melt(all_sets[i], id.vars = c("country", "year", "survey", "n",
                                           "cutpoint"), na.rm=T)
      if (i == 1) all_data <- add else all_data <- rbind(all_data, add)
  }
  rm(add)
  all_data$y_r = with(all_data, as.integer(round(n * value))) # number of 'yes' response equivalents, given data weights

  all_data2 <- all_data %>% select(-value, -L1) %>%
    group_by(country, year, variable, cutpoint) %>%
    summarize(y_r = sum(y_r),     # When two surveys ask the same question in
              n = sum(n),         # the same country-year, add samples together
              survey = first(survey)) %>%
    ungroup() %>%
    group_by(country) %>%
    mutate(cc_rank = n(),         # number of country-year-item-cuts (data-richness)
           firstyr = first(year, order_by = year),
           lastyr = last(year, order_by = year)) %>%
    ungroup() %>%
    arrange(desc(cc_rank), country, year) %>% # order by data-richness
    # Generate numeric codes for countries, years, questions, and question-cuts
    mutate(variable_cp = paste(variable, cutpoint, sep="_gt"),
      ccode = as.numeric(factor(country, levels = unique(country))),
      tcode = as.integer(year - min(year) + 1),
      qcode = as.numeric(factor(variable, levels = unique(variable))),
      rcode = as.numeric(factor(variable_cp, levels = unique(variable_cp))),
      ktcode = (ccode-1)*max(tcode)+tcode) %>%
    arrange(ccode, tcode, qcode, rcode) %>%
    group_by(ccode) %>%
    mutate(tq = length(unique(paste(tcode, qcode))),
           year_obs = length(unique(tcode))) %>%
    ungroup()

  # Chime
  if(chime) {
    beep()
  }

  if(file!="") {
    write_csv(all_data2, file)
  }

  return(all_data2)
}
