read_pksim <- function(filePath){
  #Obtain sheets
  sheets <- readxl::excel_sheets(filePath)
  
  #Empty list
  pkData <- list()
  
  #Loop over sheets
  for (sheet in sheets){
    #Read sheet
    d <- readxl::read_excel(filePath, sheet = sheet)
    
    #Store sheet as dataframe in list
    pkData[[sheet]] <- d
  }
  
  return(pkData)
}