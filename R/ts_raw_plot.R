# tolerance trends, estimate plus raw data, eight countries

c8_rd <- gm_a %>% filter(ccode <= 8) %>% mutate(estimate = y_r/n) %>%
  left_join(g_res, by = c("rcode", "variable")) %>% rename(gamma_mean = mean)
c8_res <- a_res %>% filter(kk <= 8)

p_rd <- ggplot(data = c8_rd, aes(x = year, y = estimate)) +
  geom_line(aes(color = variable, alpha = gamma_mean)) +
  geom_point(aes(color = variable, alpha = gamma_mean)) + theme_bw() +
  theme(legend.position="none") +
  coord_cartesian(xlim = c(1975, 2016), ylim = c(0, 1)) +
  labs(x = NULL, y = "Tolerance") +
  geom_ribbon(data = c8_res, aes(ymin = lb, ymax = ub, linetype=NA), alpha = .25) +
  geom_line(data = c8_res) +
  facet_wrap(~country, ncol = 4) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        strip.background = element_rect(fill = "white", colour = "white"))

ggsave("paper/figures/8c_line.pdf", plot = p_rd, width = 6, height = 4)
