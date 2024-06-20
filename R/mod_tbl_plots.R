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
#' @param comb_tbl a reactive list containing two elements:
#' - `previous`: a tibble of previous data
#' - `current`: a tibble of current data
#' to compare.
#' @noRd
mod_tbl_plots_server <- function(id, comb_tbl) {

  log_debug("Creating tbl_plots module with add_plot_observer id: ", id)
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    session$userData$add_plot_observers[[id]] <- observeEvent(
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
          comb_tbl
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
