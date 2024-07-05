#' plot_events_by_year UI Function
#'
#' @description A shiny Module plor configure the plot_events_by_year plot.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_events_by_year_ui <- function(id, x, y) {
  ns <- NS(id)
  tagList(
    card(
      card_header(paste(x, "/", y)),
      full_screen = TRUE,
      layout_sidebar(
        fillable = TRUE,
        sidebar = sidebar(
          title = "Configure plot",
          checkboxInput(ns("t0_tally"),
            label = "Count event 2 occurrence in event 1 year",
            value = TRUE
          ),
          checkboxInput(ns("interactive"),
            label = "Display interactive plot",
            value = TRUE
          ),
          checkboxInput(ns("mark_cutoff"),
            label = "Show previous dataset temporal cut-off",
            value = TRUE
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

#' plot_events_by_year Server Functions
#'
#' @noRd
mod_plot_events_by_year_server <- function(id, comb_tbl, x, y) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    tbl_name <- get_ns_tbl_name(ns)
    plot_id <- get_ns_plot_id(ns)


    generate_plot <- reactive({
      req(!is.null(input$mark_cutoff), !is.null(input$interactive))
      plot_events_by_year(comb_tbl,
        event1 = x, event2 = y,
        t0_tally = input$t0_tally,
        mark_cutoff = input$mark_cutoff
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
        y = y,
        plot = generate_plot(),
        interactive = input$interactive,
        plot_type = "events_by_year"
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
# mod_plot_events_by_year_ui("plot_events_by_year_1")

## To be copied in the server
# mod_plot_events_by_year_server("plot_events_by_year_1")
