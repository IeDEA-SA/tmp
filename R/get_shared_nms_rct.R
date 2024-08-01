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
      names(previous()),
      names(current())
    )
    if (length(shared) == 0L) {
      showNotification(
        markdown("**No shared tables detected!** No data to compare."),
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
