#' plot_count_by_date UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_count_by_date_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Configure plot"),
    selectInput(ns("time_bin"),
      label = "Select time bin",
      choices = eval(
        rlang::fn_fmls(plot_count_by_date)[["time_bin"]]
      ),
      selected = "day"
    ),
    selectInput(ns("position"),
      label = "Select bar position",
      choices = eval(rlang::fn_fmls(
        plot_count_by_date
      )[["position"]]),
      selected = "mirror"
    ),
    checkboxInput(ns("interactive"),
      label = "Display interactive plot",
      value = TRUE
    ),
    checkboxInput(ns("mark_cutoff"),
      label = "Show previous dataset temporal cut-off",
      value = TRUE
    ),
    uiOutput(ns("plot"))
  )
}

#' plot_count_by_date Server Functions
#'
#' @noRd
mod_plot_count_by_date_server <- function(id, current_tbl,
                                          previous_tbl, var) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # output$current_tbl <- renderPrint(current_tbl)
    # output$previous_tbl <- renderPrint(previous_tbl)
    # output$var <- renderPrint(previous_tbl)

    output$plot <- renderUI({
      if (input$interactive) {
        plotly::renderPlotly({
          plot_count_by_date(current_tbl, previous_tbl, var,
            time_bin = input$time_bin,
            position = input$position,
            mark_cutoff = input$mark_cutoff,
            interactive = input$interactive
          )
        })
      } else {
        renderPlot({
          plot_count_by_date(current_tbl, previous_tbl, var,
            time_bin = input$time_bin,
            position = input$position,
            mark_cutoff = input$mark_cutoff,
            interactive = input$interactive
          )
        })
      }
    })
  })
}

## To be copied in the UI
# mod_plot_count_by_date_ui("plot_count_by_date_1")

## To be copied in the server
# mod_plot_count_by_date_server("plot_count_by_date_1")
