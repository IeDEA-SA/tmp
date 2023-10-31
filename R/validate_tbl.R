validate_tbl <- function(tbl, check) {
  if (!check$valid) {
    return(NULL)
  }

  process_tbl(tbl,
    clean_names = check$check_names$clean_names,
    select_vars = check$check_coltypes$valid_cols
  )
}
