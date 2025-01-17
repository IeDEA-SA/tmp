#' Categorical Frequency Timeline plot
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param date_col Character string. Name of Date variable associated with `y`
#' from which year can be determined.
#' @param y Character string. Name of category variable in table to plot for which
#' counts per year will be plotted.
#' @param mark_cutoff Logical. Whether to show temporal cut-off of previous data.
#' @param n Integer. Number of most common categories to display. All other categories ignored.
#' @param scales 	Should scales be fixed ("fixed", the default) or free in the
#' y dimension ("free_y")?
#' @return Stacked Bar plot ggplot plot.
#' @export
#' @importFrom dplyr select all_of filter mutate
#' @importFrom ggplot2 ggplot aes geom_bar facet_wrap geom_vline guides guide_axis
plot_cat_count_by_year <- function(tbl, date_col, y,
                                   mark_cutoff = TRUE,
                                   n = 4L,
                                   scales = c("fixed", "free_y")) {
  if (is.integer(tbl[[y]])) {
    tbl[[y]] <- as.character(tbl[[y]])
  }

  scales <- rlang::arg_match(scales)
  prev_cutoff <- lubridate::year(
    get_date_ceiling(tbl, date_col, "year")
  )

  tbl <- tbl %>%
    select(all_of(c(y, date_col, "tbl"))) %>%
    filter(stats::complete.cases(.)) %>%
    mutate(year = lubridate::year(.data[[date_col]]))

  tbl[[y]] <- forcats::fct_infreq(tbl[[y]]) %>%
    forcats::fct_lump_n(n)

  tbl <- tbl[tbl[[y]] != "Other", ]


  p <- tbl %>%
    ggplot(aes(x = .data[["year"]], fill = .data[["tbl"]])) +
    geom_bar(
      position = "dodge"
    ) +
    facet_wrap(~ .data[[y]], scales = scales) +
    guides(x = guide_axis(check.overlap = TRUE))

  if (mark_cutoff) {
    p <- p +
      geom_vline(xintercept = prev_cutoff - 0.5, linetype = "dashed")
  }
  p + labs(title = glue::glue("Categorical Frequency Timeline of {y} across {date_col}"))
}
