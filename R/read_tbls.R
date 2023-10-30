read_tbls <- function(selected_tables, previous_dat_paths, current_dat_paths) {
  purrr::map(
    .x = purrr::set_names(selected_tables),
    ~ {
      list(
        previous = read_file(previous_dat_paths[.x]),
        current = read_file(current_dat_paths[.x])
      )
    }
  )
}
