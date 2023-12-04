#' dynamic_select UI Function
#'
#' @description Module for selecting shared properties to compare
#' between previous and current dataset.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param property character string. Name of property to select.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_dynamic_select_ui <- function(id, property = "tables", multiple = TRUE,
                                  selectize = TRUE) {
  ns <- NS(id)
  tagList(
    selectInput(ns("tables"),
      paste("Select", property, "to compare"),
      choices = NULL,
      multiple = multiple,
      selectize = selectize
    )
  )
}

#' dynamic_select Server Functions
#'
#' @param property character string. Name of property to select.
#' @param choices Reactive. Vector of drop down choices, e.g. names of shared
#' tables or shared variables within tables.
#' @return Reactive. The user selected table names from the selectize widget.
#' @noRd
mod_dynamic_select_server <- function(id, property, choices) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    observeEvent(choices(), {
      updateSelectInput(session, property, choices = choices())
    })

    reactive(input[[property]])
  })
}

## To be copied in the UI
# mod_dynamic_select_ui("dynamic_select_1")

## To be copied in the server
# mod_dynamic_select_server("dynamic_select_1")
