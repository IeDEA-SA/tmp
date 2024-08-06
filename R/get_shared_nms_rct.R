#' Get shared names of previous and current reactive objects
#'
#' Works on reactives that return named outputs.
#' @param previous Reactive. Previous version of object.
#' @param current Reactive. Current version of object.
#' @param pk_tbl_name Character. Primary key table name.
#'
#' @return Reactive of the intersect of previous and current object names.
#'
#' @noRd
get_shared_nms_rct <- function(previous, current, pk_tbl_name) {
  reactive({
    req(previous(), current())

    shared <- intersect(
      names(previous()[valid_ext(previous(), dir = "previous")]),
      names(current()[valid_ext(current(), dir = "current")])
    )
    if (length(shared) == 0L) {
      showNotification(
        markdown("**No shared tables detected!** No data to compare."),
        duration = NULL,
        type = "error"
      )
    } else {
      showNotification(
        markdown(
          glue::glue("**{length(shared)} shared tables detected**:
                   {vector_to_md_list(shared)}")
        ),
        type = "message"
      )
      if (!pk_tbl_name %in% shared) {
        showNotification(
          markdown(
            glue::glue(
              "**Expected primary key table `{pk_tbl_name}` not found
            in shared tables**.

            Please check data or use `pk_tbl_name` argument
            in `run_app()` to re-configure primary key table."
            )
          ),
          duration = NULL,
          type = "error"
        )
      }
    }
    shared
  })
}

valid_ext <- function(file_paths, dir = c("previous", "current")) {
  dir <- rlang::arg_match(dir)
  extensions <- fs::path_ext(file_paths) |> tolower()
  invalid_ext <- !extensions %in% c("csv", "rds", "dta",
                                    "sav", "por", "sas7bdat",
                                    "sas7bcat")
  if (any(invalid_ext)) {
    showNotification(
      markdown(
        glue::glue(
          "##### Invalid File Extensions

          The following files in the **{dir}** dir have invalid extensions
          and were ignored:
          {vector_to_md_list(file_paths[invalid_ext])}
          "
        )
      ),
      duration = 7,
      type = "error"
    )
  }
  !invalid_ext
}
