#' Combine current and previous tbl data
#'
#' @param current_tbl a tibble of current data of a table.
#' @param previous_tbl a tibble of previous data of the same table.
#'
#' @return a combined (row bound) long table of current and previous data with
#' column `tbl` appended containing a factor indicator of whether a row originates
#' from the `current` or `previous` version of the data.
#' @export
combine_tbls <- function(current_tbl, previous_tbl) {
  current_tbl$tbl <- "current"
  previous_tbl$tbl <- "previous"
  shared_cols <- intersect(names(current_tbl), names(previous_tbl))
  stopifnot(length(shared_cols) != 0L)

  dplyr::bind_rows(
    current_tbl[, shared_cols],
    previous_tbl[, shared_cols]
  ) %>%
    dplyr::mutate(tbl = as.factor(.data[["tbl"]]))
}
