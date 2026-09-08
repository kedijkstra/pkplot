individual_plot <- function(plot_specification, greyscale, yLabel, xLabel) {
  
  p <- ggplot2::ggplot()
  
  for (i in seq_along(plot_specification$layers)) {
    
    layer <- plot_specification$layers[[i]]
    df <- layer$dataset
    
    # Find the column containing "Concentration"
    filterColumn <- grep(
      "^.*Concentration",
      names(df),
      value = TRUE,
      ignore.case = TRUE
    )
    
    if (length(filterColumn) == 1) {
      
      n_before <- nrow(df)
      
      # Keep rows from the first non-zero concentration onwards
      firstNonZero <- which(df[[filterColumn]] != 0)[1]
      
      if (!is.na(firstNonZero) && firstNonZero > 1) {
        df <- df[firstNonZero:nrow(df), , drop = FALSE]
      }
      
      n_after <- nrow(df)
      
      print(paste("Rows removed:", n_before - n_after))
    }
    
    # Find columns
    timeColumn <- grep(
      "^Time",
      names(df),
      value = TRUE,
      ignore.case = TRUE
    )
    
    # All columns except Time and Error
    measurementColumns <- colnames(df)[
      !startsWith(colnames(df), "Time") &
        !startsWith(colnames(df), "Error")
    ]
    
    # Identify Error column separately
    errorColumn <- grep(
      "^Error",
      names(df),
      value = TRUE,
      ignore.case = TRUE
    )
    
    # Apply user-defined axis labels
    p <- p +
      ggplot2::labs(
        y = yLabel,
        x = xLabel
      )
    
    # Predicted data
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
    
    # Add error bars for observed data if available
    if (length(errorColumn) == 1 && length(measurementColumns) == 1) {
      
      df$lower <- df[[measurementColumns[1]]] - df[[errorColumn]]
      df$upper <- df[[measurementColumns[1]]] + df[[errorColumn]]
      
      p <- p +
        ggplot2::geom_errorbar(
          data = df,
          ggplot2::aes(
            x = .data[[timeColumn]],
            ymin = .data[["lower"]],
            ymax = .data[["upper"]]
          ),
          width = 0.1,
          colour = "black"
        )
    }
  }
  
  return(p)
}