#' Categorical Distribution plot
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param x Character string. Name of variable in table to plot.
#' @param position Character string.  Bar position. Either "fill" (percentages)
#' or "stack" (counts).
#' @param n Integer. Number of most common categories to display. All other
#' categories recoded to "Other".
#' @param na.rm Logical. Remove NA values from the table.
#' @param other.rm Logical. Remove "Other" values from the table.
#'
#' @importFrom ggplot2 ggplot aes geom_bar scale_fill_manual labs scale_y_continuous
#' @importFrom forcats fct_infreq fct_lump_n
#' @importFrom scales percent
#' @importFrom dplyr filter
#' @importFrom rlang arg_match
#' @return Stacked Bar plot ggplot plot.
#' @export
plot_stacked_bar <- function(tbl, x,
                             position = c(
                               "fill", "stack"
                             ),
                             n = 8L,
                             na.rm = TRUE,
                             other.rm = FALSE) {
  position <- arg_match(position)
  palette <- c(gg_color_hue(n), "grey")
  caption <- NULL
  if (na.rm) {
    na_rows <- is.na(tbl[[x]])
    if (any(na_rows)) {
      caption <- glue::glue("{sum(na_rows)} NA values removed.")
      tbl <- filter(tbl, !is.na(.data[[x]]))
    }
  }

  if (is.integer(tbl[[x]])) {
    tbl[[x]] <- as.character(tbl[[x]])
  }

  tbl[[x]] <- fct_infreq(tbl[[x]]) %>%
    fct_lump_n(n, ties.method = "first")

  total_n <- nrow(tbl)
  non_other_n <- sum(stats::na.omit(tbl[[x]]) != "Other")
  other_n <- total_n - non_other_n

  if (other.rm) {
    tbl <- filter(tbl, .data[[x]] != "Other")
    caption <- paste(other_n, "'Other'",
                 if (na.rm) {"/ NA "} else {""},
                "values out of", total_n, "removed.")
    } else if (non_other_n / other_n / n < 0.01) {
    caption <- paste(
      caption,
      paste(
      "Each category less that 1% of 'Other'",
      if (na.rm) {"/NA.\n "} else {".\n "},
      "Too many categories to plot.
    Consider removing 'Other'."
      ),
      sep = "\n")
    }

  p <- tbl %>%
    ggplot(aes(x = .data[["tbl"]], fill = .data[[x]])) +
    geom_bar(
      position = position,
      colour = "white"
    ) +
    scale_fill_manual(values = palette) +
    labs(caption = caption)

  if (position == "fill") {
    p <- p +
      scale_y_continuous(labels = percent) +
      labs(
        y = "Percentage",
        caption = caption,
        title = glue::glue(
          "Categorical Distribution of {x} across top {n} categories")

      )
  }
  p
}

# source: https://stackoverflow.com/questions/8197559/emulate-ggplot2-default-color-palette
gg_color_hue <- function(n) {
  hues <- seq(15, 375, length = n + 1)
  grDevices::hcl(h = hues, l = 65, c = 100)[seq(n)]
}
