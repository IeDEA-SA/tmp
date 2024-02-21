#' Apply a user configured schema to tbl
#'
#' @param tbl a list containing two elements:
#' - `previous`: a tibble of previous data
#' - `current`: a tibble of current data
#' @param schema_config List containing a reactive var config object for each
#' shared column
#'
#' @return the updated `tbl` object coerced the user defined schema.
#' @noRd
apply_schema <- function(tbl, schema_config) {
  for (var_name in names(schema_config)) {
    var_type <- schema_config[[var_name]]()$var_type
    unknown <- schema_config[[var_name]]()$unknown

    if (!is.null(var_type)) {
      coerce_fn <- get(sprintf("as.%s", var_type))
      tbl$previous[[var_name]] <- coerce_fn(tbl$previous[[var_name]])
      tbl$current[[var_name]] <- coerce_fn(tbl$current[[var_name]])
    } else {
      coerce_fn <- identity
    }
    if (is.null(unknown) || unknown == "") {
    } else {
      make_NA <- tbl$previous[[var_name]] == coerce_fn(unknown)
      tbl$previous[[var_name]][make_NA] <- NA

      make_NA <- tbl$current[[var_name]] == coerce_fn(unknown)
      tbl$current[[var_name]][make_NA] <- NA
    }
  }
  tbl
}
