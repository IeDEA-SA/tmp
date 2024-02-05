#' var_plot_modal UI Function
#'
#' @description Module for launching modal to configure new plot.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_var_plot_modal_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("plot_ui"))
  )
}

#' var_plot_modal Server Functions
#'
#' @noRd
mod_var_plot_modal_server <- function(id, comb_tbl) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$select_plot_ui <- renderUI({
      req(input$select_var)
      if (!is.null(input$select_var)) {
        selectInput(ns("select_plot"),
          "Select plot type",
          choices = var_plot_types(input$select_var, comb_tbl),
          multiple = FALSE,
          selectize = TRUE
        )
      }
    })
    output$plot_ui <- renderUI({
      req(input$select_plot)
      if (!is.null(input$select_plot)) {
        plot_ui_mod <- get(paste("mod", input$select_plot, "ui", sep = "_"))
        plot_ui_mod(ns("card"), var = input$select_var)
      }
    }) %>%
      bindEvent(input$ok)

    plotModal <- function(failed = FALSE) {
      modalDialog(
        selectInput(ns("select_var"),
          paste("Select", "variable", "to compare"),
          choices = setdiff(names(comb_tbl), c("tbl", "tbl_name")),
          multiple = FALSE,
          selected = NULL,
          selectize = TRUE
        ),
        uiOutput(ns("select_plot_ui")),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(ns("ok"), "OK")
        )
      )
    }

    observe({
      showModal(plotModal())
    })

    observeEvent(input$ok, {
      req(input$select_plot)
      if (!is.null(input$select_plot)) {
        plot_server_mod <- get(paste("mod",
                                     input$select_plot,
                                     "server", sep = "_"))
        plot_server_mod("card", comb_tbl, input$select_var)
      }
      removeModal()
    })

  })
}

## To be copied in the UI
# mod_var_plot_modal_ui("var_plot_modal_1")

## To be copied in the server
# mod_var_plot_modal_server("var_plot_modal_1")
