library(countrycode)

cc_dcpo <- countrycode::codelist %>%
  select(country.name.en, country.name.en.regex, iso2c, iso3c, wb_api3c) %>%
  mutate(dcpo.name = country.name.en %>%
           str_replace(" - ", "-") %>%
           str_replace(" \\(.*", "") %>%
           str_replace(", [^U]*", "") %>%
           str_replace("^(United )?Republic of ", "") %>%
           str_replace("^The former Yugoslav Republic of ", "") %>%
           str_replace(" of [GA].*", "") %>%
           str_replace("Czechia", "Czech Republic") %>%
           str_replace("Russian Federation", "Russia") %>%
           str_replace("Syrian Arab Republic", "Syria") %>%
           str_replace("Côte d’Ivoire", "Côte d'Ivoire") %>%
           str_replace("Hong Kong SAR China", "Hong Kong") %>%
           str_replace("South Korea", "Korea"),
         country.name.en.regex = case_when(dcpo.name == "Russia" ~ "\\brussia",
                                           dcpo.name == "Central African Republic" ~ "\\bcentral.african.rep",
                                           dcpo.name == "Micronesia" ~ "micronesia",
                                           dcpo.name == "Bolivia" ~ "bolivia\\b",
                                           dcpo.name == "Dominica" ~ "dominica\\b",
                                           dcpo.name == "Dominican Republic" ~ "dominican",
                                           dcpo.name == "Cyprus" ~ "^(?!northern.)cyprus",
                                           TRUE ~ country.name.en.regex)) %>%
  full_join(tribble(~country.name.en, ~dcpo.name, ~country.name.en.regex,
                    "Soviet Union", "Soviet Union", "soviet.?union|u\\.?s\\.?s\\.?r|socialist.?republics",
                    "Northern Ireland", "Northern Ireland", "north.*\\sireland"),
            by = c("country.name.en", "country.name.en.regex", "dcpo.name"))

devtools::use_data(cc_dcpo, overwrite = TRUE)
