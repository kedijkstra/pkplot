individual_plot <- function(plot_specification, greyscale) {
  
  p <- ggplot2::ggplot()
  
  for (i in seq_along(plot_specification$layers)) {
    
    layer <- plot_specification$layers[[i]]
    df <- layer$dataset
    
    # Find columns
    timeColumn <- grep("^Time", names(df), value = TRUE)
    measurementColumns <- colnames(df)[!startsWith(colnames(df), "Time")]
    
    unitList <- strsplit(measurementColumns[1], " ")[[1]]
    yLabel <- paste("Concentration", 
                    unitList[length(unitList)],
                    sep=" ")
    p <- p +
      ggplot2::labs(y = yLabel)
    
    if (layer$geom == "line") {
      
      df_long <- tidyr::pivot_longer(
        df,
        cols = dplyr::all_of(measurementColumns),
        names_to = "measurement",
        values_to = "value"
      )
      
      if (greyscale) {
        
        p <- p +
          ggplot2::geom_line(
            data = df_long,
            ggplot2::aes(
              x = .data[[timeColumn]],
              y = .data[["value"]],
              linetype = measurement
            ),
            linewidth = 1,
            lineend = "round",
            linejoin = "round",
            colour = "black"
          )
        
      } else {
        
        p <- p +
          ggplot2::geom_line(
            data = df_long,
            ggplot2::aes(
              x = .data[[timeColumn]],
              y = .data[["value"]],
              color = measurement
            ),
            linewidth = 1,
            lineend = "round",
            linejoin = "round"
          )
      }
      
    } else if (layer$geom == "point") {
      
      # Use the measurement column name as the legend label
      df$.measurement <- measurementColumns[1]
      
      p <- p +
        ggplot2::geom_point(
          data = df,
          ggplot2::aes(
            x = .data[[timeColumn]],
            y = .data[[measurementColumns[1]]],
            shape = .measurement
          ),
          colour = "black",
          size = 2
        )
    }
  }
  
  return(p)
}

