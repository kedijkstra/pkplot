legend_layout <- function(p) {
  p +
    ggplot2::guides(
      colour = ggplot2::guide_legend(
        order = 1,
        title.position = "top",
        label.position = "right",
        byrow = TRUE
      ),
      fill = ggplot2::guide_legend(
        order = 2,
        title.position = "top",
        label.position = "right",
        byrow = TRUE
      ),
      shape = ggplot2::guide_legend(
        order = 3,
        title.position = "top",
        label.position = "right",
        byrow = TRUE
      )
    ) +
    ggplot2::theme(
      legend.position = c(0.98, 0.98),
      legend.justification = c("right", "top"),
      
      legend.box = "vertical",
      legend.box.just = "left",
      
      legend.spacing.y = grid::unit(0.1, "cm"),
      legend.spacing.x = grid::unit(0.05, "cm"),
      
      legend.margin = ggplot2::margin(2, 2, 2, 2),
      
      legend.key.width = grid::unit(0.8, "cm"),
      legend.key.height = grid::unit(0.4, "cm"),
      
      legend.background = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank(),
      legend.text = ggplot2::element_text(size = 8)
    )
}