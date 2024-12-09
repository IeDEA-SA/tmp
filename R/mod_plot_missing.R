#' plot_missing UI Function
#'
#' @description Module for creating histogram plot card.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param x Character string. Name of primary key column.
#' @param y Defaults to NULL. Not used in 1 variable plots but required for consistency
#' with 2 var plots.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plot_missing_ui <- function(id, x, y = NULL) {
  ns <- NS(id)
  tagList(
    waiter::waiterOnBusy(color = "lightgrey"),
    card(
      card_header("Missingness plot"),
      full_screen = TRUE,
      layout_sidebar(
        fillable = TRUE,
        sidebar = sidebar(
          title = "Configure plot",
          uiOutput(ns("exclude_ui")),
          shinyjs::disabled(checkboxInput(ns("pk"),
            label = "Compare to primary keys",
            value = FALSE
          )),
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

#' plot_missing Server Functions
#'
#' @param comb_tbl Data frame. Combined data frame with primary key column.
#' @noRd
mod_plot_missing_server <- function(id, comb_tbl, x = NULL, y = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    tbl_name <- get_ns_tbl_name(ns)
    plot_id <- get_ns_plot_id(ns)

    output$exclude_ui <- renderUI({
      selectizeInput(ns("exclude"),
        label = "Exclude columns",
        choices = colnames(comb_tbl)[
          colnames(comb_tbl) != c("tbl_name", "tbl")
        ],
        selected = NULL,
        multiple = TRUE
      )
    })

    generate_plot <- reactive({
      req(!is.null(input$interactive))
      plot_missing(
        tbl = comb_tbl,
        pk_tbl = session$userData$pk[[session$userData$pk_tbl_name]],
        exclude = input$exclude,
        compare_pk = input$pk,
        tbl_pk_col = get_tbl_pk_col(
          session$userData$pk[[get_tbl_name(comb_tbl)]]
          )
      )
    })

    output$plot <- renderUI({
      validate_pk_checkbox(session, comb_tbl)
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
        plot_type = "missing"
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
# mod_plot_missing_ui("plot_missing_1")

## To be copied in the server
# mod_plot_missing_server("plot_missing_1")

validate_pk_checkbox <- function(session, comb_tbl) {
  pk_tbl_name <- session$userData$pk_tbl_name
  tbl_name <- get_tbl_name(comb_tbl)

  pk_not_null <- !is.null(session$userData$pk[[pk_tbl_name]])
  tbl_pk_not_null <- !is.null(session$userData$pk[[tbl_name]])
  not_pk_tbl <- pk_tbl_name != tbl_name
  valid_row_bind <- validate_row_bind(
    session$userData$pk[c(pk_tbl_name, tbl_name)])

  if (all(pk_not_null, tbl_pk_not_null, valid_row_bind, not_pk_tbl)) {
    shinyjs::enable(id = "pk")
  }
}


validate_row_bind <- function(pk_list) {
  check <- pk_list |>
    purrr::map(~ .x["pk"]) |>
    purrr::reduce(dplyr::bind_rows) |>
    try(silent = TRUE)
  !inherits(check, "try-error")
}

get_tbl_name <- function(comb_tbl) {
  unique(comb_tbl[["tbl_name"]])
}
