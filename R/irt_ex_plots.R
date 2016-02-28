irt_ex <- data_frame(alpha = rep(seq(0, 1, length.out = 101), times = 3),
                     gamma = rep(c(.2, .35, .1), each=101),
                     beta = .5,
                     group = paste0("g", gamma, "b", beta),
                     pane = "Varying Discrimination") %>%
  rbind(data_frame(alpha = rep(seq(0, 1, length.out = 101), times = 3),
                   gamma = .2,
                   beta = rep(c(.5, .25, .75), each=101),
                   group = paste0("g", gamma, "b", beta),
                   pane = "Varying Difficulty")) %>%
  mutate(p = plogis((alpha - beta)/gamma),
         group2 = rep(c(2, 1, 3, 5, 4, 6), each=101))

ggplot(irt_ex,
       aes(alpha, p, group = group, color = group)) +
  geom_line() + facet_wrap(~pane)

groups <- list(5, 4:5, 4:6)

for (i in 1:3) {
  beta_plot <- ggplot(irt_ex %>% filter(group2 %in% groups[[i]]),
                      aes(alpha, p, group = factor(group2), color = factor(group2))) +
    geom_line() + theme_bw() +
    theme(legend.position="none") +
    coord_cartesian(ylim = c(0, 1)) +
    labs(x = "Positive Attitude", y = "Probability of a Positive Response") +
    ggtitle("Varying Item Difficulty") +
    scale_colour_manual(values = c("4" = "#FF6600","5" = "#000098","6" = "darkgreen"))
  ggsave(paste0("paper/figures/ex_beta_plot", i, ".pdf"))
}

groups <- list(2, 1:2, 1:3)

for (i in 1:3) {
gamma_plot <- ggplot(irt_ex %>% filter(group2 %in% groups[[i]]),
                    aes(alpha, p, group = factor(group2), color = factor(group2))) +
  geom_line() + theme_bw() +
  theme(legend.position="none") +
  coord_cartesian(ylim = c(0, 1)) +
  labs(x = "Positive Attitude", y = "Probability of a Positive Response") +
  ggtitle("Varying Item Discrimination") +
  scale_colour_manual(values = c("1" = "#FF6600","2" = "#000098","3" = "darkgreen"))
ggsave(paste0("paper/figures/ex_gamma_plot", i, ".pdf"))
}
