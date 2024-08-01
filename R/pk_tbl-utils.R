# Subsets primary key (pk) column pk_col and tbl column from a table (or equivalent).
subset_pk_tbl_cols <- function(tbl, pk_col = "patient", add_pk_col = FALSE,
                               rename_pk_col = FALSE, session_pk_col = "patient") {
  out <- tbl[, c(pk_col, "tbl")] %>%
    dplyr::distinct()
  if (add_pk_col) {
    out <- dplyr::mutate(out, pk = .data[[pk_col]])
  }
  if (rename_pk_col) {
    names(out)[names(out) == pk_col] <- session_pk_col
  }
  out
}

# Join primary key (pk) IDs from the pk_tbl onto a table. Useful for detecting missing
# primary keys in the pk_col (usually patient). If there are missing pks in tbl
# pk_col, they will appear as NAs. To keep column `pk` from `pk_tbl` which contains
# the full list of pk IDs, use `keep_pk = TRUE`.
join_pk <- function(tbl, pk_tbl, pk_col = "patient", keep_pk = FALSE) {
  tbl$pk <- tbl[[pk_col]]

  join_cols <- c("pk", "tbl") %>%
    purrr::set_names()
  rm_cols <- c(sprintf("%s_id", pk_col),
               setdiff(get_tbl_pk_col(pk_tbl), names(tbl))
               )
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

select_pk_col <- function(tbl, colnames,
                          selected = c("patient", "mother_id"), add = NULL) {
  rlang::check_exclusive(tbl, colnames)
  if (rlang::is_missing(colnames)) {
    colnames <- names(tbl)
  }
  selected <- unique(c(add, selected))

  selected_id <- colnames %>%
    match(selected) %>%
    stats::na.omit() %>%
    sort() %>%
    utils::head(1)
  pk_col <- selected[selected_id]

  if (length(pk_col) == 0L) {
    return(NULL)
  } else {
    return(pk_col)
  }
}

get_tbl_pk_col <- function(pk_tbl) {
  names(pk_tbl)[!names(pk_tbl) %in% c("tbl", "pk")]
}
