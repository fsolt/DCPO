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

dcpo_setup <- function(vars,
                       datapath = "~/Documents/Projects/Data/",
                       chime = TRUE) {
  if ("data.frame" %in% class(vars)) {
    vars_table <- vars
  } else {
    vars_table <- read.csv(vars, as.is = TRUE)
  }

  all_sets <- list()
  for (i in seq(dim(vars_table)[1])) {
      cat(i, " ")
      v <- vars_table[i, ]
      ds <- datasets_table[datasets_table$survey==v$survey, ]

      # Get dataset (if necessary)
      if (vars_table[["survey"]][i] != c(0, head(vars_table[["survey"]], -1))[i]) {
          eval(parse(text = ds$load_cmd))
          t_data <- get(v$survey)
          rm(list = v$survey)

          # Fix column names (sometimes necessary)
          valid_column_names <- make.names(names=names(t_data), unique=TRUE, allow_ = TRUE)
          names(t_data) <- valid_column_names

          # Get country-years
          cc <- eval(parse(text = ds$cy_data))
          t_data <- merge(t_data, cc)

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
                        "n", "cutpoint", "variance")
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

  all_data2 <- all_data %>% select(-value, -L1, -survey) %>%
    group_by(country, year, variable, cutpoint) %>%
    summarize(y_r = sum(y_r),     # When two surveys ask the same question in
              n = sum(n),         # the same country-year, add samples together
              variance = min(.25,
                             Hmisc::wtd.var((target - 1)/(max(target) - 1),
                                            wt_dcpo))) %>%
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
      rcode = as.numeric(factor(variable_cp, levels = unique(variable_cp)))) %>%
    arrange(ccode, tcode, qcode, rcode)

  # Chime
  if(chime) {
    beep()
  }

  return(all_data2)
}
