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
#' @import plyr
#' @import beepr
#'
#'
#' @export

dcpo_setup <- function(vars, keep = "all") {
  datapath <- "~/Documents/Projects/Data/"
  vars.table <- read.csv(vars, as.is=T)
  data(sysdata, envir=environment())

  if (keep == "low") {
      vars.table <- vars.table[(vars.table$reverse | grepl(x=vars.table$item, "2")), ]
      vars.table$reverse <- !vars.table$reverse
      vars.table$item <- gsub(x=vars.table$item, "r$","")
      vars.table$item <- gsub(x=vars.table$item, "2$", "2r")
  } else if (keep == "high") {
      vars.table <- vars.table[!vars.table$reverse, ]
  }

  all.sets <- list()
  for (i in seq(dim(vars.table)[1])) {
      cat(i, " ")
      v <- vars.table[i, ]
      ds <- datasets_table[datasets_table$survey==v$survey, ]

      # Get dataset (if necessary)
      if (vars.table[i, "survey"] != c(0, head(vars.table[, "survey"],-1))[i]) {
          eval(parse(text = ds$load_cmd))
          t.data <- get(v$survey)
          rm(list = v$survey)

          # Get country-years
          cc <- eval(parse(text = ds$cy_data))
          t.data <- merge(t.data, cc)

          # Get weights
          if (ds$wt != "") {
              if (length(unlist(strsplit(ds$wt, split = " "))) == 1) {
                  wt <- with(t.data, get(ds$wt))
              } else eval(parse(text = ds$wt))
              t.data$wt_dcpo <- wt
              rm(wt)
          } else t.data$wt_dcpo <- 1
      }

      # Get variable of interest
      t.data$target <- with(t.data, as.numeric(get(v$variable)))
      if (!is.na(v$to_na)) {
          for (j in eval(parse(text = v$to_na))) {
              t.data$target[t.data$target == j] <- NA
          }
      }

      if (length(eval(parse(text = v$value)))>1) {
          for(j in 2:length(eval(parse(text = v$value)))) {
              t.data$target[t.data$target==eval(parse(text = v$value))[j]] <- eval(parse(text = v$value))[1]
          }
          v$value <- eval(parse(text = v$value))[1]
      }

      vars0 <- ddply(t.data, .(c_dcpo, y_dcpo), summarize,
                     survey = ds$survey,
                     item = weighted.mean(target == v$value, wt_dcpo, na.rm=T) * 100,
                     n = length(na.omit(target))
                     )
      vars0 <- vars0[!is.na(vars0$item), ]
      vars0 <- vars0[vars0$item!=100 & vars0$item!=0, ]
      if (v$reverse == TRUE) {
          vars0$item <- 100 - vars0$item
      }

      names(vars0) <- c("country", "year", "survey", v$item, "n")
      all.sets[[i]] <- vars0
      rm(vars0)
  }
  rm(list = c("t.data", "cc", "ds", "v"))

  for (i in seq(length(all.sets))) {
      add <- melt(all.sets[i], id.vars = c("country", "year", "survey", "n"), na.rm=T)
      if (i == 1) all.data <- add else all.data <- rbind(all.data, add)
  }
  rm(add)
  all.data$y_r = with(all.data, n * value/100)

  # When two surveys asked the same question in the same country-year, add samples together
  all.data2 <- all.data[!names(all.data) %in% c("value", "L1", "survey")]
  all.data2y_r <- dcast(all.data2, country + year + variable ~ ., value.var = "y_r", fun.aggregate = function(x) as.integer(round(sum(x))))
  names(all.data2y_r)[4] <- "y_r"
  all.data2n <- dcast(all.data2, country + year + variable ~ ., value.var = "n", fun.aggregate = sum)
  names(all.data2n)[4] <- "n"
  all.data2 <- merge(all.data2y_r, all.data2n)
  rm(all.data2y_r, all.data2n)

  # Generate numeric codes for countries, years, and questions
  all.data2 <- ddply(all.data2, .(country), mutate,
                     cc_rank = length(y_r),
                     firstyr = min(year),
                     lastyr = max(year))
  all.data2 <- all.data2[order(-all.data2$cc_rank, all.data2$country), ]
  all.data2$ccode <- match(all.data2$country, unique(all.data2$country))
  all.data2$tcode <- with(all.data2, as.integer(year - min(year) + 1))
  all.data2$rcode <- match(all.data2$variable, unique(all.data2$variable))

  all.data2 <- all.data2[order(all.data2$ccode, all.data2$tcode, all.data2$rcode), ]

  # Chime
  beep()

  write.csv(all.data2, file="all_data2.csv")
}
