set_font <- function(p) {
  p + ggplot2::theme(
    text = ggplot2::element_text(family = "Verdana")
  )
}