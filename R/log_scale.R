log_scale <- function(p){
  p + ggplot2::scale_y_log10(labels = scales::label_number(drop0trailing=TRUE))
}