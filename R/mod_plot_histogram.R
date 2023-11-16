#' plot_histogram UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_histogram_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Configure plot"),
    selectInput(ns("position"),
      label = "Select bar position",
      choices = eval(rlang::fn_fmls(
        plot_histogram
      )[["position"]]),
      selected = "mirror"
    ),
    checkboxInput(ns("interactive"),
      label = "Display interactive plot",
      value = TRUE
    ),
    uiOutput(ns("plot")),
    sliderInput(
      inputId = ns("bins"),
      label = "Number of bins:",
      min = 1,
      max = 100,
      value = 30
    )
  )
}

#' plot_histogram Server Functions
#'
#' @noRd
mod_plot_histogram_server <- function(id, current_tbl,
                                      previous_tbl, var) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$plot <- renderUI({
      if (input$interactive) {
        plotly::renderPlotly({
          plot_histogram(current_tbl, previous_tbl, var,
            position = input$position,
            interactive = input$interactive,
            bins = input$bins
          )
        })
      } else {
        renderPlot({
          plot_histogram(current_tbl, previous_tbl, var,
            position = input$position,
            interactive = input$interactive,
            bins = input$bins
          )
        })
      }
    })
  })
}

## To be copied in the UI
# mod_plot_histogram_ui("plot_histogram_1")

## To be copied in the server
# mod_plot_histogram_server("plot_histogram_1")
