library(gesis)

getwd()

#test
gesis_remDr <- setup_gesis(download_dir = "downloads", file_mime = "application/octet-stream")
login_gesis(gesis_remDr, user="dong-yu@uiowa.edu", pass = "06355179")
doanload_dataset(gesis_remDr, doi = 10.4232/1.1303  )
