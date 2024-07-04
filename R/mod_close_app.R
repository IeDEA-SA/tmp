#' close_app UI Function
#'
#' @description A shiny Module providing a button to close the app.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_close_app_ui <- function(id) {
  ns <- NS(id)
  tagList(
    actionButton(
      ns("close"), "Close App",
      icon = icon("power-off"),
      onclick = "setTimeout(function(){window.close();},500);"
    )
  )
}

#' close_app Server Functions
#'
#' @noRd
mod_close_app_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    observe({
      if (input$close > 0) stopApp() # stop shiny
    })
  })
}

## To be copied in the UI
# mod_close_app_ui("close_app_1")

## To be copied in the server
# mod_close_app_server("close_app_1")

# Solution sourced from: https://www.r-bloggers.com/2016/05/stop-shiny-and-close-browser-together/amp/
