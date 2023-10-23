#' select_tbls UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_tbls_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectizeInput(ns("tables"), "Select Tables to compare",
                   choices = NULL,
                   multiple = TRUE)
  )
}

#' select_tbls Server Functions
#'
#' @noRd
mod_select_tbls_server <- function(id, shared_tables){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    observeEvent(shared_tables(), {
      updateSelectInput(session, "tables", choices = shared_tables())
    })

    reactive(input$tables)
  })
}

## To be copied in the UI
# mod_select_tbls_ui("select_tbls_1")

## To be copied in the server
# mod_select_tbls_server("select_tbls_1")
