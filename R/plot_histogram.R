#' Create histogram plot of numerical variable
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param var Character string. Name of variable in table to plot.
#' @param position Character string.  Bar position.
#' @param interactive Logical. Whether to plot interactive plotly plot.
#' @param bins Integer. Number of bins.
#'
#' @importFrom ggplot2 ggplot aes geom_histogram after_stat ylab facet_grid
#' @return Histogram ggplot plot (if `interactive` = FALSE) or plotly plot
#' (if `interactive` = TRUE).
#' @export
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
