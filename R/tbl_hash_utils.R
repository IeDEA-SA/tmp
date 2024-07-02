#' Get Table Tabs Lookup
#'
#' Creates a tibble with the source file hash, the table name, and a unique random id
#' for the input tables. It also takes into account any existing table tabs, so
#' that it doesn't recalculates random id
#'
#' @param tbls A list of tables (or any objects with a "source_hash" attribute).
#' @param existing_tbl_tabs_lookup A tibble of existing tabs metadata.
#'
#' @importFrom dplyr tibble ungroup left_join rowwise mutate if_else
#' @importFrom purrr attr_getter list_rbind imap
#'
#' @noRd
#'
get_tbl_tabs_lookup <- function(tbls, existing_tbl_tabs_lookup) {
  imap(tbls, \(tbl_pair, tbl_name) {
    tibble(
      source_hash = attr_getter("source_hash")(tbl_pair),
      tbl_name = tbl_name
    )
  }) %>%
    list_rbind() %>%
    left_join(existing_tbl_tabs_lookup, by = c("source_hash", "tbl_name")) %>%
    rowwise() %>%
    mutate(
      tab_id = if_else(is.na(tab_id), make_uuid(tbl_name), tab_id)
    ) %>%
    ungroup()
}


#' Set Source Hash for Tables
#'
#' This function assigns a `source_hash` attribute a list of tables, based on
#' content of the corresponding source files.
#'
#' @param tbl_list A list of tables.
#' @param source_files A character vector of file paths for table in `tbl_list`.
#'
#' @noRd
#'
#' @importFrom fs file_exists
set_source_hash <- function(tbl_list, source_files) {
  stopifnot(
    "'source_files' length not match" = length(tbl_list) == length(source_files),
    "source file is missing" = all(file_exists(source_files))
  )

  tbl_list %>%
    structure(
      source_hash = create_source_hash(source_files)
    )
}

#' @importFrom fs file_info
#' @importFrom dplyr select all_of
#' @importFrom digest digest
create_source_hash <- function(source_files) {
  source_files %>%
    file_info() %>%
    # Select file attributes that do not change when the file is read by data.table
    select(all_of(c("path", "type", "size", "modification_time", "birth_time"))) %>%
    digest("xxhash32")
}
