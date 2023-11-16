bin_count_by_date <- function(tbl, var, time_bin, mirror) {
  var <- rlang::arg_match(var, values = names(tbl))
  checkmate::assert_class(tbl[[var]], "Date")

  dplyr::mutate(
    tbl,
    time_bin = lubridate::floor_date(.data[[var]], time_bin)
  ) %>%
    dplyr::group_by(.data[["tbl"]], .data[["time_bin"]]) %>%
    dplyr::summarise(count = dplyr::n()) %>%
    dplyr::mutate(count = dplyr::case_when(
      .data[["tbl"]] == "previous" & mirror ~ -.data[["count"]],
      .default = .data[["count"]]
    ))
}

get_date_floor <- function(tbl, var, time_bin) {
  var <- rlang::arg_match(var, values = names(tbl))
  checkmate::assert_class(tbl[[var]], "Date")

  if (!"tbl" %in% names(tbl)) {
    return({
      max(tbl[[var]]) %>%
        lubridate::floor_date(unit = time_bin)
    })
  }

  tbl[tbl[["tbl"]] == "previous", var, drop = TRUE] %>%
    max() %>%
    lubridate::floor_date(unit = time_bin)
}
