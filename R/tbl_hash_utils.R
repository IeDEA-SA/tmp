#' Get Table Hash Lookup
#'
#' Creates a named character vector where the names are the source hash
#' of the input tables and the values are the names of those tables.
#'
#' @param tbls A list of tables (or any objects with a "source_hash" attribute).
#'
#' @noRd
#'
#' @importFrom purrr imap_chr set_names attr_getter
get_tbl_hash_lookup <- function(tbls) {
  res <- imap_chr(tbls, \(tbl_pair, tbl_name) {
    attr_getter("source_hash")(tbl_pair)
  })
  set_names(names(res), res)
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
#' @importFrom purrr map2 walk
#' @importFrom digest digest
#' @importFrom rlang is_list
#' @importFrom fs file_exists
set_source_hash <- function(tbl_list, source_files) {
  walk(tbl_list, check_data_frame)
  stopifnot(
    "source file is missing" = all(file_exists(source_files)),
    "'source_files' length not match" = length(tbl_list) == length(source_files)
  )

  tbl_list %>%
    structure(
      source_hash = source_files %>%
        file_info() %>%
        digest("xxhash32")
    )
}
