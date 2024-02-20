#' var_config UI Function
#'
#' @description A shiny Module to configure an individual column in a data table.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_var_config_ui <- function(id, var_name, selected_class) {
  ns <- NS(id)
  #print(paste("mod_var_config_ui NS", ns(NULL)))
  tagList(
    div(
      class = "d-flex",
      h4(var_name),
      selectInput(ns("var_type"), "Variable Type",
        choices = c("numeric", "character", "factor", "date", "logical"),
        selected = selected_class
      ),
      textInput(ns("unknown"), "Unknown Values", value = "")
    )
  )
}

#' var_config Server Functions
#'
#' @noRd
mod_var_config_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    var_config <- reactive({
      logger::log_info("var_config reactive")
      list(
        var_type = input$var_type,
        unknown = input$unknown
      )
    })

    var_config
  })
}

## To be copied in the UI
# mod_var_config_ui("var_config_1")

## To be copied in the server
# mod_var_config_server("var_config_1")
