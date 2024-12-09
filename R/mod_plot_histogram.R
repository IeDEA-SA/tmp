#' plot_histogram UI Function
#'
#' @description Module for creating histogram plot card.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param x Character string. Name of variable being plotted.
#' @param y Defaults to NULL. Not used in 1 variable plots but required for consistency
#' with 2 var plots.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_histogram_ui <- function(id, x, y = NULL) {
  ns <- NS(id)
  tagList(
    waiter::waiterOnBusy(color = "lightgrey"),
    card(
      card_header(x),
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
          checkboxInput(ns("log"),
            label = "Log transform variable",
            value = FALSE
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
#' @param comb_tbl A tibble of combined previous and current data.
#' @noRd
mod_plot_histogram_server <- function(id, comb_tbl, x, y = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    tbl_name <- get_ns_tbl_name(ns)
    plot_id <- get_ns_plot_id(ns)

    generate_plot <- reactive({
      req(input$position, input$bins, !is.null(input$interactive))
      plot_histogram(
        tbl = comb_tbl, x = x,
        position = input$position,
        bins = input$bins,
        log = input$log
      )
    })

    output$plot <- renderUI({
      if (input$interactive) {
        plotly::renderPlotly({
          generate_plot() %>%
            matcha_ggplotly()
        })
      } else {
        renderPlot({
          generate_plot()
        })
      }
    })

    observe({
      session$userData$plots[[tbl_name]][[plot_id]] <- list(
        x = x,
        plot = generate_plot(),
        interactive = input$interactive,
        plot_type = "histogram"
      )
    })

    observeEvent(input$delete, {
      log_debug(paste("Removing plot:", tbl_name, plot_id))
      session$userData$plots[[tbl_name]][[plot_id]] <- NULL
      delete_id <- gsub("-card", "-plot_ui", ns(NULL))
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
