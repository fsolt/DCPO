#Postprocessing


x1 <- summary(out1)
write.table(as.data.frame(x1$summary), file="x1.csv", sep = ",")
x1_sum <- as.data.frame(x1$summary)
x1_sum$parameter <- rownames(x1_sum)
x1_sum$parameter_type <- gsub("([^[]*).*", "\\1", x1_sum$parameter)
View(x1_sum)
View(x1_sum[x1_sum$Rhat>1.1,])
View(x1_sum[x1_sum$Rhat>1.2,])
beep()

x2 <- summary(out1, pars="alpha", probs=c(.1, .9))
x2 <- as.data.frame(x2$summary)

x2$ccode <- as.numeric(gsub("alpha\\[([0-9]*),[0-9]*\\]", "\\1", row.names(x2)))
x2$tcode <- as.numeric(gsub("alpha\\[[0-9]*,([0-9]*)\\]", "\\1", row.names(x2)))

k <- gm %>% group_by(country) %>% summarize(
  ccode = first(ccode),
  firstyr = first(firstyr),
  lastyr = first(lastyr))

x2 <- merge(x2, k, all=T)
x2$year <- min(x2$firstyr) + x2$tcode - 1

rcodes <- gm %>% group_by(variable) %>%
  summarize(rcode = first(rcode)) %>%
  arrange(rcode)

x1_sum %>% filter(parameter_type=="beta") %>% select(parameter, mean, `2.5%`, `97.5%`)  %>% mutate(rcode = as.numeric(str_extract(parameter, "\\d+"))) %>% left_join(rcodes)
x1_sum %>% filter(parameter_type=="gamma") %>% select(parameter, mean, `2.5%`, `97.5%`)  %>% mutate(rcode = as.numeric(str_extract(parameter, "\\d+"))) %>% left_join(rcodes)


x2_ <- x2
x2 <- x2[which(x2$year <= x2$lastyr & x2$year >= x2$firstyr), c("country", "ccode", "year", "mean", "sd", "10%", "90%")]

# Plots:
#   1. tolerance by country, most recent available year
#   2. tolerance trends, estimate plus raw data, eight countries
#   3. trends in all countries
#   4. probability of tolerant answer by tolerance (beta and gamma), selected items

library(ggplot2)
x2$kk <- x2$ccode

pages <- c("1:35", "36:70", "71:105")

names(x2)[which(names(x2)=="10%")] <- "lb"
names(x2)[which(names(x2)=="90%")] <- "ub"


# 3. trends in all countries
plotlist <- list()
for (i in 1:3) {
  cpage <- unique(x3$country)[c(eval(parse(text=pages[i])))]
  x4 <- x3[x3$country %in% cpage, ]
  x4$country <- factor(x4$country, levels = cpage)

  plotx <- ggplot(data=x4, aes(x=year, y=mean)) +
    geom_line() + theme_bw() +
    theme(legend.position="none") +
    coord_cartesian(xlim=c(1980,2016), ylim = c(0, 1)) +
    labs(x = "Year", y = "Tolerance") +
    geom_ribbon(aes(ymin = lb, ymax = ub, linetype=NA), alpha = .25) +
    facet_wrap(~country, ncol = 5) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          strip.background = element_rect(fill = "white", colour = "white"))

  pdf(file=paste0("plot",i,".pdf"), width=6, height = 9)
  plot(plotx)
  graphics.off()
}

gm_laws <- read_csv("gm_laws.csv") %>% merge(k)
gm_laws %>% mutate(preyrs = civ-firstyr,
                   postyrs = lastyr-civ) %>%
  filter(!is.na(postyrs)) %>%
  select(country, preyrs, postyrs)


