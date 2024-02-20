#' Get shared names of previous and current reactive objects
#'
#' Works on reactives that return named outputs.
#' @param previous Reactive. Previous version of object.
#' @param current Reactive. Current version of object.
#'
#' @return Reactive of the intersect of previous and current object names.
#'
#' @noRd
get_shared_nms_rct <- function(previous, current) {
  reactive({
    req(previous(), current())
    shared <- intersect(
      names(previous()),
      names(current())
    )
    if (length(shared) == 0L) {
      showNotification(
        glue::glue("No shared tables detected! No data to compare."),
        type = "error"
      )
    } else {
      showNotification(
        glue::glue("{length(shared)} shared tables detected:
                   {glue::glue_collapse(shared, sep = ', ')}"),
        type = "message"
      )
    }
    shared
  })
}
