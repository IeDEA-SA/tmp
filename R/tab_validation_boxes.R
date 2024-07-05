#' Create a layout of boxes with information about a table's variable validation process
#'
#' @param valid_vars vector of valid var names
#' @param invalid_vars vector of invalid varnames
#' @param coerced_vars vector of coerced varnames
#'
#' @return cloumn layout of boxes with information about the table's variable
#' validation process
#' @noRd
#' @importFrom bslib layout_columns value_box value_box_theme
tab_validation_boxes <- function(valid_vars, invalid_vars, coerced_vars) {
  layout_columns(
    value_box(
      title = " ", value = paste(length(valid_vars), "Valid"),
      markdown(
        paste0(
          "Variables that were shared and merged without coercion",
          vector_to_md_list(valid_vars)
        )
      ),
      theme = value_box_theme(bg = "#49F5BF", fg = "#000000"),
      showcase = icon("square-check"), showcase_layout = "top right",
      full_screen = FALSE, fill = FALSE, height = NULL
    ),
    value_box(
      title = " ", value = paste(length(coerced_vars), "Coerced"),
      markdown(
        paste0(
          "Variables that required data type coercion to be merged",
          vector_to_md_list(coerced_vars)
        )
      ),
      theme = value_box_theme(bg = "#DB865C", fg = "#000000"),
      showcase = icon("circle-exclamation"), showcase_layout = "top right",
      full_screen = FALSE, fill = FALSE, height = NULL
    ),
    value_box(
      title = " ", value = paste(length(invalid_vars), "Invalid"),
      markdown(
        paste0(
          "Variables that cannot be merged because of conflicting data types",
          vector_to_md_list(invalid_vars)
        )
      ),
      theme = value_box_theme(bg = "#F08787", fg = "#000000"),
      showcase = icon("rectangle-xmark"), showcase_layout = "top right",
      full_screen = FALSE, fill = FALSE, height = NULL
    )
  )
}

vector_to_md_list <- function(x, as_code = TRUE, bold = FALSE, sep = c("\n", ",")) {
  if (length(x) == 0L) {
    return(NULL)
  }
  sep <- rlang::arg_match(sep)
  if (sep == ",") {
    bullet <- NULL
  } else {
    bullet <- "- "
  }
  glue::glue(
    "\n\n",
    paste0(
      bullet,
      ifelse(bold, "**", ""),
      ifelse(as_code, "`", ""),
      x,
      ifelse(as_code, "`", ""),
      ifelse(bold, "**", ""),
      collapse = sep
    )
  )
}
