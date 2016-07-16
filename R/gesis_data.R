library(gesis)

getwd()

#test
gesis_remDr <- setup_gesis(download_dir = "downloads", file_mime = "application/octet-stream")
login_gesis(gesis_remDr, user="dong-yu@uiowa.edu", pass = "06355179")
doanload_dataset(gesis_remDr, doi = 10.4232/1.1303  )


devtools::install_github("fsolt/gesis")
library(gesis)

# Fill in your info below
options("gesis_user" = "dong-yu@uiowa.edu",
        "gesis_pass" = "06355179")

gesis_download(c(1490)) # and so on; these are the three oldest studies
# DOI for this purpose is the ZA code number, not the real doi:whatever.numbers link

rm(eb02,eb03)



require(RSelenium)
RSelenium::startServer()
remDr <- remoteDriver(browserName = "chrome")
remDr$open()

#Try another package
knitr::opts_chunk$set(eval = FALSE)
# install.packages("devtools")
devtools::install_github("expersso/gesis")

if(!dir.exists("downloads")) dir.create("downloads")
gesis_remDr <- setup_gesis(download_dir = "downloads")

