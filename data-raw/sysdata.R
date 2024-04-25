## code to prepare `sysdata` dataset goes here

plot_meta <- list(
  plot_histogram = list(
    x = "numeric"
  ),
  plot_count_by_date = list(
    x = "Date"
  ),
  plot_stacked_bar = list(
    x = "character_or_factor"
  )
)

usethis::use_data(plot_meta, internal = TRUE, overwrite = TRUE)
