p1_data <- a_res %>% group_by(country) %>% top_n(1, year) %>% ungroup() %>%
  arrange(-estimate) %>% mutate(half = ntile(estimate, 2),
                                ranked = row_number(estimate),
                                yr = year)
p1_data$yr <- car::recode(p1_data$yr, "2001:2010 = 'Before 2011'")
p1_data$yr <- factor(p1_data$yr, levels = c("Before 2011", "2011", "2012", "2013", "2014", "2015"))

p1a <- p1_data %>% filter(half==2) %>% ggplot(aes(x = estimate, y = row_number(estimate), colour=yr)) +
  geom_point(na.rm = TRUE) +
  theme_bw() + theme(legend.position="none") +
  geom_segment(aes(x = lb,
                   xend = ub,
                   y = row_number(estimate), yend = row_number(estimate),
                   colour=yr), na.rm = TRUE) +
  scale_y_discrete(breaks = row_number(p1_data$estimate), labels=p1_data$country) +
  coord_cartesian(xlim=c(0, 1)) +
  ylab("") + xlab("")
