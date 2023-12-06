plot_count_by_date <- function(tbl, var,
                               time_bin = c(
                                 "day", "week", "month", "bimonth",
                                 "quarter", "season", "halfyear", "year"
                               ),
                               position = c(
                                 "stack", "dodge",
                                 "mirror", "diff"
                               ),
                               plot_diff = FALSE,
                               mark_cutoff = TRUE,
                               interactive = FALSE) {
  time_bin <- rlang::arg_match(time_bin)
  position <- rlang::arg_match(position)
  plot_diff <- ifelse(position == "diff", TRUE, FALSE)
  mirror <- ifelse(position == "mirror", TRUE, FALSE)
  position <- ifelse(position == "mirror", "stack", position)
  just <- ifelse(position == "dodge", 0.5, 0)

  if (mark_cutoff) {
    prev_cutoff <- get_date_floor(tbl, var, time_bin)
  }
  if (plot_diff) {
    p <- tbl %>%
      bin_count_by_date(
        var = var, time_bin = time_bin,
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
        var = var, time_bin = time_bin,
        mirror = mirror
      ) %>%
      ggplot(aes(
        x = .data[["time_bin"]],
        y = .data[["count"]],
        fill = .data$tbl,
        group = .data$tbl
      )) +
      geom_col(just = just, position = position)
  }
  p <- p + xlab(glue::glue("{var} (binned by {time_bin})"))
  if (mark_cutoff) {
    p <- p + geom_vline(
      xintercept = as.numeric(prev_cutoff),
      linetype = 3, linewidth = 0.5
    )
  }
  if (interactive) {
    p <- plotly::ggplotly(p)
  }
  p
}
