#' plot_summary_complete UI Function
#'
#' @description Module for creating completeness summary plot card.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param x NULL. Not used in plot_summary_complete but required for consistency.
#' @param y NULL. Not used in plot_summary_complete but required for consistency.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_summary_complete_ui <- function(id, x = NULL, y = NULL){
  ns <- NS(id)
  tagList(
    card(
      card_header(x),
      full_screen = TRUE,
      layout_sidebar(
        fillable = TRUE,
        sidebar = sidebar(
          title = "Configure plot",
          uiOutput(ns("exclude_ui")),
          checkboxInput(ns("interactive"),
                        label = "Display interactive plot",
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

#' plot_summary_complete Server Functions
#'
#' @param comb_tbl NULL. Not used in plot_summary_complete but required for consistency.
#' @noRd
mod_plot_summary_complete_server <- function(id, comb_tbl = NULL, x = NULL, y = NULL){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    tbl_name <- get_ns_tbl_name(ns)
    plot_id <- get_ns_plot_id(ns)

    generate_plot <- reactive({
      req(!is.null(input$interactive))
      plot_summary_complete(
        pk = session$userData$pk,
        pk_col = session$userData$pk_col
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
        x = "summary",
        plot = generate_plot(),
        interactive = input$interactive,
        plot_type = "completeness"
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
# mod_plot_summary_complete_ui("plot_summary_complete_1")

## To be copied in the server
# mod_plot_summary_complete_server("plot_summary_complete_1")
