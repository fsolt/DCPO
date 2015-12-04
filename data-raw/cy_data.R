capwords <- function(s) {
    cap <- function(s) paste(toupper(substring(s, 1, 1)),
    {s <- substring(s, 2); tolower(s)}, sep = "", collapse = " " )
    sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

get.cy <- function(x, c_var = "country") {
    x$c_dcpo <- capwords(x[, c_var])
    x$c_dcpo <- gsub("([^,]*),.*", "\\1", x$c_dcpo)
    x$c_dcpo <- gsub("And ", "and ", x$c_dcpo)
    x$c_dcpo <- gsub("n Arab Jamahiriya", "", x$c_dcpo)
    x$c_dcpo <- gsub("n Federation", "", x$c_dcpo)
    
    cy_data <- ddply(x, .(get(id)), summarize, c_dcpo = c_dcpo[1], y_dcpo = round(mean(year)))
    names(cy_data)[1] <- id
    dump("cy_data")
    temp <- readLines("dumpdata.R")
    temp <- paste(temp, sep=" ", collapse=" ")
    temp <- gsub("cy_data <- structure\\(list", "data.frame", temp)
    temp <- gsub("\\), \\.Names =.*", ", stringsAsFactors = F)", temp)
    return(temp)
}

get.cy.no.id <- function(x, c_var = "country", orig_cvar, orig_yvar) {
    x$c_dcpo <- capwords(x[, c_var])
    x$c_dcpo <- gsub("([^,]*),.*", "\\1", x$c_dcpo)
    x$c_dcpo <- gsub("And ", "and ", x$c_dcpo)
    x$c_dcpo <- gsub("n Arab Jamahiriya", "", x$c_dcpo)
    x$c_dcpo <- gsub("n Federation", "", x$c_dcpo)
    
    cy_data <- ddply(x, .(get(orig_cvar), get(orig_yvar)), summarize, c_dcpo = c_dcpo[1], y_dcpo = round(mean(year)))
    names(cy_data)[1] <- orig_cvar
    names(cy_data)[2] <- orig_yvar
    dump("cy_data")
    temp <- readLines("dumpdata.R")
    temp <- paste(temp, sep=" ", collapse=" ")
    temp <- gsub("cy_data <- structure\\(list", "data.frame", temp)
    temp <- gsub("\\), \\.Names =.*", ", stringsAsFactors = F)", temp)
    return(temp)
}

encode <- function(x) {
    df <- strsplit(x, "\\$")[[1]][1]
    old.var <- strsplit(x, "\\$")[[1]][2]
    dict <- data.frame(new.var = names(attributes(get(df))$label.table[[attributes(get(df))$val.labels[which(names(get(df))==old.var)]]]), 
                       old.var = attributes(get(df))$label.table[[attributes(get(df))$val.labels[which(names(get(df))==old.var)]]])
    matches <- match(get(df)[, old.var], dict[, "old.var"])
    y <- as.character(dict[matches, "new.var"])
    return(y)
}

library(countrycode)
library(plyr)



# ISSP
issp.files <- c("Religion/Religion I/ZA2150.dta", "Family/Family II/ZA2620.dta", "Religion/Religion II/ZA3190.dta", "Religion/Religion III/ZA4950_v2-2-0.dta")
issp.years <- c(1991, 1994, 1998, 2008)
issp.q <- c("v11", "v48", "v9", "V9")
issp.wt <- c("v131", "v315", "v316", "WEIGHT")
issp.app.vars <- data.frame()

for (i in seq(length(issp.files))) {
    issp <- read.dta(paste0(datapath, "ISSP/", issp.files[i]), convert.factors=F)
    if (grepl("ZA2150.dta", issp.files[i])) {
        cc <- data.frame(v3 = 1:18, cty = c("Germany", "Germany", "Great Britain", "Northern Ireland", "USA", "Hungary", "Netherlands", "Italy", "Ireland", "Norway", "Austria", "Slovenia", "Poland", "Israel", "Philippines", "New Zealand", "Russia", "Australia"), year = c(rep(1991, times=7), 1990, 1991, 1991, 1993, rep(1991, times = 7)))
        issp <- merge(issp, cc, all=T)
        issp$country <- countrycode(issp$cty, "country.name", "country.name")
        issp$country[issp$v3==4] <- "NORTHERN IRELAND"
        id <- "v3"
    } else if (grepl("ZA2620.dta", issp.files[i])) {
        cc <- data.frame(v3 = c(1:24), cty = c("Australia", "Germany", "Germany", "Great Britain", "Northern Ireland", "United States", "Austria", "Hungary", "Italy", "Ireland", "Netherlands", "Norway", "Sweden", "Czech Republic", "Slovenia", "Poland", "Bulgaria", "Russia", "New Zealand", "Canada", "Philippines", "Israel", "Japan", "Spain"), year = c(rep(1994, times=6), 1996, rep(1994, times=3), 1995, rep(1994, times=3), 1993, 1994, 1995, 1994, 1994, 1993, rep(1994, times=4)))
        issp <- merge(issp, cc, all=T)
        issp$country <- countrycode(issp$cty, "country.name", "country.name")
        issp$country[issp$v3==5] <- "NORTHERN IRELAND"
        id <- "v3"
    } else if (grepl("ZA3190.dta", issp.files[i])) {
        cc <- data.frame(v3 = c(1:22, 24:33), cty = c("Australia", "Germany", "Germany", "Great Britain", "Northern Ireland", "United States", "Austria", "Hungary", "Italy", "Ireland", "Netherlands", "Norway", "Sweden", "Czech Republic", "Slovenia", "Poland", "Bulgaria", "Russia", "New Zealand", "Canada", "Philippines", "Israel", "Japan", "Spain", "Latvia", "Slovakia", "France", "Cyprus", "Portugal", "Chile", "Denmark", "Switzerland"), year = c(rep(1998, times=6), 1999, 1998, 1999, 1998, 1998, 1998, 1998, 1999, 1998, 1999, 1999, 1998, 1998, 2000, rep(1998, times=7), 1999, 1998, 1998, 1998, 1999))
        issp <- merge(issp, cc, all=T)
        issp$country <- countrycode(issp$cty, "country.name", "country.name")
        issp$country[issp$v3==5] <- "NORTHERN IRELAND"
        id <- "v3"     
    } else if (grepl("ZA4950_v2-2-0.dta", issp.files[i])) {
        issp$country <- countrycode(issp$V5, "iso3n", "country.name") 
        issp$country[issp$V4==8262] <- "NORTHERN IRELAND"
        cc <- data.frame(country = countrycode(c("Australia", "Austria", "Belgium", "Chile", "Croatia", "Czech Republic", "Denmark", "Dominican Republic", "Finland", "France", "Germany", "Great Britain", "Hungary", "Ireland", "Israel", "Italy", "Japan", "Latvia", "Mexico", "Netherlands", "New Zealand", "NIplace", "Norway", "Philippines", "Poland", "Portugal", "Russia", "Slovakia", "Slovenia", "South Africa", "South Korea", "Spain", "Sweden", "Switzerland", "Taiwan", "Turkey", "Ukraine", "Uruguay", "United States", "Venezuela"), "country.name", "country.name"),
                         year = c(2009, 2008, 2008, 2008, 2009, 2008, 2009, 2008, 2008, 2008, 2008, 2008, 2008, 2008, 2009, 2008, 2008, 2009, 2009, 2008, 2008, 2008, 2008, 2007, 2010, 2009, 2009, 2008, 2009, 2008, 2008, 2008, 2008, 2008, 2009, 2008, 2008, 2008, 2008, 2008),
                         stringsAsFactors=F)
        cc$country[is.na(cc$country)] <- "NORTHERN IRELAND"
        issp <- merge(issp, cc, all=T) 
        id <- "V4"
    }
    cy <- get.cy(issp)
    write(cy, file = paste0("issp", i, ".txt"))
}
    

#EB774-12
eb.files <- c("EB77_4-12/ZA5613_v2-0-0.dta")
eb.years <- c(2012)
surv <- tolower(gsub("[/-].*", "", eb.files[i]))
id <- "country"
i <- 1
eb <- read.dta(paste0(datapath, "EuroBarometer/",eb.files[i]), convert.factors=F)
eb$cc <- encode("eb$country")
eb$cc <- gsub(" ?[/-].*", "", eb$cc)
eb$cc <- countrycode(eb$cc, "iso2c", "country.name", warn=T)
eb$year <- eb.years[i]
cy <- get.cy(eb, c_var = "cc")
write(cy, file = paste0("cy_data/", surv, ".txt"))

#EB691-08; EB712-09
eb.files <- c("EB69_1-08/ZA4743_v3-0-1.dta", "EB71_2-09/ZA4972_v3-0-2.dta")
eb.years <- c(2008, 2009)
id <- "v7"

for (i in seq(length(eb.files))) {
    eb <- read.dta(paste0(datapath, "EuroBarometer/",eb.files[i]), convert.factors=F)
    eb$country <- countrycode(eb$v7, "iso2c", "country.name")
    eb$country[grep("DE\\-", eb$v7)] <- "GERMANY"
    eb$country[grep("GB\\-", eb$v7)] <- "UNITED KINGDOM"
    eb$year <- eb.years[i]
    surv <- tolower(gsub("[/-].*", "", eb.files[i]))
    cy <- get.cy(eb)
    write(cy, file = paste0("cy_data/", surv, ".txt"))
}

#EB661-06
eb.files <- c("EB66_1-06/21281-0001-Data.dta")
id <- "isocntry"

eb <- read.dta(paste0(datapath, "EuroBarometer/",eb.files), convert.factors=F)
eb$country <- countrycode(eb$isocntry, "iso2c", "country.name")
eb$country[grep("DE\\_", eb$isocntry)] <- "GERMANY"
eb$country[grep("GB\\_", eb$isocntry)] <- "UNITED KINGDOM"
eb$country[grep("CY\\_", eb$isocntry)] <- "NORTHERN CYPRUS"
eb$year <- 2006
surv <- tolower(gsub("[/-].*", "", eb.files))
cy <- get.cy(eb)
write(cy, file = paste0("cy_data/", surv, ".txt"))

#EB39-93
eb.files <- c("EB39-93/ZA2346_v1-1-0.dta")
id <- "isocntry"

eb <- read.dta(paste0(datapath, "EuroBarometer/",eb.files), convert.factors=F)
eb$country <- countrycode(eb$isocntry, "iso2c", "country.name")
eb$country[grep("DE\\-", eb$isocntry)] <- "GERMANY"
eb$country[grep("GB\\-", eb$isocntry)] <- "UNITED KINGDOM"
eb$year <- 1993
surv <- tolower(gsub("[/-].*", "", eb.files))
cy <- get.cy(eb)
write(cy, file = paste0("cy_data/", surv, ".txt"))


#Latinobarometro
lb.years <- c(1998, 2002, 2004, 2008, 2009)
id <- "idenpa"

for (i in seq(length(lb.years))) {
    lb <- read.dta(paste0(datapath, "Latinobarometro/",lb.years[i],"/Latinobarometro_",lb.years[i],"_eng.dta"), convert.factors = F)
    lb$country <- encode("lb$idenpa")
    lb$country[lb$country=="brasil"] <- "Brazil"
    lb$country <- countrycode(lb$country, "country.name", "country.name")
    lb$year <- lb.years[i]
    surv <- paste0("lb", lb.years[i])
    cy <- get.cy(lb)
    write(cy, file = paste0("cy_data/", surv, ".txt"))
}

# Americas Barometer (This doesn't really work; LAPOP stata file has issues)
amb <- read.csv(paste0(datapath, "LAPOP/2004-2012/AmericasBarometer Merged 2004-2012 Rev1.5_FREE.csv"), as.is=T)
amb$country <- countrycode(amb$pais, "country.name", "country.name", warn=T)
amb$country[grep("Canad", amb$pais, useBytes=T)] <- "CANADA"
amb$country[grep("Hait", amb$pais, useBytes=T)] <- "HAITI"
amb$country[grep("xico", amb$pais, useBytes=T)] <- "MEXICO"
amb$country[grep("Panam", amb$pais, useBytes=T)] <- "PANAMA"
amb$country[grep("Per", amb$pais, useBytes=T)] <- "PERU"
amb$country[amb$pais=="Belice"] <- "BELIZE"
amb$country[amb$pais=="Brasil"] <- "BRAZIL"
amb$country[amb$pais=="Estados Unidos"] <- "UNITED STATES"

surv <- "amb.combo"
cy <- get.cy.no.id(amb, orig_cvar = "pais", orig_yvar = "year")
write(cy, file = paste0("cy_data/", surv, ".txt"))

# ESS
ess.combo <- read.dta(paste0(datapath, "ESS/esscumulative1_5/ess1-5_cumulative_e01_1.dta"), convert.factors=F)
ess.combo$country <- countrycode(ess.combo$cntry, "iso2c", "country.name")
ess.combo$year <- ess.combo$inwyr
ess.combo$year[is.na(ess.combo$year)] <- ess.combo$inwyye[is.na(ess.combo$year)]
ess.combo$year[is.na(ess.combo$year)] <- ess.combo$inwyys[is.na(ess.combo$year)]
ess.combo$year[is.na(ess.combo$year)] <- ess.combo$essround[is.na(ess.combo$year)]*2 + 2000

surv <- "ess.combo"
cy <- get.cy.no.id(ess.combo, orig_cvar = "cntry", orig_yvar = "essround")
write(cy, file = paste0("cy_data/", surv, ".txt"))


ess6 <- read.dta(paste0(datapath, "ESS/ESS6e02/ESS6e02.dta"), convert.factors=F)
ess6$country <- countrycode(ess6$cntry, "iso2c", "country.name")
ess6$country[ess6$cntry=="XK"] <- "KOSOVO"
ess6$year <- ess6$inwyye
ess6$year[ess6$year==9999] <- ess6$inwyys[ess6$year==9999]

id <- "cntry"
surv <- "ess6"
cy <- get.cy(ess6)
write(cy, file = paste0("cy_data/", surv, ".txt"))

ess7 <- read.dta(paste0(datapath, "ESS/ESS7e01.stata/ESS7e01.dta"), convert.factors=F)


# EVS
evs.combo <- read.csv(paste0(datapath, "EVS/ZA4804_v2-0-0.dta/ZA4804_v2-0-0.csv"), as.is=T)
evs.combo$country <- countrycode(evs.combo$s003, "iso3n", "country.name", warn=T)
evs.combo$country[evs.combo$s003==197] <- "NORTHERN CYPRUS"
evs.combo$country[evs.combo$s003==909] <- "NORTHERN IRELAND"
evs.combo$country[evs.combo$s003==915] <- "KOSOVO"
evs.combo$year <- with(evs.combo, s025 - 10000*s003)

id <- "s025"
surv <- "evs.combo"
cy <- get.cy(evs.combo)
write(cy, file = paste0("cy_data/", surv, ".txt"))

# PGSS
pgss <- read.dta(paste0(datapath, "/GSS/Poland/p0091sav.dta"), convert.factors=F)
pgss$country <- "POLAND"
pgss$year <- pgss$pgssyear

id <- "pgssyear"
surv <- "pgss"
cy <- get.cy(pgss)
write(cy, file = paste0("cy_data/", surv, ".txt"))

# USGSS
usgss <- read.dta(paste0(datapath, "GSS/U.S./31521-0001-Data.dta"), convert.factors=F)
usgss$country <- "UNITED STATES"
usgss$year <- usgss$YEAR
usgss <- usgss[usgss$year>1980, ]

id <- "YEAR"
surv <- "usgss"
cy <- get.cy(usgss)
write(cy, file = paste0("cy_data/", surv, ".txt"))

# ALLBUS
allbus <- read.dta(paste0(datapath, "GSS/Germany/ZA4574_v1-0-1.dta"), convert.factors=F)
allbus$country <- "GERMANY"
allbus$year <- allbus$v2

id <- "v2"
surv <- "allbus"
cy <- get.cy(allbus)
write(cy, file = paste0("cy_data/", surv, ".txt"))

# Pew 2002
pew2002 <- read.dta(paste0(datapath, "Pew/2002/pew gap final 44 country dataset 1.1sav.dta"), convert.factors=F)
pew2002$cc <- encode("pew2002$country")
pew2002$cc <- countrycode(pew2002$cc, "country.name", "country.name", warn=T)
pew2002$year <- 2002

id <- "country"
surv <- "pew2002"
cy <- get.cy(pew2002, c_var = "cc")
write(cy, file = paste0("cy_data/", surv, ".txt"))

# Pew 2007
pew2007 <- read.dta(paste0(datapath, "Pew/2007/gap_2007_data.dta"), convert.factors=F)
pew2007$cc <- encode("pew2007$country")
pew2007$cc <- countrycode(pew2007$cc, "country.name", "country.name", warn=T)
pew2007$year <- 2007

id <- "country"
surv <- "pew2007"
cy <- get.cy(pew2007, c_var = "cc")
write(cy, file = paste0("cy_data/", surv, ".txt"))

# Pew 2011
pew2011 <- read.dta(paste0(datapath, "Pew/2011/pew global attitudes spring 2011 dataset for web.dta"), convert.factors=F)
pew2011$cc <- encode("pew2011$country")
pew2011$cc <- countrycode(pew2011$cc, "country.name", "country.name", warn=T)
pew2011$year <- 2011

id <- "country"
surv <- "pew2011"
cy <- get.cy(pew2011, c_var = "cc")
write(cy, file = paste0("cy_data/", surv, ".txt"))

# Pew 2013
pew2013 <- read.dta(paste0(datapath, "Pew/2013/pew research global attitudes project spring 2013 dataset for web.dta"), convert.factors=F)pew2011$cc <- encode("pew2011$country")
pew2013$cc <- encode("pew2013$country")
pew2013$cc <- countrycode(pew2013$cc, "country.name", "country.name", warn=T)
pew2013$year <- 2013

id <- "country"
surv <- "pew2013"
cy <- get.cy(pew2013, c_var = "cc")
write(cy, file = paste0("cy_data/", surv, ".txt"))

data.frame(country = c(1:15, 17:40), c_dcpo = c("Argentina", "Australia", "Bolivia",  "Brazil", "United Kingdom", "Canada", "Chile", "China", "Czech Republic",  "Egypt", "El Salvador", "France", "Germany", "Ghana", "Greece",  "Indonesia", "Israel", "Italy", "Japan", "Jordan", "Kenya", "Lebanon",  "Malaysia", "Mexico", "Nigeria", "Pakistan", "Palestinian Territory",  "Philippines", "Poland", "Russia", "Senegal", "South Africa",  "Korea", "Spain", "Tunisia", "Turkey", "Uganda", "United States",  "Venezuela"), y_dcpo = c2013, stringsAsFactors = F)

#EQLS
eqls.combo <- read.dta(paste0(datapath, "EQLS/2003-2012/eqls_final_integrated_dataset_2003-2012.dta"), convert.factors=F)
eqls.combo$country <- encode("eqls.combo$Y11_Country")
eqls.combo$country <- countrycode(eqls.combo$cc, "country.name", "country.name", warn=T)
eqls.combo$yc <- encode("eqls.combo$Wave")
eqls.combo$year <- as.numeric(gsub(x = eqls.combo$yc, pattern=".*([0-9]{4}).*", "\\1" ))

get.cy.no.id(eqls.combo, orig_cvar="Y11_Country", orig_yvar="Wave")
