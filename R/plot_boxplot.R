#' Create boxplot plot of numerical variable
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param x Character string. Name of variable in table to plot.
#' @param log Logical. If TRUE, log transform x variable with `log(x + 1)`
#' (to avoid returning `Inf` values) or `log(x + 1 -min(x))` if negative numbers
#' exist in `x` (to avoid returning `NaN` values).
#' @param include_violin Logical. Include a violing plot?
#' @param include_points Logical. Include points in the plot?
#' @param varwidth Logical. If TRUE, width of boxplot is proportional to the
#' square root of the number of observations in each tbl.
#' @param show_outliers Logical. If TRUE, show outliers.
#'
#' @importFrom ggplot2 ggplot aes geom_boxplot ylab geom_violin geom_jitter labs
#' @return Histogram ggplot plot.
#' @export
plot_boxplot <- function(tbl, x,
                         include_violin = FALSE,
                         include_points = FALSE,
                         varwidth = TRUE,
                         show_outliers = TRUE,
                         log = FALSE) {
  outlier.shape <- 16
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
      y_label <- glue::glue("log({x} + 1 - min({x}))")
    } else {
      min <- 0
      y_label <- glue::glue("log({x} + 1)")
    }
    tbl[[x]] <- log(tbl[[x]] + 1 - min)
  }

  p <- ggplot(
    tbl,
    aes(
      y = .data[[x]],
      x = .data[["tbl"]],
      fill = .data[["tbl"]],
      color = .data[["tbl"]]
    )
  )

  if (include_points) {
    p <- p + geom_jitter(aes(color = .data[["tbl"]]),
      alpha = 0.05,
      width = 0.2, shape = 16
    )
    outlier.shape <- NA
    show_outliers <- FALSE
  }

  if (include_violin) {
    p <- p + geom_violin(color = NA, alpha = 0.2)
  }
  p <- p + geom_boxplot(
    aes(color = .data[["tbl"]]),
    alpha = 0.3,
    outlier.alpha = 0.4,
    notch = FALSE,
    position = "jitter",
    varwidth = TRUE,
    outliers = show_outliers,
    outlier.shape = outlier.shape,
    outlier.color = NULL,
    outlier.fill = NULL
  )

  if (log) {
    p <- p + ylab(y_label)
  }
  #attributes(p) <- list(type = "boxplot", remove_outliers = !show_outliers)
  p + labs(caption = caption)
}
