#' Create count by date plot of Date variable
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param x Character string. Name of variable in table to plot.
#' @param time_bin Character string. Temporal bin.
#' @param position Character string.  Bar position.
#' @param plot_diff Logical. Whether to plot diff between previous and current.
#' @param mark_cutoff Logical. Whether to show temporal cut-off of previous data.
#'
#' @importFrom ggplot2 ggplot aes geom_col ylab theme xlab geom_vline scale_y_continuous geom_hline
#' @return Count by date ggplot plot.
#' (if `interactive` = TRUE).
#' @export
plot_count_by_date <- function(tbl, x,
                               time_bin = c(
                                 "day", "week", "month", "bimonth",
                                 "quarter", "season", "halfyear", "year"
                               ),
                               position = c(
                                 "stack", "dodge",
                                 "mirror", "diff"
                               ),
                               plot_diff = FALSE,
                               mark_cutoff = TRUE) {
  time_bin <- rlang::arg_match(time_bin)
  position <- rlang::arg_match(position)
  plot_diff <- ifelse(position == "diff", TRUE, FALSE)
  mirror <- ifelse(position == "mirror", TRUE, FALSE)
  position <- ifelse(position == "mirror", "stack", position)
  just <- ifelse(position == "dodge", 0.5, 0)

  if (mark_cutoff) {
    prev_cutoff <- get_date_ceiling(tbl, x, time_bin)
    if (position == "dodge") {
      prev_cutoff <- as.Date(prev_cutoff - create_duration(time_bin, just))
    }
  }
  if (plot_diff) {
    p <- tbl %>%
      bin_count_by_date(
        x = x, time_bin = time_bin,
        mirror = TRUE
      ) %>%
      dplyr::group_by(.data[["time_bin"]]) %>%
      dplyr::summarise(diff = sum(.data[["count"]])) %>%
      dplyr::mutate(count_diff = diff < 0) %>%
      ggplot(aes(
        x = .data[["time_bin"]],
        y = .data[["diff"]],
        fill = .data[["count_diff"]]
      )) +
      geom_col(just = just, position = "stack") +
      ylab("current count - previous count") +
      theme(legend.position = "none")
  } else {
    p <- tbl %>%
      bin_count_by_date(
        x = x, time_bin = time_bin,
        mirror = mirror
      ) %>%
      ggplot(aes(
        x = .data[["time_bin"]],
        y = .data[["count"]],
        fill = .data$tbl,
        group = .data$tbl
      )) +
      geom_col(just = just, position = position) +
      scale_y_continuous(labels = abs) +
      geom_hline(yintercept = 0)
  }
  p <- p + xlab(glue::glue("{x} (binned by {time_bin})"))
  if (mark_cutoff) {
    p <- p + geom_vline(
      xintercept = as.numeric(prev_cutoff),
      linetype = 3, linewidth = 0.5
    )
  }
  p
}
