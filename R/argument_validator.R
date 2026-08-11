argument_validator <- function(filePath,
                               outputPath,
                               simType,
                               legend,
                               greyscale,
                               plotTitle){
  sim_types <- c("population", "individual")
  checkmate::expect_subset(simType, sim_types, 
                           empty.ok = FALSE, info = "invalid simulation type")
  
  checkmate::expect_string(filePath,
                           info = "invalid filePath")
  checkmate::expect_string(outputPath,
                           info = "invalid outputPath")
  checkmate::expect_string(plotTitle,
                           info = "invalid plotTitle")
  
  bools <- c(TRUE, FALSE)
  checkmate::expect_subset(legend, bools, 
                           empty.ok = FALSE, info = "invalid legend flag")
  checkmate::expect_subset(greyscale, bools, 
                           empty.ok = FALSE, info = "invalid greyscale flag")
}