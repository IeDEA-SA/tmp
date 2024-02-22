## code to prepare `sysdata` dataset goes here

plot_meta <- list(
  plot_histogram = list(
    x = "numeric"
  ),
  plot_count_by_date = list(
    x = "Date"
  )
)

usethis::use_data(plot_meta, internal = TRUE, overwrite = TRUE)
