remove_legend <- function(p) {
  return(p + ggplot2::theme(legend.position = "none"))
}