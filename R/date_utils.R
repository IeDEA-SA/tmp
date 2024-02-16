bin_count_by_date <- function(tbl, x, time_bin, mirror) {
  x <- rlang::arg_match(x, values = names(tbl))
  checkmate::assert_class(tbl[[x]], "Date")

  dplyr::mutate(
    tbl,
    time_bin = lubridate::floor_date(.data[[x]], time_bin)
  ) %>%
    dplyr::group_by(.data[["tbl"]], .data[["time_bin"]]) %>%
    dplyr::summarise(count = dplyr::n()) %>%
    dplyr::mutate(count = dplyr::case_when(
      .data[["tbl"]] == "previous" & mirror ~ -.data[["count"]],
      .default = .data[["count"]]
    ))
}

get_date_floor <- function(tbl, x, time_bin) {
  x <- rlang::arg_match(x, values = names(tbl))
  checkmate::assert_class(tbl[[x]], "Date")

  if (!"tbl" %in% names(tbl)) {
    return({
      max(tbl[[x]]) %>%
        lubridate::floor_date(unit = time_bin)
    })
  }

  tbl[tbl[["tbl"]] == "previous", x, drop = TRUE] %>%
    max() %>%
    lubridate::floor_date(unit = time_bin)
}
