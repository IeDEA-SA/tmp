#' plot_tbl UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_tbl_ui <- function(id){
  ns <- NS(id)
  # tagList(
  #
  # )
 tableOutput("table")
}

#' plot_tbl Server Functions
#'
#' @noRd
mod_plot_tbl_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
  })
}

## To be copied in the UI
# mod_plot_tbl_ui("plot_tbl_1")

## To be copied in the server
# mod_plot_tbl_server("plot_tbl_1")
