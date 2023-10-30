#' Check current & previous tables for shared variables and column types.
#'
#' @param x a list containing tibble of the `previous` and `current` versions of
#' a table.
#'
#' @return a list containing the results of checks. `check_names` contains metadata
#' on column name checks and `check_coltypes` contains metadata on column data type
#' checks. The `valid` element states whether any columns in the two tables
#' can be compared.
check_tbls <- function(x) {
  check_names <- check_tbl_names(x)

  x <- process_tbls(x,
    clean_names = check_names$clean_names,
    select_vars = check_names$valid_cols
  )

  check_coltypes <- check_tbl_coltypes(x)

  list(
    check_names = check_names,
    check_coltypes = check_coltypes,
    valid = all(check_names$valid, check_coltypes$valid)
  )
}

#' Check current & previous tables for shared variables.
#'
#' @param x a list containing tibble of the `previous` and `current` versions of
#' a table.
#'
#' @return a list containing the results of checks and associated metadata:
#'
#' - `check`: Check name
#' - `valid`: Logical. Whether the table has any valid columns that can be compared.
#' - `msg`: check result message
#' - `valid_cols`: Names of shared columns across previous and current tbls.
#' - `clean_names`: Logical. Whether names require cleaning to match.
check_tbl_names <- function(x) {
  shared_colnames_raw <- intersect(
    names(x$current),
    names(x$previous)
  )
  shared_colnames_raw_n <- length(shared_colnames_raw)
  shared_colnames_clean <- intersect(
    janitor::make_clean_names(names(x$current)),
    janitor::make_clean_names(names(x$previous))
  )
  shared_colnames_clean_n <- length(shared_colnames_clean)

  clean_names <- shared_colnames_clean_n > shared_colnames_raw_n

  if (clean_names) {
    return(
      check_tbl_names_output(
        shared_colnames_clean,
        shared_colnames_clean_n,
        clean_names
      )
    )
  }
  check_tbl_names_output(
    shared_colnames_raw,
    shared_colnames_raw_n,
    clean_names
  )
}

check_tbl_names_output <- function(valid_cols, n, clean_names) {
  msg <- NULL
  if (clean_names) {
    msg <- "Name cleaning required to match variables. "
  }
  if (n == 0L) {
    valid_cols <- NULL
    msg <- paste0(msg,
      "\u274c No shared column names between previous & current data. Tables invalid.",
      collapse = "\n"
    )
  } else {
    vars <- glue::glue_collapse(valid_cols, sep = ", ")
    msg <- paste0(msg,
      glue::glue("\u2139 {n} shared variables identified: {vars}."),
      collapse = "\\n"
    )
  }

  list(
    check = "Table names",
    valid = n > 0L,
    msg = msg,
    valid_cols = valid_cols,
    clean_names = clean_names
  )
}

#' Check current & previous tables for shared column types.
#'
#' @param x a list containing tibble of the `previous` and `current` versions of
#' a table.
#'
#' @return a list containing the results of checks and associated metadata:
#'
#' - `check`: Check name
#' - `valid`: Logical. Whether the table has any valid columns that can row
#' bound to compare.
#' - `msg`: check result message
#' - `valid_cols`: Names of columns that can be successfully row bound to be
#' compared.
#' - `equal`: Logical vector. Whether columns share the same class.
#' - `all_equal`: Logical. Whether all columns share the same class. If `TRUE` no
#' coercion of data types required.
check_tbl_coltypes <- function(x) {
  equal <- purrr::map2_lgl(
    .x = purrr::map(x$previous, class),
    .y = purrr::map(x$current, class),
    ~ isTRUE(all.equal(.x, .y))
  )
  all_equal <- all(equal)
  if (all_equal) {
    cols <- NULL
    msg <- "All variables share same column type."
  } else {
    cols <- names(equal[!equal])
    msg <- glue::glue(
      "Variables {glue::glue_collapse(cols, sep = ', ')}",
      " do not share same columns type."
    )
  }

  col_rbind_errors <- purrr::map_lgl(
    purrr::set_names(names(equal)),
    ~ col_rbind_error(x, var = .x)
  )
  rbind_error <- all(col_rbind_errors)
  valid_cols <- names(col_rbind_errors[!col_rbind_errors])
  if (rbind_error) {
    msg <- glue::glue(
      "{msg}
      \u274c Previous & current data CANNOT be row bound across any columns. Tables invalid."
    )
  } else {
    coerce_msg <- if (all_equal) "" else " (after coercion)"
    vars <- glue::glue_collapse(valid_cols, sep = ", ")
    msg <- glue::glue(
      "{msg}
      \u2714 Previous & current data CAN be row bound{coerce_msg} across variables: {vars}."
    )
  }
  list(
    check = "Column data types",
    valid = !rbind_error,
    msg = msg,
    equal = equal,
    all_equal = all_equal,
    valid_cols = valid_cols
  )
}

process_tbls <- function(x, clean_names = FALSE, select_vars) {
  if (clean_names) {
    x <- purrr::map(x, janitor::clean_names)
  }
  purrr::map(x, ~ .x[, select_vars])
}


col_rbind_error <- function(x, var) {
  purrr::map(x, ~ .x[, "patient"]) %>%
    try() %>%
    purrr::list_rbind() %>%
    inherits("try-error")
}
