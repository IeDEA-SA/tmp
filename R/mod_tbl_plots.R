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
mod_tbl_plots_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(ns("add_plot"), "Add plot", icon = icon("plus"), width = '100%',
                 class = "btn-success")
  )
}

#' tbl_plots Server Functions
#'
#' @param tbl a list containing two elements:
#' - `previous`: a tibble of previous data
#' - `current`: a tibble of current data
#' to compare.
#' @param tbl_name Character string. The table name.
#' @param check a list of the results of checks output from [check_tbls()].
#' @noRd
mod_tbl_plots_server <- function(id, tbl, tbl_name, check){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    tbl <- validate_tbl(tbl, check)

    comb_tbl <- combine_tbls(
      current_tbl = tbl$current,
      previous_tbl = tbl$previous
      )
    observeEvent(input$add_plot, {
      insertUI(
        selector = glue::glue("#{ns('add_plot')}"), where = "afterEnd",
        ui = mod_var_plot_modal_ui(
          ns(paste0("plt_", input$add_plot))
        )
      )
      mod_var_plot_modal_server(
        paste0("plt_", input$add_plot),
        comb_tbl
      )
    })

  })
}

## To be copied in the UI
# mod_tbl_plots_ui("tbl_plots_1")

## To be copied in the server
# mod_tbl_plots_server("tbl_plots_1")
