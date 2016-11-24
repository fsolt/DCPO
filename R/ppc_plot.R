# make this a function!

p_res <- x1_sum %>%
  filter(parameter_type=="p") %>%
  select(parameter, mean, `2.5%`, `97.5%`) %>%
  cbind(gm_a) %>%
  mutate(p_mean = mean,
         lb = `2.5%`,
         ub = `97.5%`,
         y_mean = y_r/n,
         ok = y_mean <= ub & y_mean >= lb)

mean(p_res$ok)

ggplot(p_res[p_res$cutpoint==1,], aes(y_mean, p_mean)) +
  geom_point(alpha = .05) +
  geom_pointrange(aes(ymin = lb, ymax = ub), alpha = .05) +
  facet_wrap(~variable, ncol = 4) +
  geom_abline(slope = 1, color = "#000098") +
  theme_bw() +
  labs(x = "Observed", y = "Predicted") +
  ggtitle("Posterior Predictive Checks\nAll Questions, First Cutpoint") +
  theme(strip.background = element_rect(fill = "white", colour = "white"),
        axis.text  = element_text(size=6))
ggsave("Paper/Figures/ppc1a.pdf", width = 6, height = 6)

