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

get_date_ceiling <- function(tbl, x, time_bin) {
  x <- rlang::arg_match(x, values = names(tbl))
  checkmate::assert_class(tbl[[x]], "Date")

  if (!"tbl" %in% names(tbl)) {
    return({
      max(tbl[[x]]) %>%
        lubridate::ceiling_date(unit = time_bin)
    })
  }

  tbl[tbl[["tbl"]] == "previous", x, drop = TRUE] %>%
    max(na.rm = TRUE) %>%
    lubridate::ceiling_date(unit = time_bin)
}


# Function to create duration objects
create_duration <- function(period_type, size = 0.5) {
  switch(period_type,
    day = lubridate::duration(1 * size, "day"),
    week = lubridate::duration(7 * size, "day"),
    month = lubridate::duration(1 * size, "month"),
    bimonth = lubridate::duration(2 * size, "month"),
    season = lubridate::duration(3 * size, "month"),
    quarter = lubridate::duration(3 * size, "month"),
    halfyear = lubridate::duration(6 * size, "month"),
    year = lubridate::duration(1 * size, "year"),
    stop("Unknown period type")
  )
}
