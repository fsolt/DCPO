# eb_datasets.csv

library(gesis)

if(!dir.exists("downloads")) dir.create("downloads")
gesis_remDr <- setup_gesis(download_dir = "downloads")

login_gesis(gesis_remDr)
download_dataset(gesis_remDr, doi = "0989", filetype = "dta", purpose = 1)

dir("downloads")
gesis_remDr$Close()
gesis_remDr$closeServer()

browse_codebook(doi = 0989)
