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
    var_type_tbl_previous <- get_var_type(tbl$previous[[var_name]])[1]
    var_type_tbl_current <- get_var_type(tbl$current[[var_name]])[1]
    coerce_both <- !is.null(var_type) && var_type_tbl_previous != var_type
    coerce_current <- isFALSE(coerce_both) && var_type_tbl_current != var_type_tbl_previous

    previous_NAs <- sum(is.na(tbl$previous[[var_name]]))
    current_NAs <- sum(is.na(tbl$current[[var_name]]))

    if (coerce_both) {
      coerce_fn <- get(sprintf("as.%s", var_type))
      pre_NAs <- sum(is.na(tbl$previous[[var_name]]))
      tbl$previous[[var_name]] <- coerce_fn(tbl$previous[[var_name]])
      tbl$current[[var_name]] <- coerce_fn(tbl$current[[var_name]])
      log_debug("Var {var_name} coerced to {var_type} from {var_type_tbl_previous} in both tables")
    }
    if (coerce_current) {
      coerce_fn <- get(sprintf("as.%s", var_type_tbl_previous))
      tbl$current[[var_name]] <- coerce_fn(tbl$current[[var_name]])
      log_debug("Var {var_name} coerced to {var_type} from {var_type_tbl_previous} in current table")
    }

    if (any(coerce_both, coerce_current)) {
      purrr::map2(
        .x = c("previous", "current"),
        .y = c(previous_NAs, current_NAs),
        .f = function(x, y) {
          if (sum(is.na(tbl[[x]][[var_name]])) > y) {
            showNotification(
              glue::glue("NAs introduced by coercion to column {var_name} in {x} table.
                         '{var_type}' may not be an appropriate type for this column."),
              type = "warning"
            )
          }
        }
      )
    }

    if (is.null(unknown) || unknown == "") {
    } else {
      make_NA <- as.character(tbl$previous[[var_name]]) == unknown
      tbl$previous[[var_name]][make_NA] <- NA

      make_NA <- as.character(tbl$current[[var_name]]) == unknown
      tbl$current[[var_name]][make_NA] <- NA
      log_debug("Values {unknown} in var {var_name} set to NA")
    }
  }
  tbl
}

get_var_type <- function(x) {
  if (inherits(x, "numeric")) {
    var_type <- typeof(x)
  } else {
    var_type <- class(x)
  }
  var_type
}
