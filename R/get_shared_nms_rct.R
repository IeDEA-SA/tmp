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
    intersect(
      names(previous()),
      names(current())
    )
  })
}
