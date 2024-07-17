## code to prepare `sysdata` dataset goes here

plot_meta <- list(
  plot_count_by_date = list(
    args = list(
      x = "Date"
    ),
    label = "Observation Frequency Timeline"
  ),
  plot_missing = list(
    args = NULL,
    label = "Missing Values"
  ),
  plot_histogram = list(
    args = list(
      x = "numeric"
    ),
    label = "Value Distribution/Histogram"
  ),
  plot_boxplot = list(
    args = list(
      x = "numeric"
    ),
    label = "Value Distribution/Boxplot"
  ),
  plot_stacked_bar = list(
    args = list(
      x = "character_or_factor_or_integer"
    ),
    label = "Categorical Distribution"
  ),
  plot_cat_count_by_year = list(
    args = list(
      x = "Date",
      y = "character_or_factor_or_integer"
    ),
    label = "Categorical Frequency Timeline"
  ),
  plot_events_by_year = list(
    args = list(
      x = "Date",
      y = "Date"
    ),
    label = "Yearly Event Comparison"
  ),
  plot_summary_complete = list(
    args = NULL,
    label = "Study Subject Data Completeness"
  )
)

usethis::use_data(plot_meta, internal = TRUE, overwrite = TRUE)
