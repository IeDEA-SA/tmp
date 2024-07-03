#' Create stacked bar plot of counts or percentages of n most common
#'  categories.
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param x Character string. Name of variable in table to plot.
#' @param position Character string.  Bar position. Either "fill" (percentages)
#' or "stack" (counts).
#' @param n Integer. Number of most common categories to display. All other
#' categories recoded to "Other".
#' @param na.rm Logical. Remove NA values from the table.
#'
#' @importFrom ggplot2 ggplot aes geom_bar scale_fill_manual ylab scale_y_continuous
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
                             na.rm = TRUE) {
  position <- arg_match(position)
  palette <- c(gg_color_hue(n), "grey")
  if (na.rm) {
    tbl <- filter(tbl, !is.na(.data[[x]]))
  }

  if (is.integer(tbl[[x]])) {
    tbl[[x]] <- as.character(tbl[[x]])
  }

  tbl[[x]] <- fct_infreq(tbl[[x]]) %>%
    fct_lump_n(n)

  p <- tbl %>%
    ggplot(aes(x = .data[["tbl"]], fill = .data[[x]])) +
    geom_bar(
      position = position,
      colour = "white"
    ) +
    scale_fill_manual(values = palette)

  if (position == "fill") {
    p <- p +
      scale_y_continuous(labels = percent) +
      ylab("Percentage")
  }
  p
}

# source: https://stackoverflow.com/questions/8197559/emulate-ggplot2-default-color-palette
gg_color_hue <- function(n) {
  hues <- seq(15, 375, length = n + 1)
  grDevices::hcl(h = hues, l = 65, c = 100)[seq(n)]
}
