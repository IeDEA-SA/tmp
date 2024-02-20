#' plot_count_by_date UI Function
#'
#' @description Module for creating count by date plot card.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param x Character string. Name of variable being plotted.
#' @param y Defaults to NULL. Not used in 1 variable plots but required for
#' consistency.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_count_by_date_ui <- function(id, x, y = NULL) {
  ns <- NS(id)
  tagList(
    card(
      card_header(x),
      full_screen = TRUE,
      layout_sidebar(
        fillable = TRUE,
        sidebar = sidebar(
          title = "Configure plot",
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

#' plot_count_by_date Server Functions
#'
#' @param comb_tbl A tibble of combined previous and current data.
#' @noRd
mod_plot_count_by_date_server <- function(id, comb_tbl, x, y = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    tbl_name <- get_ns_tbl_name(ns)
    plot_id <- get_ns_plot_id(ns)

    generate_plot <- reactive({
      req(input$position, input$time_bin, input$mark_cutoff, !is.null(input$interactive))
      plot_count_by_date(comb_tbl, x,
                         time_bin = input$time_bin,
                         position = input$position,
                         mark_cutoff = input$mark_cutoff
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
        plot_type = "count_by_date"
      )
    })

    observeEvent(input$delete, {
      session$userData$plots[[tbl_name]][[plot_id]] <- NULL
      delete_id <- gsub("-card", "-plot_ui", ns(NULL))
      removeUI(
        selector = glue::glue("#{delete_id}")
      )
    })
  })
}

## To be copied in the UI
# mod_plot_count_by_date_ui("plot_count_by_date_1")

## To be copied in the server
# mod_plot_count_by_date_server("plot_count_by_date_1")
