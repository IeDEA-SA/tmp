# Subsets primary key (pk) column pk_col and tbl column from tblBAS (or equivalent).
subset_pk_tbl_cols <- function(tblBAS, pk_col = "patient") {
  tblBAS[, c(pk_col, "tbl")] |>
    dplyr::mutate(pk = .data[[pk_col]]) |>
    dplyr::distinct()
}

# Join primary key (pk) IDs from the pk_tbl onto a table. Useful for detecting missing
# primary keys in the pk_col (usually patient). If there are missing pks in tbl
# pk_col, they will appear as NAs. To keep column `pk` from `pk_tbl` which contains
# the full list of pk IDs, use `keep_pk = TRUE`.
join_pk <- function(tbl, pk_tbl, pk_col = "patient", keep_pk = FALSE) {
  tbl$pk <- tbl[[pk_col]]

  join_cols <- c("pk", "tbl") %>%
    purrr::set_names()
  rm_cols <- sprintf("%s_id", pk_col)
  if (!keep_pk) {
    rm_cols <- c("pk", rm_cols)
  }

  dplyr::full_join(tbl, pk_tbl,
    by = join_cols,
    relationship = "many-to-one",
    suffix = c("", "_id")
  ) %>%
    dplyr::select(-dplyr::any_of(rm_cols))
}
