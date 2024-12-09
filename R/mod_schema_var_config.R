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

  # CHDAO 04.12.2024
  # Define compatible data types based on selected_class
  compatible_types <- switch(selected_class,
                             "integer" = c("integer", "double", "factor"),
                             "double" = c("double", "integer", "factor"),
                             "character" = c("character", "factor"), # CHDAO 09.12.2024 no 'Date' option to avoid coercion error
                             "Date" = c("Date", "character"),
                             "factor" = c("factor", "character", "integer", "double"),
                             "logical" = c("logical", "character", "factor", "integer", "double"),
                             c("integer", "double", "character", "factor", "Date", "logical")  # Default case
  )

  tagList(
    card(
      class = "card-dropdown",
      card_header(var_name),
      card_body(
        class = "card-dropdown",
        layout_column_wrap(
          width = 1 / 2,
          selectInput(ns("var_type"), "Variable Type",
            # CHDAO 04.12.2024
            # choices = c("integer", "double", "character", "factor", "Date", "logical"),
            choices = compatible_types,
            # CHDAO
            selected = selected_class
          ),
          textInput(ns("unknown"), "Unknown Value", value = "")
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
