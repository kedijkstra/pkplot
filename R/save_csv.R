save_csv <- function(df, outputPath) {
  utils::write.csv2(
    df,
    file = outputPath,
    row.names = FALSE
  )
}