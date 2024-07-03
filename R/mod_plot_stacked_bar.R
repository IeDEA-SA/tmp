#' plot_stacked_bar UI Function
#'
#' @description Module for creating stacked bar plot card.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param x Character string. Name of variable being plotted.
#' @param y Defaults to NULL. Not used in 1 variable plots but required for consistency
#' with 2 var plots.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_stacked_bar_ui <- function(id, x, y = NULL) {
  ns <- NS(id)
  tagList(
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
                        plot_stacked_bar
                      )[["position"]]),
                      selected = "fill"
          ),
          checkboxInput(ns("na.rm"),
                        label = "Remove NA values",
                        value = TRUE
          ),
          checkboxInput(ns("interactive"),
                        label = "Display interactive plot",
                        value = TRUE
          ),
          uiOutput(ns("n_ui"))
        ),
        uiOutput(ns("plot"))
      ),
      actionButton(ns("delete"),
                   label = "", icon = icon("trash")
      )
    )
  )
}

#' plot_stacked_bar Server Functions
#'
#' @param comb_tbl A tibble of combined previous and current data.
#' @noRd
mod_plot_stacked_bar_server <- function(id, comb_tbl, x, y = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    tbl_name <- get_ns_tbl_name(ns)
    plot_id <- get_ns_plot_id(ns)

    output$n_ui <- renderUI({
      value <- 8L
      max_n <- length(unique(stats::na.omit(comb_tbl[[x]])))
      if (8L > max_n) {
        value <- max_n
      }
      sliderInput(
        inputId = ns("n"),
        label = "Number of most common categories:",
        min = 1L,
        max = max_n,
        step = 1L,
        value = value
      )
    })

    generate_plot <- reactive({
      req(input$position, input$n, !is.null(input$interactive))
      plot_stacked_bar(
        tbl = comb_tbl, x = x,
        position = input$position,
        n = input$n,
        na.rm = input$na.rm
      )
    })

    output$plot <- renderUI({
      if (input$interactive) {
        plotly::renderPlotly({
          generate_plot() %>%
            plotly::ggplotly()
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
        plot_type = "stacked_bar"
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
# mod_plot_stacked_bar_ui("plot_stacked_bar_1")

## To be copied in the server
# mod_plot_stacked_bar_server("plot_stacked_bar_1")
