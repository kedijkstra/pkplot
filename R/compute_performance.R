#All input should:
# -Be a list/array or equivalent
# -Be the same length
# -Not contain zero's
# -Not contain NA's

compute_performance <- function(observedData, 
                                observedTime, 
                                predicted, 
                                predictedTime){
  
  #Interpolate
  observedPredicted <- approx(predictedTime, 
                              predicted, 
                              xout = observedTime,
                              method = "linear")
  
  
  #AFE
  divided <- observedPredicted$y/observedData
  log_10 <- log10(divided)
  mean_logs <- sum(log_10)/length(log_10)
  afe <- 10**mean_logs
  
  #AAFE
  absolute <- abs(log_10)
  mean_absolute <- sum(absolute)/length(absolute)
  aafe <- 10**mean_absolute
  
  #RMSE
  error <- observedData - observedPredicted$y
  error_squared <- error^2
  mse <- sum(error_squared)/length(error_squared)
  rmse <- sqrt(mse)
  
  #Format results
  df <- data.frame(
    AFE = afe,
    AAFE = aafe,
    RMSE = rmse
  )
  
  return(df)
}