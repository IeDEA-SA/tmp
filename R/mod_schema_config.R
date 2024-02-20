#' schema_config UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_schema_config_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("mitsos")),
    uiOutput(ns("schema_widget"))
  )
}

#' schema_config Server Functions
#'
#' @noRd
mod_schema_config_server <- function(id, tbl) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    shared_vars <- intersect(
      names(tbl$previous),
      names(tbl$current)
    )

    output$schema_widget <- renderUI({

      purrr::imap(
        tbl$previous[, shared_vars],
        ~ mod_var_config_ui(
          id = ns(.y),
          var_name = .y,
          selected_class = class(.x)
        )
      )
    })

    output$mitsos <- renderUI({
      logger::log_info(ns(NULL))
      mod_var_config_ui(
        id = ns("mitsos"),
        var_name = "mitsos",
        selected_class = class("mitsos")
      )
    })





    mitsos_out <- mod_var_config_server(
      id = "mitsos"
    )
   observe({
     print(mitsos_out())
   })


   schema <- reactiveValues()
   for (var_name in shared_vars) {
     schema[[var_name]] <- mod_var_config_server(
       id = var_name
     )()
   }

   observe({
     print(schema[["art_rs"]])
   })


  # all_out <- purrr::map(
  #       purrr::set_names(shared_vars),
  #       ~ mod_var_config_server(
  #         id = .x
  #       )()
  #     )
  # observe({
  #   print(all_out)
  # })
   schema

  })
}

## To be copied in the UI
# mod_schema_config_ui("schema_config_1")

## To be copied in the server
# mod_schema_config_server("schema_config_1")
