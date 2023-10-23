#' read_tbls UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_read_tbls_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput("tbls")
  )
}

#' read_tbls Server Functions
#'
#' @noRd
mod_read_tbls_server <- function(id, selected_tables, dataset_1, dataset_2) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    req(selected_tables)

    tbl_ids <- reactive(paste("tbls", selected_tables(), sep = "_"))

    output$tbls <- renderUI({
      purrr::map(selected_tables(), ~ tableOutput(ns(tbl_ids())))
    })

    reactive({
    output[[ns(tbl_ids())]] <- purrr::map(
      selected_tables(),
      ~ renderTable(combine_tbls(dataset_1()[.x], dataset_2()[.x]))
    )
    })
  })
}

## To be copied in the UI
# mod_read_tbls_ui("read_tbls_1")

## To be copied in the server
# mod_read_tbls_server("read_tbls_1")
