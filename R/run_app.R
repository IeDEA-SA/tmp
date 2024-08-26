#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts. E.g. use these to override the
#' primary key table and column at runtime through arguments `pk_tbl_name`
#' and `pk_col` respectively. See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @examples
#' \dontrun{
#' run_app()
#' # Override the default primary key source settings
#' run_app(pk_tbl_name = "tblKEYS", pk_col = "id")
#' }
run_app <- function(onStart = NULL,
                    options = list(),
                    enableBookmarking = NULL,
                    uiPattern = "/",
                    ...) {
  # Set app to launch in browser
  # Source: https://stackoverflow.com/questions/35311318/opening-shiny-app-directly-in-the-default-browser
  options <- c(options, launch.browser = TRUE)

  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
