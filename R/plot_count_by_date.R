#' Observation Frequency Timeline plot
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param x Character string. Name of variable in table to plot.
#' @param time_bin Character string. Temporal bin.
#' @param position Character string.  Bar position.
#' @param plot_diff Logical. Whether to plot diff between previous and current.
#' @param mark_cutoff Logical. Whether to show temporal cut-off of previous data.
#'
#' @importFrom ggplot2 ggplot aes geom_bar ylab theme xlab geom_vline scale_y_continuous geom_hline scale_fill_viridis_d scale_x_date
#' @importFrom scales breaks_extended breaks_pretty label_date_short
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
  mirror <- ifelse(position == "mirror" || plot_diff, TRUE, FALSE)
  position <- ifelse(position == "mirror", "stack", position)
  just <- ifelse(position == "dodge", 0.5, 0)
  width <- get_temporal_bar_width(time_bin)
  n_breaks <- get_time_bin_breaks(tbl, x, time_bin)

  valid_rows <- stats::complete.cases(tbl[, c("tbl", x)])
  if (any(!valid_rows)) {
    caption <- glue::glue("{sum(!valid_rows)} rows containing NA values removed.")
  } else {
    caption <- NULL
  }
  tbl <- tbl[valid_rows, c("tbl", x)]

  if (mark_cutoff) {
    prev_cutoff <- get_date_ceiling(tbl, x, time_bin)
    if (position == "dodge") {
      prev_cutoff <- as.Date(prev_cutoff - create_duration(time_bin, just))
    }
  }
  time_bins <- tbl %>%
    bin_count_by_date(
      x = x, time_bin = time_bin,
      mirror = mirror
    )
  if (plot_diff) {
    p <- time_bins %>%
      dplyr::group_by(.data[["time_bin"]]) %>%
      dplyr::summarise(diff = sum(.data[["count"]])) %>%
      dplyr::mutate(count_diff = diff < 0) %>%
      ggplot(aes(
        x = .data[["time_bin"]],
        y = .data[["diff"]],
        fill = .data[["count_diff"]],
        width = width
      )) +
      geom_bar(stat = "identity", just = just, position = "stack") +
      ylab("current count - previous count") +
      theme(legend.position = "none") +
      scale_y_continuous(breaks = breaks_extended(
        get_y_breaks(time_bins)
      )) +
      scale_fill_viridis_d()
  } else {
    p <- time_bins %>%
      ggplot(aes(
        x = .data[["time_bin"]],
        y = .data[["count"]],
        fill = .data$tbl,
        width = width
      )) +
      geom_bar(stat = "identity", just = just, position = position) +
      scale_y_continuous(
        labels = abs,
        breaks = breaks_extended(
          get_y_breaks(time_bins)
        )
      ) +
      geom_hline(yintercept = 0, linewidth = 0.2)
  }
  p <- p +
    labs(
      x = glue::glue("{x} (binned by {time_bin})"),
      caption = caption
    ) +
    scale_x_date(
      minor_breaks = "year",
      breaks = breaks_pretty(n = n_breaks),
      labels = label_date_short()
    )

  if (mark_cutoff) {
    p <- p + geom_vline(
      xintercept = as.numeric(prev_cutoff),
      linetype = 3, linewidth = 0.5
    )
  }
  p + labs(title = glue::glue("Observation Frequency Timeline of {x}"))
}

get_temporal_bar_width <- function(time_bin, scale = 0.9) {
  create_duration(time_bin, scale) / lubridate::ddays(1)
}

# Function to calculate how many time_bins are within the time series range.
#  Use this to determine the number of breaks to use in the x-axis.
get_time_bin_breaks <- function(tbl, x, time_bin, n_max = 10) {
  time_range <- range(tbl[[x]], na.rm = TRUE)
  # create a duration using lubridate and a date range vector
  breaks_n <- lubridate::interval(
    time_range[1],
    time_range[2]
  ) %/% create_duration(time_bin) + 1
  if (breaks_n < n_max) {
    return(breaks_n)
  } else {
    return(n_max)
  }
}


get_y_breaks <- function(time_bins, n_max = 5L) {
  count_range <- range(time_bins[["count"]], na.rm = TRUE)
  if (all(count_range) >= 0L) {
    count_range[1] <- 0L
  }
  breaks_n <- diff(count_range) + 1L
  if (breaks_n < n_max) {
    return(breaks_n)
  } else {
    return(n_max)
  }
}
