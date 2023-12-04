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
