#' Prepare Data for DCPO
#'
#' \code{dcpo_setup} prepares survey data for use with the \code{dcpo} function.
#'
#' @param vars a data frame of survey items
#' @param datapath path to the directory that houses raw survey datasets
#' @param out filename for saving results
#' @parame chime play chime when complete?
#
#' @details \code{dcpo_setup}, when passed a data frame of survey items, collects the
#' responses and formats them for use with the \code{dcpo} function.
#'
#' @return a data frame
#'
#' @import foreign
#' @import reshape2
#' @import dplyr
#' @import beepr
#'
#' @export

dcpo_setup <- function(vars,
                       datapath = "~/Documents/Projects/Data/",
                       out = "all_data.csv",
                       chime = TRUE) {
  vars_table <- read.csv(vars, as.is = TRUE)

  all_sets <- list()
  for (i in seq(dim(vars_table)[1])) {
      cat(i, " ")
      v <- vars_table[i, ]
      ds <- datasets_table[datasets_table$survey==v$survey, ]

      # Get dataset (if necessary)
      if (vars_table[i, "survey"] != c(0, head(vars_table[, "survey"],-1))[i]) {
          eval(parse(text = ds$load_cmd))
          t_data <- get(v$survey)
          rm(list = v$survey)

          # Get country-years
          cc <- eval(parse(text = ds$cy_data))
          t_data <- merge(t_data, cc)

          # Get weights
          if (ds$wt != "") {
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

      # If multiple values of var of interest are specified, combine them in target
      if (length(eval(parse(text = v$value)))>1) {
          for(j in 2:length(eval(parse(text = v$value)))) {
              t_data$target[t_data$target==eval(parse(text = v$value))[j]] <- eval(parse(text = v$value))[1]
          }
          v$value <- eval(parse(text = v$value))[1]
      }

      # Summarize by country and year
      vars0 <- t_data %>%
        select(c_dcpo, y_dcpo, wt_dcpo, target) %>%
        group_by(c_dcpo, y_dcpo) %>%
        summarise(survey = ds$survey,
                  item = weighted.mean(target == v$value, wt_dcpo, na.rm=T) * 100,
                  n = length(na.omit(target))
                  ) %>%
        filter(!is.na(item) & item!=100 & item!=0)
      if (v$reverse == TRUE) {
          vars0$item <- 100 - vars0$item
      }

      # Rename vars in summary
      names(vars0) <- c("country", "year", "survey", v$item, "n")
      all_sets[[i]] <- vars0
      rm(vars0)
  }
  rm(list = c("t_data", "cc", "ds", "v"))

  for (i in seq(length(all_sets))) {
      add <- melt(all_sets[i], id.vars = c("country", "year", "survey", "n"), na.rm=T)
      if (i == 1) all_data <- add else all_data <- rbind(all_data, add)
  }
  rm(add)
  all_data$y_r = with(all_data, as.integer(round(n * value/100))) # number of 'yes' response equivalents, given data weights

  all_data2 <- all_data %>% select(-value, -L1, -survey) %>%
    group_by(country, year, variable) %>%
    summarize(y_r = sum(y_r),     # When two surveys ask the same question in
              n = sum(n)) %>%     # the same country-year, add samples together
    ungroup() %>%
    group_by(country) %>%
    mutate(cc_rank = n(),         # number of country-year-items (data-richness)
              firstyr = first(year, order_by = year),
              lastyr = last(year, order_by = year)) %>%
    ungroup() %>%
    arrange(desc(cc_rank), country, year) %>% # order by data-richness
    # Generate numeric codes for countries, years, and questions
    mutate(ccode = as.numeric(factor(country, levels = unique(country))),
      tcode = as.integer(year - min(year) + 1),
      rcode = as.numeric(factor(variable, levels = unique(variable)))) %>%
    arrange(ccode, tcode, rcode)

  # Chime
  if(chime) {
    beep()
  }

  write.csv(all_data2, file = out)
  return(all_data2)
}
