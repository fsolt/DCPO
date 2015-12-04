# functions and code toward generating the cy_data column of datasets_table.csv

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

    cy_data <- plyr::ddply(x, plyr::.(get(id)), summarize, c_dcpo = c_dcpo[1], y_dcpo = round(mean(year)))
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

datapath <- "~/Documents/Projects/Data/"

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

# CDCEE
cee <- haven::read_dta("~/Documents/Projects/Data/CDCEE/ZA4054_F1.dta")
cdcee <- haven::read_dta("~/Documents/Projects/Data/CDCEE/ZA4054_F1.dta"); cdcee <- dplyr::left_join(cdcee, data.frame(v666 = c(1:25, NA), y_dcpo = c(rep(1990, 3), rep(1991,3), 1992, rep(1998, 7), rep(1999, 5), rep(2000, 2), rep(2001, 4), 1990)))
cee_year <- data.frame(v666 = c(1:25, NA), year = c(rep(1990, 3), rep(1991,3), 1992, rep(1998, 7), rep(1999, 5), rep(2000, 2), rep(2001, 4), 1990))
cee_country <- data.frame(v3 = 1:15, c_dcpo = c("Belarus", "Bulgaria", "Czech Republic", "Estonia", "Germany", "Germany", "Hungary", "Latvia", "Lithuania", "Poland", "Romania", "Russia", "Slovakia", "Slovenia", "Ukraine"))
cee1 <- left_join(cee, cee_year)
cee2 <- left_join(cee1, cee_country)
t_data <- left_join(cdcee, cee_country)
wt <- t_data$v633; wt[!is.na(t_data$v634)] <- t_data$v634[!is.na(t_data$v634)]; wt[!is.na(t_data$v636)] <- t_data$v636[!is.na(t_data$v636)]; wt[!is.na(t_data$v637)] <- t_data$v637[!is.na(t_data$v637)]; wt[!is.na(t_data$v638)] <- t_data$v638[!is.na(t_data$v638)]; wt[!is.na(t_data$v639)] <- t_data$v639[!is.na(t_data$v639)]; wt[!is.na(t_data$v640)] <- t_data$v640[!is.na(t_data$v640)]; wt[is.na(wt)] <- 1

wt <- t_data$v8; wt[grep("DE\\-", t_data$isocntry)] <- t_data$v12[grep("DE\\-", t_data$isocntry)]; wt[grep("GB\\-", t_data$isocntry)] <- t_data$v10[grep("GB\\-", t_data$isocntry)]

data.frame(S025 = c(81998, 82002, 122002, 122013, 202005, 311997, 312011, 321984, 321991, 321995, 321999, 322006, 361981, 361995, 362005, 362012, 501996, 502002, 511997, 512011, 702001, 761991, 762006, 1001997, 1002005, 1121990, 1121996, 1122011, 1242000, 1242006, 1521990, 1521996, 1522000, 1522006, 1522011, 1561990, 1561995, 1562001, 1562007, 1562012, 1582006, 1582012, 1701997, 1701998, 1702005, 1702012, 1911996, 1962006, 1962011, 2031991, 2141996, 2182013, 2221999, 2312007, 2331996, 2332011, 2461981, 2461996, 2462005, 2502006, 2681996, 2682009, 2752013, 2761997, 2762006, 2762013, 2882007, 2882012, 3202004, 3442005, 3481982, 3481998, 3482009, 3561990, 3561995, 3562001, 3562006, 3602001, 3602006, 3642000, 3642007, 3682004, 3682006, 3682012, 3762001, 3802005, 3921981, 3921990, 3922000, 3922005, 3922010, 3982011, 4002001, 4002007, 4002014, 4101982, 4101990, 4101996, 4102001, 4102005, 4102010, 4142014, 4172003, 4172011, 4222013, 4281996, 4342014, 4401997, 4582006, 4582012, 4662007, 4841981, 4841990, 4841995, 4841996, 4842000, 4842005, 4842012, 4981996, 4982002, 4982006, 5042001, 5042007, 5042011, 5282006, 5282012, 5541998, 5542004, 5542011, 5661990, 5661995, 5662000, 5662011, 5781996, 5782007, 5861997, 5862001, 5862012, 6041996, 6042001, 6042006, 6042012, 6081996, 6082001, 6082012, 6161989, 6161997, 6162005, 6162012, 6301995, 6302001, 6342010, 6421998, 6422005, 6422012, 6431990, 6431995, 6432006, 6432011, 6462007, 6462012, 6822003, 7022002, 7022012, 7031990, 7031998, 7042001, 7042006, 7051995, 7052005, 7052011, 7101982, 7101990, 7101996, 7102001, 7102006, 7162001, 7162012, 7241990, 7241995, 7242000, 7242007, 7242011, 7521981, 7521996, 7521999, 7522006, 7522011, 7561989, 7561996, 7562007, 7642007, 7802006, 7802011, 7882013, 7921990, 7921996, 7922001, 7922007, 7922011, 8002001, 8041996, 8042006, 8042011, 8071998, 8072001, 8182001, 8182008, 8182013, 8261998, 8262005, 8342001, 8401981, 8401995, 8401999, 8402006, 8402011, 8542007, 8581996, 8582006, 8582011, 8602011, 8621996, 8622000, 8872014, 8912005, 8942007, 9111996, 9112001, 9121996, 9122001, 9141998), c_dcpo = c("Albania", "Albania", "Algeria", "Algeria", "Andorra", "Azerbaijan", "Azerbaijan", "Argentina", "Argentina", "Argentina", "Argentina", "Argentina", "Australia", "Australia", "Australia", "Australia", "Bangladesh", "Bangladesh", "Armenia", "Armenia", "Bosnia and Herzegovina", "Brazil", "Brazil", "Bulgaria", "Bulgaria", "Belarus", "Belarus", "Belarus", "Canada", "Canada", "Chile", "Chile", "Chile", "Chile", "Chile", "China", "China", "China", "China", "China", "Taiwan", "Taiwan", "Colombia", "Colombia", "Colombia", "Colombia", "Croatia", "Cyprus", "Cyprus", "Czech Republic", "Dominican Republic", "Ecuador", "El Salvador", "Ethiopia", "Estonia", "Estonia", "Finland", "Finland", "Finland", "France", "Georgia", "Georgia", "Palestinian Territory", "Germany", "Germany", "Germany", "Ghana", "Ghana", "Guatemala", "Hong Kong", "Hungary", "Hungary", "Hungary", "India", "India", "India", "India", "Indonesia", "Indonesia", "Iran", "Iran", "Iraq", "Iraq", "Iraq", "Israel", "Italy", "Japan", "Japan", "Japan", "Japan", "Japan", "Kazakhstan", "Jordan", "Jordan", "Jordan", "Korea", "Korea", "Korea", "Korea", "Korea", "Korea", "Kuwait", "Kyrgyzstan", "Kyrgyzstan", "Lebanon", "Latvia", "Libya", "Lithuania", "Malaysia", "Malaysia", "Mali", "Mexico", "Mexico", "Mexico", "Mexico", "Mexico", "Mexico", "Mexico", "Moldova", "Moldova", "Moldova", "Morocco", "Morocco", "Morocco", "Netherlands", "Netherlands", "New Zealand", "New Zealand", "New Zealand", "Nigeria", "Nigeria", "Nigeria", "Nigeria", "Norway", "Norway", "Pakistan", "Pakistan", "Pakistan", "Peru", "Peru", "Peru", "Peru", "Philippines", "Philippines", "Philippines", "Poland", "Poland", "Poland", "Poland", "Puerto Rico", "Puerto Rico", "Qatar", "Romania", "Romania", "Romania", "Russia", "Russia", "Russia", "Russia", "Rwanda", "Rwanda", "Saudi Arabia", "Singapore", "Singapore", "Slovakia", "Slovakia", "Vietnam", "Vietnam", "Slovenia", "Slovenia", "Slovenia", "South Africa", "South Africa", "South Africa", "South Africa", "South Africa", "Zimbabwe", "Zimbabwe", "Spain", "Spain", "Spain", "Spain", "Spain", "Sweden", "Sweden", "Sweden", "Sweden", "Sweden", "Switzerland", "Switzerland", "Switzerland", "Thailand", "Trinidad and Tobago", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkey", "Turkey", "Turkey", "Turkey", "Uganda", "Ukraine", "Ukraine", "Ukraine", "Macedonia", "Macedonia", "Egypt", "Egypt", "Egypt", "United Kingdom", "United Kingdom", "Tanzania", "United States", "United States", "United States", "United States", "United States", "Burkina Faso", "Uruguay", "Uruguay", "Uruguay", "Uzbekistan", "Venezuela", "Venezuela", "Yemen", "Serbia", "Zambia", "Serbia", "Serbia", "Montenegro", "Montenegro", "Bosnia and Herzegovina" ), y_dcpo = c(1998, 2002, 2002, 2013, 2005, 1997, 2011, 1984, 1991, 1995, 1999, 2006, 1981, 1995, 2005, 2012, 1996, 2002, 1997, 2011, 2001, 1991, 2006, 1997, 2005, 1990, 1996, 2011, 2000, 2006, 1990, 1996, 2000, 2006, 2011, 1990, 1995, 2001, 2007, 2012, 2006, 2012, 1997, 1998, 2005, 2012, 1996, 2006, 2011, 1991, 1996, 2013, 1999, 2007, 1996, 2011, 1981, 1996, 2005, 2006, 1996, 2009, 2013, 1997, 2006, 2013, 2007, 2012, 2004, 2005, 1982, 1998, 2009, 1990, 1995, 2001, 2006, 2001, 2006, 2000, 2007, 2004, 2006, 2012, 2001, 2005, 1981, 1990, 2000, 2005, 2010, 2011, 2001, 2007, 2014, 1982, 1990, 1996, 2001, 2005, 2010, 2014, 2003, 2011, 2013, 1996, 2014, 1997, 2006, 2012, 2007, 1981, 1990, 1995, 1996, 2000, 2005, 2012, 1996, 2002, 2006, 2001, 2007, 2011, 2006, 2012, 1998, 2004, 2011, 1990, 1995, 2000, 2011, 1996, 2007, 1997, 2001, 2012, 1996, 2001, 2006, 2012, 1996, 2001, 2012, 1989, 1997, 2005, 2012, 1995, 2001, 2010, 1998, 2005, 2012, 1990, 1995, 2006, 2011, 2007, 2012, 2003, 2002, 2012, 1990, 1998, 2001, 2006, 1995, 2005, 2011, 1982, 1990, 1996, 2001, 2006, 2001, 2012, 1990, 1995, 2000, 2007, 2011, 1981, 1996, 1999, 2006, 2011, 1989, 1996, 2007, 2007, 2006, 2011, 2013, 1990, 1996, 2001, 2007, 2011, 2001, 1996, 2006, 2011, 1998, 2001, 2001, 2008, 2013, 1998, 2005, 2001, 1981, 1995, 1999, 2006, 2011, 2007, 1996, 2006, 2011, 2011, 1996, 2000, 2014, 2005, 2007, 1996, 2001, 1996, 2001, 1998), stringsAsFactors = F)

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
amb <- read_dta(paste0(datapath, "LAPOP/2004-2014/AmericasBarometer Grand Merge 2004-2014 v3.0_FREE.dta"))
amb0 <- amb

co <- gsub("\xed", "i", names(attr(amb$pais, "labels")))
amb$pais0 <- as.integer(amb$pais)
amb <- left_join(amb, data.frame(pais = c(1:17, 21:29, 40:41),
                   country = co, stringsAsFactors = F))
amb$pais <- amb$pais0

cy_data <- amb %>% group_by(pais, year) %>%
  summarize(c_dcpo = first(country), y_dcpo = as.numeric(round(mean(year)))) %>%
  ungroup()
dump("cy_data")
temp <- readLines("dumpdata.R")
temp <- paste(temp, sep=" ", collapse=" ")
temp <- gsub("cy_data <- structure\\(list", "data.frame", temp)
temp <- gsub("\\), class = .*", ", stringsAsFactors = F)", temp)

surv <- "amb.combo"
write(temp, file = paste0("data-raw/cy_data/", surv, ".txt"))


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
ess7$country <- countrycode(ess7$cntry, "iso2c", "country.name")
ess7$year <- ess7$inwyye
ess7$year[ess7$year==9999] <- ess7$inwyys[ess7$year==9999]

id <- "cntry"
surv <- "ess7"
cy <- get.cy(ess7)
write(cy, file = paste0("data-raw/cy_data/", surv, ".txt"))

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
