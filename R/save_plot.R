save_plot <- function(outputPath, p, simType){
  ggplot2::ggsave(
    paste(simType, "png", sep = "."),
    path = outputPath,
    plot = p,
    width = 10,
    height = 6,
    units = "in",
    dpi = 700
  )
}