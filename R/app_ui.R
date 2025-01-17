#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    page_sidebar(
      theme = matcha_theme(),
      waiter::useWaiter(), # CHDAO 12.09.2024 temporarily deactivate
      shinyjs::useShinyjs(),
      title = "MATCHA",
      # Select source for dataset 1 (previous)
      sidebar = sidebar(
        open = "open", width = 350,
        h5("Select datasets to compare"),
        mod_access_data_ui("access_prev_dat", dataset = "Previous"),
        # Select source for dataset 2 (current)
        mod_access_data_ui("access_curr_dat", dataset = "Current"),
        # Select from shared files
        card(
          class = "card-dropdown",
          card_header("Table selection"),
          card_body(
            class = "card-dropdown",
            mod_dynamic_select_ui("select_tbls", property = "tables"),
            mod_read_tbls_ui("read_tbls")
          )
        ),
        mod_download_ui("download"),
        mod_close_app_ui("close_app")
      ),
      mod_tbl_tabs_ui("tbl_tab")
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
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "MATCHA"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
