## code to prepare `sysdata` dataset goes here

plot_meta <- list(
  plot_histogram = list(
    x = "numeric"
  ),
  plot_count_by_date = list(
    x = "Date"
  ),
  plot_stacked_bar = list(
    x = "character_or_factor_or_integer"
  ),
  plot_cat_count_by_year = list(
    x = "Date",
    y = "character_or_factor_or_integer"
  ),
  plot_missing = list(
    x = "all"
  ),
  plot_summary_complete = NULL
)

usethis::use_data(plot_meta, internal = TRUE, overwrite = TRUE)
