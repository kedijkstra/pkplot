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

pkplot <- function(
    filePath,
    outputPath,
    simType,
    legend=TRUE,
    greyscale=FALSE,
    log_y=FALSE,
    plotTitle=""
    ) {
  
  #Validate arguments
  argument_validator(filePath,
                     outputPath,
                     simType,
                     legend,
                     greyscale,
                     log_y,
                     plotTitle)
  
  #Import data
  pkData <- read_pksim(filePath = filePath)
  
  #Validate data
    #TODO ???
  
  #Determine plot type
  plot_specification <- determine_plot_type(pkData, simType)
  
  #Construct individual plot
  if (simType == "individual") {
    p <- individual_plot(plot_specification, greyscale)
    
  }else if (simType == "population") {
    p <- population_plot(plot_specification, greyscale)
  }
  
  #Optional log scaling
  if (log_y){
    p <- log_scale(p)
  }
  
  p <- set_theme(p)
  
  #legend layout
  if (legend){
    p <- legend_layout(p)
  } else{
    p <- remove_legend(p)
  }
  
  if (length(plotTitle) > 0){
    p <- add_title(p, plotTitle)
  }
  
  p <- set_font(p)
  
  save_plot(outputPath, p, simType)
  
}