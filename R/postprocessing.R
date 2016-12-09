#Postprocessing
library(stringr)

save(out1, file = "data/output.rda")
out <- out1

x1 <- summary(out)
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
  geom_jitter(height = 0, width = .5, show.legend = FALSE) +
  ylab(expression(hat(italic(R))))

qcodes <- gm_a %>% group_by(variable) %>%
  summarize(qcode = first(qcode),
            r_n = n()) %>%
  arrange(qcode)

rcodes <- gm_a %>% group_by(variable_cp) %>%
  summarize(rcode = first(rcode),
            r_n = n()) %>%
  arrange(rcode)



b_res <- x1_sum %>%
  filter(parameter_type=="beta") %>%
  select(parameter, mean, `2.5%`, `97.5%`) %>%
  mutate(rcode = as.numeric(str_extract(parameter, "\\d+"))) %>%
  left_join(rcodes, by="rcode")
a_res <- x1_sum %>% filter(parameter_type=="alpha") %>%
  select(parameter, mean, `2.5%`, `97.5%`) %>%
  mutate(rcode = as.numeric(str_extract(parameter, "\\d+"))) %>%
  left_join(rcodes, by="rcode")
# s_dk_res <- x1_sum %>% filter(parameter_type=="sd_k") %>% select(parameter, mean, `2.5%`, `97.5%`)  %>% mutate(rcode = as.numeric(str_extract(parameter, "\\d+"))) %>% left_join(rcodes)

beep()

ktcodes <- x %>%
  group_by(country) %>%
  mutate(firstyr = first(firstyr),
         lastyr = first(lastyr)) %>%
  ungroup() %>%
  select(ktcode, ccode, tcode, country, year, firstyr, lastyr) %>%
  unique()

t_res <- summary(out, pars="theta", probs=c(.1, .9)) %>%
  first() %>%
  as.data.frame() %>%
  rownames_to_column("parameter") %>%
  as_tibble() %>%
  mutate(ktcode = as.numeric(str_extract(parameter, "\\d+"))) %>%
  left_join(ktcodes, by="ktcode")

k <- x %>%
  group_by(country) %>%
  summarize(ccode = first(ccode),
         firstyr = first(firstyr),
         lastyr = first(lastyr)) %>%
  ungroup()

gm_laws <- read_csv("data-raw/gm_laws.csv") %>% merge(k)

t_res <- merge(t_res, gm_laws)
t_res$year <- min(t_res$firstyr) + t_res$tcode - 1
t_res1 <- t_res %>%
  filter(year <= lastyr & year >= firstyr) %>%
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

# count_divergences <- function(fit) {
#   sampler_params <- get_sampler_params(fit, inc_warmup=FALSE)
#   sum(sapply(sampler_params, function(x) c(x[,'n_divergent__']))[,1])
# }

# Plots:
#   1. tolerance by country, most recent available year: cs_plot
#   2. tolerance trends, estimate plus raw data, eight countries
#   3. trends in all countries: ts_plot
#   4. probability of tolerant answer by tolerance (beta and gamma), selected items (modelled on McGann2014, fig 1)
#   5. bar chart of beta and gamma for all items?

sat_monitor <- as.data.frame(monitor(sat_fit, print = FALSE))
sat_monitor$Parameter <- as.factor(gsub("\\[.*]", "", rownames(sat_monitor)))
ggplot(subset(x1_sum, !is.nan(Rhat))) +
  aes(x = parameter, y = Rhat, color = parameter) +
  geom_jitter(height = 0, width = .5, show.legend = FALSE) +
  ylab(expression(hat(italic(R))))

