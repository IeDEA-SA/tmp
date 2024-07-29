#' Create nested bar plots of counts of two date variables per year.
#'
#' Primarily used to compare `recart_d` to `enrol_d` but can be used to compare
#' the relative completion of two related events, completion of which is recorded
#' via dates each event occurred.
#' The first event, `event1`, is displayed as a transparent wider bar while
#' the second event, `event2`, which expected to always occur once the first
#' event is complete, is displayed as a solid, narrower bar within.
#' Note that if `t0_tally` is `TRUE`, all records of the second event (`event2`) are counted
#'  in the year `event1` is recorded for a given record. Counting them in the same year
#'  (regardless of when `event2` actually occured) allows for the correct display
#'  of the proportion of `event1` records for which a record of `event2` also exists.
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param event1 Character string. Name of Date variable containing records of occurrence of the first event.
#' @param event2 Character string. Name of Date variable containing records of occurrence of the second event.
#' @param t0_tally Logical. Whether to count all records of `event2` in the year
#' `event1` is recorded or not.
#' @param mark_cutoff Logical. Whether to show temporal cut-off of previous data.
#' @return Nested Dodge Bar plot ggplot plot.
#' @export
#' @importFrom dplyr select all_of filter mutate case_when
#' @importFrom ggplot2 ggplot aes geom_bar geom_vline guides guide_axis position_dodge2 labs scale_alpha_manual
plot_events_by_year <- function(tbl, event1, event2, t0_tally = TRUE,
                                mark_cutoff = TRUE) {
  tbl <- tbl %>%
    select(all_of(c(event2, event1, "tbl")))


  if (t0_tally) {
    prev_cutoff <- lubridate::year(
      get_date_ceiling(tbl, event1, "year")
    )
    tbl <- tbl %>%
      mutate(
        "{event1}" := lubridate::year(.data[[event1]]),
        "{event2}" := case_when(
          !is.na(.data[[event2]]) ~ .data[[event1]],
          TRUE ~ NA
        )
      )
  } else {
    prev_cutoff <- lubridate::year(
      max(get_date_ceiling(tbl, event1, "year"),
        get_date_ceiling(tbl, event2, "year"),
        na.rm = TRUE
      )
    )
    tbl <- tbl %>%
      mutate(
        "{event1}" := lubridate::year(.data[[event1]]),
        "{event2}" := lubridate::year(.data[[event2]])
      )
  }


  p <- tbl %>%
    ggplot(aes(fill = .data[["tbl"]])) +
    suppressWarnings(
      geom_bar(
        aes(
          x = .data[[event1]],
          alpha = event1,
          text = glue::glue("{event1}: {.data[[event1]]}"),
        ),
        position = position_dodge2(
          width = 0.7,
          preserve = "single"
        ),
        na.rm = TRUE
      )
    ) +
    suppressWarnings(
      geom_bar(
        aes(
          x = .data[[event2]],
          alpha = event2,
          text = glue::glue("{event2}: {.data[[event2]]}"),
        ),
        position = position_dodge2(preserve = "single"),
        width = 0.6,
        na.rm = TRUE
      )
    ) +
    scale_alpha_manual(
      name = "event",
      values = stats::setNames(c(0.5, 1), c(event1, event2))
    ) +
    guides(x = guide_axis(check.overlap = TRUE))

  if (mark_cutoff) {
    p <- p +
      geom_vline(xintercept = prev_cutoff - 0.5, linetype = "dashed")
  }
  p + labs(
    title = paste("Yearly Event Comparison of", event1, "Vs", event2),
    x = "year"
  )
}
