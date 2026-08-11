determine_plot_type <- function(pkData, simType){
  plot_specification <- list(
    data_type = simType,
    layers = list()
  )
  
  #Individual simulation
  if (simType == "individual"){
    
    #Get the amount of datapoints
    dflength <- sapply(pkData, nrow)
    
    #Check whether it is an observation or simulation
    maxLength <- max(dflength)
    for(i in seq_along(pkData)){
      
      #If simulation
      if(dflength[i] == maxLength){
        plot_specification$layers[[i]] <- list(
          dataset = pkData[[i]],
          geom = "line"
        )
      }
      
      #If observation
      else{
        plot_specification$layers[[i]] <- list(
          dataset = pkData[[i]],
          geom = "point"
        )
      }
    }
    
    
  #Population simulation
  } else if (simType == "population"){
    
      #Get concentration column
      for (c in colnames(pkData[[1]])){
        if (startsWith(c, "Concentration")){
          concentrationColumn <- c
        }
      }
      
      #Get unique captions
      uniqueCaptions <- unique(pkData[[1]]$`Curve Caption`)
      
      #Split based on captions
      split_dfs <- split(pkData[[1]], pkData[[1]]$`Curve Caption`)
      
      #Get the amount of datapoints
      dflength <- sapply(split_dfs, nrow)
      
      #Check whether it is an observation or simulation
      maxLength <- max(dflength)
      for (i in seq_along(uniqueCaptions)){
        caption <- uniqueCaptions[i]
        
        #If simulation
        if (nrow(split_dfs[[caption]]) == maxLength){
          
          #If range
          if (all(is.na(split_dfs[[caption]][[concentrationColumn]]))){
            plot_specification$layers[[i]] <- list(
              dataset = split_dfs[[caption]],
              geom = "range"
            )
            
          #If single value (eg mean/median)
          } else {
            plot_specification$layers[[i]] <- list(
              dataset = split_dfs[[caption]],
              geom = "line"
            )
          }
        
        #If observation  
        } else {
          plot_specification$layers[[i]] <- list(
              dataset = split_dfs[[caption]],
              geom = "point"
            )
        }
    }
  }  
  return(plot_specification)
}