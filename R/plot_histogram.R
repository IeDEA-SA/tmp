#' Create histogram plot of numerical variable
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param x Character string. Name of variable in table to plot.
#' @param position Character string.  Bar position.
#' @param bins Integer. Number of bins.
#' @importFrom ggplot2 ggplot aes geom_histogram after_stat ylab facet_grid scale_y_continuous geom_hline
#' @return Histogram ggplot plot.
#' @export
plot_histogram <- function(tbl, x,
                           position = c(
                             "dodge",
                             "mirror", "facet"
                           ),
                           bins = 30L) {
  position <- rlang::arg_match(position)

  if (position == "dodge") {
    p <- tbl %>%
      ggplot(aes(x = .data[[x]], fill = .data[["tbl"]])) +
      geom_histogram(position = position, bins = bins)
  }
  if (position == "mirror") {
    p <- tbl %>%
      ggplot(aes(
        x = .data[[x]],
        y = after_stat(
          ifelse(.data$group == 2L,
            -.data$count, .data$count
          )
        ),
        fill = .data[["tbl"]]
      )) +
      geom_histogram(position = "stack", bins = bins) +
      scale_y_continuous(labels = abs) +
      geom_hline(yintercept = 0) +
      ylab("count")
  }
  if (position == "facet") {
    p <- tbl %>%
      ggplot(aes(x = .data[[x]], fill = .data[["tbl"]])) +
      geom_histogram(position = "stack", bins = bins) +
      facet_grid(~ .data[["tbl"]])
  }
  p
}
