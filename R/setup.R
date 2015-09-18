#' Prepare Data for DCPO
#'
#' \code{dcpo_setup} is a function .
#'
#' @param vars a df of variables
#' @param keep all, high, or low
#
#' @details \code{dcpo_setup} prepares data
#'
#'
#' @return a data frame
#'
#' @import foreign
#' @import Hmisc
#' @import reshape2
#' @import dplyr
#' @import beepr
#'
#'
#' @export

dcpo_setup <- function(vars, keep = "all") {
  datapath <- "~/Documents/Projects/Data/"
  vars_table <- read.csv(vars, as.is = TRUE)

  if (keep == "low") {
      vars_table <- vars_table[(vars_table$reverse | grepl(x=vars_table$item, "2")), ]
      vars_table$reverse <- !vars_table$reverse
      vars_table$item <- gsub(x=vars_table$item, "r$","")
      vars_table$item <- gsub(x=vars_table$item, "2$", "2r")
  } else if (keep == "high") {
      vars_table <- vars_table[!vars_table$reverse, ]
  }

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

      if (length(eval(parse(text = v$value)))>1) {
          for(j in 2:length(eval(parse(text = v$value)))) {
              t_data$target[t_data$target==eval(parse(text = v$value))[j]] <- eval(parse(text = v$value))[1]
          }
          v$value <- eval(parse(text = v$value))[1]
      }

      vars0 <- t_data %>%
        group_by(c_dcpo, y_dcpo) %>%
        summarise(survey = ds$survey,
                  item = weighted.mean(target == v$value, wt_dcpo, na.rm=T) * 100,
                  n = length(na.omit(target))) %>%
        filter(!is.na(item) & item!=100 & item!=0)
      if (v$reverse == TRUE) {
          vars0$item <- 100 - vars0$item
      }

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
  all_data$y_r = with(all_data, n * value/100)

  # When two surveys asked the same question in the same country-year, add samples together
  all_data2 <- all_data[!names(all_data) %in% c("value", "L1", "survey")]
  all_data2y_r <- dcast(all_data2, country + year + variable ~ ., value.var = "y_r", fun.aggregate = function(x) as.integer(round(sum(x))))
  names(all_data2y_r)[4] <- "y_r"
  all_data2n <- dcast(all_data2, country + year + variable ~ ., value.var = "n", fun.aggregate = sum)
  names(all_data2n)[4] <- "n"
  all_data2 <- merge(all_data2y_r, all_data2n)
  rm(all_data2y_r, all_data2n)

  # Generate numeric codes for countries, years, and questions
  all_data2 <- ddply(all_data2, .(country), mutate,
                     cc_rank = length(y_r),
                     firstyr = min(year),
                     lastyr = max(year))
  all_data2 <- all_data2[order(-all_data2$cc_rank, all_data2$country), ]
  all_data2$ccode <- match(all_data2$country, unique(all_data2$country))
  all_data2$tcode <- with(all_data2, as.integer(year - min(year) + 1))
  all_data2$rcode <- match(all_data2$variable, unique(all_data2$variable))

  all_data2 <- all_data2[order(all_data2$ccode, all_data2$tcode, all_data2$rcode), ]

  # Chime
  beep()

  write.csv(all_data2, file="all_data2.csv")
}
