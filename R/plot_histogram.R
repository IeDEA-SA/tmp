plot_histogram <- function(tbl, var,
                           position = c(
                             "dodge",
                             "mirror", "facet"
                           ),
                           interactive = TRUE,
                           bins = 30L) {
  position <- rlang::arg_match(position)

  if (position == "dodge") {
    p <- tbl %>%
      ggplot(aes(x = .data[[var]], fill = .data[["tbl"]])) +
      geom_histogram(position = position, bins = bins)
  }
  if (position == "mirror") {
    p <- tbl %>%
      ggplot(aes(
        x = .data[[var]],
        y = after_stat(
          ifelse(.data$group == 2L,
            -.data$count, .data$count
          )
        ),
        fill = .data[["tbl"]]
      )) +
      geom_histogram(position = "stack", bins = bins) +
      ylab("count (previous data as -ve)")
  }
  if (position == "facet") {
    p <- tbl %>%
      ggplot(aes(x = .data[[var]], fill = .data[["tbl"]])) +
      geom_histogram(position = "stack", bins = bins) +
      facet_grid(~ .data[["tbl"]])
  }
  if (interactive) {
    p <- plotly::ggplotly(p)
  }
  p
}
