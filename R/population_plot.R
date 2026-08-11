population_plot <- function(plot_specification, greyscale) {
  
  p <- ggplot2::ggplot()
  
  grey_colors <- c("grey70", "grey50", "grey30", "grey10") #TODO: automatic generate
  
  for (i in seq_along(plot_specification$layers)) {
    
    layer <- plot_specification$layers[[i]]
    df <- layer$dataset
    
    # Find columns
    timeColumn <- grep("^Time", names(df), value = TRUE)
    concentrationColumn <- grep("^Concentration", names(df), value = TRUE)
    lowerColumn <- grep("^Lower", names(df), value = TRUE)
    upperColumn <- grep("^Upper", names(df), value = TRUE)
    curveColumn <- grep("^Curve Caption", names(df), value = TRUE)
    
    # Use curve caption as group name
    df$group <- df[[curveColumn]][1]
    
    unitList <- strsplit(concentrationColumn, " ")[[1]]
    yLabel <- paste("Concentration", 
                    unitList[length(unitList)],
                    sep=" ")
    p <- p +
      ggplot2::labs(y = yLabel)
    
    if (layer$geom == "line") {
      if (greyscale){
        p <- p +
          ggplot2::geom_line(
            data = df,
            ggplot2::aes(
              x = .data[[timeColumn]],
              y = .data[[concentrationColumn]],
              linetype = group
            ),
            linewidth = 1,
            lineend = "round",
            linejoin = "round",
            colour = "black"
          )
        
      }else{
      
        p <- p +
          ggplot2::geom_line(
            data = df,
            ggplot2::aes(
              x = .data[[timeColumn]],
              y = .data[[concentrationColumn]],
              colour = group
            ),
            linewidth = 1,
            lineend = "round",
            linejoin = "round"
          )
      }
      
    } else if (layer$geom == "range") {
      if (greyscale){
        
        p <- p +
          ggplot2::geom_ribbon(
            data = df,
            ggplot2::aes(
              x = .data[[timeColumn]],
              ymin = .data[[lowerColumn]],
              ymax = .data[[upperColumn]],
              fill = group
            ),
            alpha = 0.2
          )
        
      }else{
        p <- p +
          ggplot2::geom_ribbon(
            data = df,
            ggplot2::aes(
              x = .data[[timeColumn]],
              ymin = .data[[lowerColumn]],
              ymax = .data[[upperColumn]],
              fill = group
            ),
            alpha = 0.2,
            colour = NA
          )
      }
    
    } else if (layer$geom == "point") {
      
      p <- p +
        ggplot2::geom_point(
          data = df,
          ggplot2::aes(
            x = .data[[timeColumn]],
            y = .data[[concentrationColumn]],
            shape = group
          ),
          colour = "black",
          size = 2
        ) 
    }
  }
  
  # Add the fill scale ONLY ONCE
  if (greyscale) {
    p <- p +
      ggplot2::scale_fill_manual(
        values = grey_colors
      )
  }

  return(p)
}