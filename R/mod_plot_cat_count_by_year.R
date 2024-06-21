#' plot_cat_count_by_year UI Function
#'
#' @description Module for creating count by date plot card.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param x Character string. Name of date column to determine year from.
#' @param y Character string. Name of categorical variable being plotted.
#'
#' @noRd
#'
#'
#' @importFrom shiny NS tagList
mod_plot_cat_count_by_year_ui <- function(id, x, y) {
  ns <- NS(id)
  tagList(
    card(
      card_header(y),
      full_screen = TRUE,
      layout_sidebar(
        fillable = TRUE,
        sidebar = sidebar(
          title = "Configure plot",
          uiOutput(ns("n_ui")),
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

#' plot_cat_count_by_year Server Functions
#'
#' @noRd
mod_plot_cat_count_by_year_server <- function(id, comb_tbl, x, y){
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    tbl_name <- get_ns_tbl_name(ns)
    plot_id <- get_ns_plot_id(ns)

    output$n_ui <- renderUI({
      value <- 4L
      max_n <- length(unique(na.omit(comb_tbl[[y]])))
      if (max_n > 12L) {
        max_n <- 12L
      }
      if (4L > max_n) {
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
      req(input$n, !is.null(input$mark_cutoff), !is.null(input$interactive))
      plot_cat_count_by_year(comb_tbl, date_col = x, y = y,
                         n = input$n,
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
        y = y,
        plot = generate_plot(),
        interactive = input$interactive,
        plot_type = "cat_count_by_year"
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
# mod_plot_cat_count_by_year_ui("plot_cat_count_by_year_1")

## To be copied in the server
# mod_plot_cat_count_by_year_server("plot_cat_count_by_year_1")
