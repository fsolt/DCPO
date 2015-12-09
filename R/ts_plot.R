# make this a function!

#ts_plot <- function(df, rows = 7, cols = 5) {
pages <- c("1:35", "36:70", "71:105")
a_res <- a_res %>% group_by(country) %>% mutate(
  last_est = last(estimate)
)
for (i in 1:3) {
  cpage <- unique(a_res$country)[c(eval(parse(text=pages[i])))]
  cp <- a_res[a_res$country %in% cpage, ]
  cp$country <- factor(cp$country, levels = cpage)

  plotx <- ggplot(data=cp, aes(x=year, y=estimate)) +
    geom_line() + theme_bw() +
    theme(legend.position="none") +
    coord_cartesian(xlim=c(1980,2016), ylim = c(0, 1)) +
    labs(x = NULL, y = "Tolerance") +
    geom_ribbon(aes(ymin = lb, ymax = ub, linetype=NA), alpha = .25) +
    facet_wrap(~country, ncol = 5) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          strip.background = element_rect(fill = "white", colour = "white"))

  pdf(file=paste0("paper/figures/ts",i,".pdf"), width=6, height = 9)
  plot(plotx)
  graphics.off()
}




