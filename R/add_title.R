add_title <- function(p, plotTitle) {
  p +
    ggplot2::ggtitle(plotTitle) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5)
    )
}