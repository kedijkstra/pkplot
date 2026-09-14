individual_plot <- function(
    plot_specification,
    greyscale,
    yLabel,
    xLabel
) {
  
  p <- ggplot2::ggplot()
  
  # Store maximum x-value
  x_max <- 0
  
  for (i in seq_along(plot_specification$layers)) {
    
    layer <- plot_specification$layers[[i]]
    df <- layer$dataset
    
    # Find Time column
    timeColumn <- grep(
      "^Time",
      names(df),
      value = TRUE,
      ignore.case = TRUE
    )
    
    # Simulation
    if (layer$geom == "line") {
      
      concentrationColumn <- grep(
        "Concentration",
        names(df),
        value = TRUE,
        ignore.case = TRUE
      )
      
      if (length(timeColumn) > 0 && length(concentrationColumn) > 0) {
        
        # Put all concentration columns into long format
        df_long <- tidyr::pivot_longer(
          df,
          cols = dplyr::all_of(concentrationColumn),
          names_to = "measurement",
          values_to = "value"
        )
        
        if (greyscale) {
          
          p <- p +
            ggplot2::geom_line(
              data = df_long,
              ggplot2::aes(
                x = .data[[timeColumn[1]]],
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
                x = .data[[timeColumn[1]]],
                y = .data[["value"]],
                color = measurement
              ),
              linewidth = 1,
              lineend = "round",
              linejoin = "round"
            )
        }
        
        # Update maximum x-value
        x_max <- max(
          x_max,
          max(df[[timeColumn[1]]], na.rm = TRUE)
        )
      }
    }
    
    # Observed data
    else if (layer$geom == "point") {
      
      measurementColumn <- grep(
        "Measurement",
        names(df),
        value = TRUE,
        ignore.case = TRUE
      )
      
      errorColumn <- grep(
        "^Error",
        names(df),
        value = TRUE,
        ignore.case = TRUE
      )
      
      if (
        length(timeColumn) > 0 &&
        length(measurementColumn) > 0
      ) {
        
        # Use measurement column name as legend label
        df$.measurement <- measurementColumn[1]
        
        # Observed points
        p <- p +
          ggplot2::geom_point(
            data = df,
            ggplot2::aes(
              x = .data[[timeColumn[1]]],
              y = .data[[measurementColumn[1]]],
              shape = .measurement
            ),
            colour = "black",
            size = 2
          )
        
        # Error bars: Measurement +/- Error
        if (length(errorColumn) > 0) {
          
          p <- p +
            ggplot2::geom_errorbar(
              data = df,
              ggplot2::aes(
                x = .data[[timeColumn[1]]],
                ymin = .data[[measurementColumn[1]]] -
                  .data[[errorColumn[1]]],
                ymax = .data[[measurementColumn[1]]] +
                  .data[[errorColumn[1]]]
              ),
              width = 0.1,
              colour = "black"
            )
        }
        
        # Update maximum x-value
        x_max <- max(
          x_max,
          max(df[[timeColumn[1]]], na.rm = TRUE)
        )
      }
    }
  }
  
  # Labels
  p <- p +
    ggplot2::labs(
      y = yLabel,
      x = xLabel
    )
  
  # Set x-axis maximum and make it a tick
  if (is.finite(x_max) && x_max > 0) {
    
    x_breaks <- scales::breaks_pretty(n = 6)(c(0, x_max))
    
    x_breaks <- sort(unique(c(x_breaks, x_max)))
    
    p <- p +
      ggplot2::scale_x_continuous(
        limits = c(0, x_max),
        breaks = x_breaks,
        expand = ggplot2::expansion(mult = c(0, 0))
      )
  }
  
  return(p)
}
