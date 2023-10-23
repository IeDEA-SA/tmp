#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      h1("MATCHA"),
      mod_access_data_ui("access_data_1"),
      mod_access_data_ui("access_data_2"),
      textOutput("shared_files"),
      mod_select_tbls_ui("select_tbls"),
      mod_read_tbls_ui("read_tbls")
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "MATCHA"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
