read_pksim <- function(filePath){
  
  # Obtain sheets
  sheets <- readxl::excel_sheets(filePath)
  
  # Empty list
  pkData <- list()
  
  # Loop over sheets
  for (sheet in sheets){
    
    # Read sheet normally first to obtain column names
    d <- readxl::read_excel(
      filePath,
      sheet = sheet
    )
    
    # Determine column types
    col_types <- ifelse(
      names(d) %in% c("Pane Caption", "Curve Caption"),
      "text",
      "numeric"
    )
    
    # Read sheet again with specified column types
    d <- readxl::read_excel(
      filePath,
      sheet = sheet,
      col_types = col_types
    )
    
    # Store sheet as dataframe in list
    pkData[[sheet]] <- d
  }
  
  return(pkData)
}