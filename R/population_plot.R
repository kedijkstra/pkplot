population_plot <- function(plot_specification, greyscale, yLabel, xLabel) {
  
  p <- ggplot2::ggplot()
  
  grey_colors <- c("grey70", "grey50", "grey30", "grey10") #TODO: automatic generate
  
  for (i in seq_along(plot_specification$layers)) {
    
    layer <- plot_specification$layers[[i]]
    df <- layer$dataset
    
    layer <- plot_specification$layers[[i]]
    df <- layer$dataset
    
    # Find the column containing "Concentration"
    filterColumn <- grep("^Concentration", names(df), value = TRUE, ignore.case = TRUE)
    
    if (length(filterColumn) > 0) {
      
      n_before <- nrow(df)
      
      # Keep rows from the first non-zero concentration onwards
      firstNonZero <- which(df[[filterColumn]] != 0)[1]
      
      if (!is.na(firstNonZero)) {
        df <- df[firstNonZero:nrow(df), ]
      }
      
      n_after <- nrow(df)

      print(paste("Rows removed:", n_before - n_after))
    }
    
    # Find columns
    timeColumn <- grep("^Time", names(df), value = TRUE)
    concentrationColumn <- grep("^Concentration", names(df), value = TRUE)
    lowerColumn <- grep("^Lower", names(df), value = TRUE)
    upperColumn <- grep("^Upper", names(df), value = TRUE)
    curveColumn <- grep("^Curve Caption", names(df), value = TRUE)
    
    # Use curve caption as group name
    df$group <- df[[curveColumn]][1]
    
    unitList <- strsplit(concentrationColumn, " ")[[1]]
    p <- p +
      ggplot2::labs(y = yLabel, x = xLabel)
    
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
      
      # Add observed data points
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
    
    # Add error bars for observed/measurement data if present
    if (grepl("Measurement", df$group[1], ignore.case = TRUE) &&
        length(lowerColumn) > 0 &&
        length(upperColumn) > 0) {
      
      p <- p +
        ggplot2::geom_errorbar(
          data = df,
          ggplot2::aes(
            x = .data[[timeColumn]],
            ymin = .data[[lowerColumn]],
            ymax = .data[[upperColumn]]
          ),
          width = 0.1,
          colour = "black"
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