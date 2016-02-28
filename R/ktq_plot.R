ktq <- gm_a %>%
  mutate(ktq = paste0(country, year, variable)) %>%
  group_by(variable) %>%
  summarize(kt = n_distinct(ktq)) %>%
  arrange(kt) %>%
  mutate(var = factor(variable, levels = variable[order(kt, decreasing = TRUE)])) %>%
  ungroup()

ggplot(ktq %>% filter(kt>30), aes(x = var, y = kt)) +
  geom_bar(fill = "#011993", stat = "identity") +
  labs(x = NULL, y=NULL) +
  theme_bw() +
  ggtitle("Count of Country-Years by Item")
ggsave("paper/figures/ktq.pdf", width = 9, height = 3)
