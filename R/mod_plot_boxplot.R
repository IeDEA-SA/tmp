#' plot_boxplot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_boxplot_ui <- function(id, x, y = NULL) {
  ns <- NS(id)
  tagList(
    card(
      card_header(x),
      full_screen = TRUE,
      layout_sidebar(
        fillable = TRUE,
        sidebar = sidebar(
          title = "Configure plot",
          checkboxInput(ns("interactive"),
            label = "Display interactive plot",
            value = TRUE
          ),
          checkboxInput(ns("log"),
            label = "Log transform variable",
            value = FALSE
          ),
          checkboxInput(ns("include_violin"),
            label = "Include violin plot layer",
            value = FALSE
          ),
          checkboxInput(ns("include_points"),
            label = "Include data point layer",
            value = FALSE
          ),
          checkboxInput(ns("show_outliers"),
            label = "Show outliers",
            value = TRUE
          ),
          checkboxInput(ns("varwidth"),
            label = "Scale box width by sample size",
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

#' plot_boxplot Server Functions
#'
#' @noRd
mod_plot_boxplot_server <- function(id, comb_tbl, x, y = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    tbl_name <- get_ns_tbl_name(ns)
    plot_id <- get_ns_plot_id(ns)

    generate_plot <- reactive({
      req(
        !is.null(input$include_violin),
        !is.null(input$interactive),
        !is.null(input$varwidth),
        !is.null(input$show_outliers),
        !is.null(input$log)
      )

      plot_boxplot(
        tbl = comb_tbl, x = x,
        include_violin = input$include_violin,
        include_points = input$include_points,
        varwidth = input$varwidth,
        show_outliers = input$show_outliers,
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
        plot_type = "boxplot"
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
# mod_plot_boxplot_ui("plot_boxplot_1")

## To be copied in the server
# mod_plot_boxplot_server("plot_boxplot_1")
