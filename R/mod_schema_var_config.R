#' schema_var_config UI Function
#'
#' @description A shiny Module to configure the schema of an individual column
#' in a data table.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_schema_var_config_ui <- function(id, var_name, selected_class) {
  ns <- NS(id)
  tagList(
    # div(
    #   class = "d-flex justify-content-around align-items-center",
    #   h4(var_name),
    #   selectInput(ns("var_type"), "Variable Type",
    #     choices = c("numeric", "character", "factor", "Date", "logical"),
    #     selected = selected_class
    #   ),
    #   textInput(ns("unknown"), "Unknown Values", value = "")
    # )
    card(
      card_header(var_name),
      card_body(
        layout_column_wrap(
          width = 1 / 2,
          selectInput(ns("var_type"), "Variable Type",
            choices = c("numeric", "character", "factor", "Date", "logical"),
            selected = selected_class
          ),
          textInput(ns("unknown"), "Unknown Values", value = "")
        )
      )
    )
  )
}

#' schema_var_config Server Functions
#'
#' @noRd
mod_schema_var_config_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    var_config <- reactive({
      list(
        var_type = input$var_type,
        unknown = input$unknown
      )
    })
    var_config
  })
}

## To be copied in the UI
# mod_schema_var_config_ui("var_config_1")

## To be copied in the server
# mod_schema_var_config_server("var_config_1")
