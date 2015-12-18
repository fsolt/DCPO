# tolerance trends, estimate plus raw data, eight countries

c8_rd <- gm %>% filter(ccode <= 8) %>% mutate(estimate = y_r/n)
c8_res <- a_res %>% filter(kk <= 8)

p_rd <- ggplot(data = c8_rd, aes(x = year, y = estimate)) +
  geom_text(aes(label = rcode)) + theme_bw() +
  theme(legend.position="none") +
  coord_cartesian(xlim = c(1980, 2016), ylim = c(0, 1)) +
  labs(x = NULL, y = "Tolerance") +
  geom_ribbon(data = c8_res, aes(ymin = lb, ymax = ub, linetype=NA), alpha = .25) +
  geom_line(data = c8_res) +
  facet_wrap(~country, ncol = 2) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        strip.background = element_rect(fill = "white", colour = "white"))

