#' Combine current and previous tbl data
#'
#' @param current_tbl a tibble of current data of a table.
#' @param previous_tbl a tibble of previous data of the same table.
#' @param tbl_name a character string. The name of the table.
#'
#' @return a combined (row bound) long table of current and previous data with
#' the following columns appended:
#' - `tbl`: factor indicating whether a row originates from the `current` or
#'   `previous` version of the data.
#' - `tbl_name`: the name of the table
#' @export
combine_tbls <- function(current_tbl, previous_tbl, tbl_name) {
  current_tbl$tbl <- "current"
  previous_tbl$tbl <- "previous"
  shared_cols <- intersect(names(current_tbl), names(previous_tbl))
  stopifnot(length(shared_cols) != 0L)

  dplyr::bind_rows(
    current_tbl[, shared_cols],
    previous_tbl[, shared_cols]
  ) %>%
    dplyr::mutate(
      tbl = factor(.data[["tbl"]],
        levels = c("previous", "current")
      ),
      tbl_name = tbl_name
    )
}
