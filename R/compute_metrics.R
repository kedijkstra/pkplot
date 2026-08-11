compute_metrics <- function(means, timepoints, interval= c(0,24)){
  cmax <- max(means)
  
  half_life <- PKNCA::pk.calc.half.life(
    conc = means,
    time = timepoints
  )
  
  auc <- PKNCA::pk.calc.auc(
    conc = means,
    time = timepoints,
    interval = interval,
    method = "linear"
  )
  
  aucinf <- PKNCA::pk.calc.auc.inf.obs(
    conc = means,
    time = timepoints,
    clast.obs = PKNCA::pk.calc.clast.obs(
      conc = means,
      time = timepoints
    ),
    lambda.z = half_life$lambda.z,
    method = "linear"
  )
  
  df <- data.frame(
    Cmax = cmax,
    Tmax = PKNCA::pk.calc.tmax(
      conc = means,
      time = timepoints
    ),
    HalfLife = half_life$half.life,
    LambdaZ = half_life$lambda.z,
    AUC = auc,
    AUCinf = aucinf
  )
  
  return (df)
}