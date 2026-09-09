#Import functions
source("compute_metrics.R")
source("read_pksim.R")
source("save_csv.R")
source("argument_validator.R")

pkmetrics <- function(filePath,
                      outputPath,
                      simType,
                      t_start=0,
                      t_end=24){
  
  argument_validator(filePath,
                     outputPath,
                     simType,
                     legend=FALSE,
                     greyscale=FALSE,
                     log_y=FALSE,
                     plotTitle="",
                     t_start=t_start,
                     t_end=t_end
                     )
  
  pkData <- read_pksim(filePath = filePath)
  
  #Validate data
  #TODO ???
  
  plot_specification <- determine_plot_type(pkData, simType)
  
  
  if (simType == "individual") {
    for (i in seq_along(plot_specification$layers)) {
  
      layer <- plot_specification$layers[[i]]
      df <- layer$dataset
      
      # Find columns
      timeColumn <- grep("^Time", names(df), value = TRUE)
      concentrationColumn <- grep("^Concentration", names(df), value = TRUE)
      
      stopifnot(length(timeColumn) == 1) #TODO also add in other scripts
      stopifnot(length(concentrationColumn) == 1)
      
      measurementColumns <- colnames(df)[!startsWith(colnames(df), "Time")] 
      
      for (mc in measurementColumns){
        metrics <- compute_metrics(df[[mc]], df[[timeColumn]], c(t_start, t_end))
        save_csv(metrics, paste(outputPath, fs::path_sanitize(mc), ".csv" ,sep=""))
      }
      
  }
  }else if (simType == "population"){
    for (i in seq_along(plot_specification$layers)) {
      
      layer <- plot_specification$layers[[i]]
      df <- layer$dataset
      
      if (layer$geom != "range") {
        
        # Find columns
        timeColumn <- grep("^Time", names(df), value = TRUE)
        concentrationColumn <- grep("^Concentration", names(df), value = TRUE)
        curveColumn <- grep("^Curve Caption", names(df), value = TRUE)

        metrics <- compute_metrics(df[[concentrationColumn]], df[[timeColumn]], c(t_start, t_end))
        save_csv(metrics, paste(outputPath, 
                                fs::path_sanitize(as.character(df[[curveColumn]][1])), 
                                ".csv" ,sep=""))
      }
    }
  }
}