#Postprocessing
library(stringr)

x1 <- summary(out1)
write.table(as.data.frame(x1$summary), file="data/x1.csv", sep = ",")
x1_sum <- as.data.frame(x1$summary)
x1_sum$parameter <- rownames(x1_sum)
# x1_sum <- read_csv("x1.csv")
# names(x1_sum)[2] <- "mean"
x1_sum$parameter_type <- gsub("([^[]*).*", "\\1", x1_sum$parameter)
View(x1_sum)
View(x1_sum[x1_sum$Rhat>1.1,])
View(x1_sum[x1_sum$Rhat>1.2,])

ggplot(x1_sum) +
  aes(x = parameter_type, y = Rhat, color = parameter_type) +
  geom_jitter(height = 0, width = .5, show.legend = FALSE, alpha = .2) +
  ylab(expression(hat(italic(R))))
ggsave(str_c("paper/figures/rhat_", iter, ".pdf"))


qcodes <- x %>% group_by(variable) %>%
  summarize(qcode = first(qcode),
            r_n = n()) %>%
  arrange(qcode)

rcodes <- x %>% group_by(variable_cp) %>%
  summarize(rcode = first(rcode),
            r_n = n()) %>%
  arrange(rcode)

kcodes <- x %>%
  group_by(country) %>%
  summarize(ccode = first(ccode),
            firstyr = first(firstyr),
            lastyr = first(lastyr)) %>%
  ungroup()

ktcodes <- tibble(ccode = rep(1:max(x$ccode), each = max(x$tcode)),
                  tcode = rep(1:max(x$tcode), times = max(x$ccode)),
                  ktcode = (ccode-1)*max(tcode)+tcode) %>%
  left_join(kcodes, by = "ccode") %>%
  mutate(year = min(firstyr) + tcode - 1)

b_res <- x1_sum %>%
  filter(parameter_type=="beta") %>%
  select(parameter, mean, `2.5%`, `97.5%`) %>%
  mutate(rcode = as.numeric(str_extract(parameter, "\\d+"))) %>%
  left_join(rcodes, by="rcode")

a_res <- x1_sum %>% filter(parameter_type=="alpha") %>%
  select(parameter, mean, `2.5%`, `97.5%`) %>%
  mutate(rcode = as.numeric(str_extract(parameter, "\\d+"))) %>%
  left_join(rcodes, by="rcode")

t_res <- summary(out1, pars="theta", probs=c(.1, .9)) %>%
  first() %>%
  as.data.frame() %>%
  rownames_to_column("parameter") %>%
  as_tibble() %>%
  mutate(ktcode = as.numeric(str_extract(parameter, "\\d+"))) %>%
  left_join(ktcodes, by="ktcode") %>%
  arrange(ccode, tcode)

gm_laws <- read_csv("data-raw/gm_laws.csv") %>% right_join(k, by = "country")

t_res1 <- t_res %>%
  left_join(gm_laws, by = c("ccode", "country", "firstyr", "lastyr")) %>%
  transmute(country = country,
            term = country,
            kk = ccode,
            year = year,
            estimate = mean,
            lb = `10%`,
            ub = `90%`,
            law = ifelse(!is.na(gm) & (year >= gm | year==lastyr), "Marriage",
                         ifelse(!is.na(civ) & (year >= civ | year==lastyr), "Civil Union",
                                "None"))) %>%
  arrange(kk, year)

# Plots:
#   1. tolerance by country, most recent available year: cs_plot
#   2. tolerance trends, estimate plus raw data, eight countries
#   3. trends in all countries: ts_plot
#   4. probability of tolerant answer by tolerance (beta and gamma), selected items (modelled on McGann2014, fig 1)
#   5. bar chart of beta and gamma for all items?
