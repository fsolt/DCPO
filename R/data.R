#' Support for Democracy in 51 Survey Datasets
#'
#' A dataset containing the prices and other attributes of almost 54,000
#' diamonds.
#'
#' Data on aggregate support for democracy reported in 51 survey datasets in 998 country-years,
#' formatted for use with the functions of the DCPO package
#'
#' @format A list of 15 elements
#' \describe{
#'   \item{K}{an integer, the total number of countries in the data}
#'   \item{T}{an integer, the total number of years in the data}
#'   \item{Q}{an integer, the total number of distinct survey questions in the data}
#'   \item{R}{an integer, the maximum number of response cutpoints in any survey question in the data}
#'   \item{N}{an integer, the number of KTQR observations}
#'   \item{kk}{a numeric vector of length N, the country of each observation}
#'   \item{tt}{a numeric vector of length N, the year of each observation}
#'   \item{qq}{a numeric vector of length N, the question of each observation}
#'   \item{rr}{a numeric vector of length N, the response cutpoint of each observation}
#'   \item{y_r}{a numeric vector of length N, the number of respondents who provided a response above the relevant cutpoint for each observation}
#'   \item{n_r}{a numeric vector of length N, the total number of respondents for each observation}
#'   \item{fixed_cutp}{a QxR matrix, a truth table indicating the question-cutpoint to be fixed at difficulty .5}
#'   \item{use_delta}{a QxK tibble, a truth table indicating whether item difficulty should be estimated to vary by question-country to account for potential item-response bias}
#'   \item{data}{an Nx14 tibble, the aggregate survey response dataset in its original format}
#'   \item{data_args}{a list of length 3, indicating the arguments passed to DCPOtools::format_dcpo to generate demsup_data from demsup_data$data}
#' }
#' @source demsup_data replicates the data employed in Claassen, Christopher. 2019. "Estimating
#' Smooth Country-Year Panels of Public Opinion." Political Analysis 27(1):1-20. See \url{https://github.com/fsolt/DCPOtools}.
"demsup_data"
