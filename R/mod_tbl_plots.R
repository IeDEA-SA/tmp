#' tbl_plots UI Function
#'
#' @description Module for adding, removing and configuring plots for variables
#' in a table.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_tbl_plots_ui <- function(id) {
  ns <- NS(id)
  tagList(
    actionButton(ns("add_plot"), "Add plot",
      icon = icon("plus"), width = "100%",
      class = "btn-success"
    )
  )
}

#' tbl_plots Server Functions
#'
#' @param tbl a reactive list containing two elements:
#' - `previous`: a tibble of previous data
#' - `current`: a tibble of current data
#' to compare.
#' @param tbl_name Character string. The table name.
#' @noRd
mod_tbl_plots_server <- function(id, tbl, tbl_name) {
  stopifnot(is.reactive(tbl))

  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    comb_tbl <- reactive({
      req(tbl())
      combine_tbls(
        current_tbl = tbl()$current,
        previous_tbl = tbl()$previous,
        tbl_name = tbl_name
      )
    })

    session$userData$add_plot_observers[[tbl_name]] <- observeEvent(
      input$add_plot,
      {
        plot_id <- make_uuid()
        log_debug(paste("Creating new plot:", plot_id))
        insertUI(
          selector = glue::glue("#{ns('add_plot')}"), where = "beforeBegin",
          ui = mod_var_plot_modal_ui(
            ns(plot_id)
          )
        )
        mod_var_plot_modal_server(
          plot_id,
          comb_tbl()
        )
      },
      ignoreInit = TRUE,
      label = ns("add-plot")
    )
  })
}

## To be copied in the UI
# mod_tbl_plots_ui("tbl_plots_1")

## To be copied in the server
# mod_tbl_plots_server("tbl_plots_1")
