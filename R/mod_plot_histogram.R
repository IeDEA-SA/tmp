#' plot_histogram UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_histogram_ui <- function(id, var) {
  ns <- NS(id)
  tagList(
    card(
      card_header(var),
      full_screen = TRUE,
      layout_sidebar(
        fillable = TRUE,
        sidebar = sidebar(
          title = "Configure plot",
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
          sliderInput(
            inputId = ns("bins"),
            label = "Number of bins:",
            min = 1,
            max = 100,
            value = 30
          )
        ),
        uiOutput(ns("plot"))
      ),
      actionButton(ns("delete"),
        label = "", icon = icon("trash")
      )
    )
  )
}

#' plot_histogram Server Functions
#'
#' @noRd
mod_plot_histogram_server <- function(id, comb_tbl, var) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$plot <- renderUI({
      if (input$interactive) {
        plotly::renderPlotly({
          plot_histogram(comb_tbl, var,
            position = input$position,
            interactive = input$interactive,
            bins = input$bins
          )
        })
      } else {
        renderPlot({
          plot_histogram(comb_tbl, var,
            position = input$position,
            interactive = input$interactive,
            bins = input$bins
          )
        })
      }
    })
    observeEvent(input$delete, {
      delete_id <- gsub("-plot", "-plot_ui", ns(NULL))
      removeUI(
        selector = glue::glue("#{delete_id}")
      )
    })
  })
}

## To be copied in the UI
# mod_plot_histogram_ui("plot_histogram_1")

## To be copied in the server
# mod_plot_histogram_server("plot_histogram_1")
