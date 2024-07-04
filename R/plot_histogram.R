#' Create histogram plot of numerical variable
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param x Character string. Name of variable in table to plot.
#' @param position Character string.  Bar position.
#' @param bins Integer. Number of bins.
#' @param log Logical. If TRUE, log transform x variable with `log(x + 1)`
#' (to avoid returning `Inf` values) or `log(x + 1 -min(x))` if negative numbers
#' exist in `x` (to avoid returning `NaN` values).
#'
#' @importFrom ggplot2 ggplot aes geom_histogram after_stat ylab facet_grid scale_y_continuous geom_hline
#' @return Histogram ggplot plot.
#' @export
plot_histogram <- function(tbl, x,
                           position = c(
                             "dodge",
                             "mirror", "facet"
                           ),
                           bins = 30L,
                           log = FALSE) {
  position <- rlang::arg_match(position)

  # Remove NAs
  valid_rows <- stats::complete.cases(tbl[, c("tbl", x)])
  if (any(!valid_rows)) {
    caption <- glue::glue("{sum(!valid_rows)} rows containing NA values removed.")
  } else {
    caption <- NULL
  }
  tbl <- tbl[valid_rows, c("tbl", x)]

  if (log) {
    any_neg <- any(tbl[[x]] < 0)
    if (any_neg) {
      min <- min(tbl[[x]], na.rm = TRUE)
      x_label <- glue::glue("log({x} + 1 - min({x}))")
    } else {
      min <- 0
      x_label <- glue::glue("log({x} + 1)")
    }
    tbl[[x]] <- log(tbl[[x]] + 1 - min)
  }

  if (position == "dodge") {
    p <- tbl %>%
      ggplot(aes(x = .data[[x]], fill = .data[["tbl"]])) +
      geom_histogram(position = position, bins = bins)
  }
  if (position == "mirror") {
    p <- tbl %>%
      ggplot(aes(
        x = .data[[x]],
        fill = .data[["tbl"]]
      )) +
      suppressWarnings(
        geom_histogram(
          aes(
            y = after_stat(
              ifelse(.data$group == 2L,
                -.data$count, .data$count
              )
            ),
            text = paste("count:", after_stat(.data$count))
          ),
          position = "stack", bins = bins
        )
      ) +
      scale_y_continuous(name = "count", labels = abs) +
      geom_hline(yintercept = 0, linewidth = 0.2)
  }
  if (position == "facet") {
    p <- tbl %>%
      ggplot(aes(x = .data[[x]], fill = .data[["tbl"]])) +
      geom_histogram(position = "stack", bins = bins) +
      facet_grid(~ .data[["tbl"]])
  }
  if (log) {
    p <- p + xlab(x_label)
  }
  p + labs(caption = caption)
}
