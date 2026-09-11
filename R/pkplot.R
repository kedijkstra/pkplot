#Import functions
source("read_pksim.R")
source("determine_plot_type.R")
source("population_plot.R")
source("individual_plot.R")
source("save_plot.R")
source("remove_legend.R")
source("legend_layout.R")
source("add_title.R")
source("argument_validator.R")
source("set_font.R")
source("set_theme.R")
source("log_scale.R")


# Display plot in R
display_plot <- function(p, displayPlot = TRUE) {
  if (displayPlot) {
    print(p)
  }
}


pkplot <- function(
    filePath,
    outputPath,
    simType,
    legend = TRUE,
    greyscale = FALSE,
    log_y = FALSE,
    plotTitle = "",
    yLabel = "",
    xLabel = "",
    displayPlot = TRUE
) {
  
  #Validate arguments
  argument_validator(
    filePath,
    outputPath,
    simType,
    legend,
    greyscale,
    log_y,
    plotTitle,
    t_start = 0,
    t_end = 24
  )
  
  #Import data
  pkData <- read_pksim(filePath = filePath)
  
  #Validate data
  #TODO ???
  
  #Determine plot type
  plot_specification <- determine_plot_type(pkData, simType)
  
  #Construct plot
  if (simType == "individual") {
    
    p <- individual_plot(
      plot_specification,
      greyscale,
      yLabel,
      xLabel
    )
    
  } else if (simType == "population") {
    
    p <- population_plot(
      plot_specification,
      greyscale,
      yLabel,
      xLabel
    )
  }
  
  #Optional log scaling
  if (log_y) {
    p <- log_scale(p)
  }
  
  p <- set_theme(p)
  
  #Legend layout
  if (legend) {
    p <- legend_layout(p)
  } else {
    p <- remove_legend(p)
  }
  
  if (length(plotTitle) > 0) {
    p <- add_title(p, plotTitle)
  }
  
  p <- set_font(p)
  
  #Display plot
  display_plot(p, displayPlot)
  
  #Save plot
  save_plot(outputPath, p, simType)
}
