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
      req(input$select_plot)
      if (!is.null(input$select_plot)) {
        #   purrr::imap(
        #     plot_meta[[input$select_plot]],
        #     ~ selectInput(ns(sprintf("select_var_%s", .y)),
        #       paste("Select", "variable", "to compare"),
        #       choices = setdiff(
        #         names(comb_tbl)[
        #           purrr::map_lgl(comb_tbl, ~ get(sprintf("is.%s", .x))(.x))
        #         ],
        #         c("tbl", "tbl_name")
        #       ),
        #       multiple = FALSE,
        #       selected = NULL,
        #       selectize = TRUE
        #     )
        # )

        output <- tagList()
        for (i in seq_along(plot_meta[[input$select_plot]])) {
          var_type <- plot_meta[[input$select_plot]][[i]]
          var_name <- names(plot_meta[[input$select_plot]])[i]
          id <- sprintf("select_var_%s", var_name)
          fn <- switch(var_type,
            numeric = is.numeric,
            Date = function(x) {
              inherits(x, "Date")
            }
          )

          output[[i]] <- selectInput(ns(sprintf("select_var_%s", var_name)),
            paste("Select", var_name, "variable", "to compare"),
            choices = setdiff(
              names(comb_tbl)[
                purrr::map_lgl(comb_tbl, ~ fn(.x))
              ],
              c("tbl", "tbl_name")
            ),
            multiple = FALSE,
            selected = NULL,
            selectize = TRUE
          )
        }
        output
      }
    })

    output$plot_ui <- renderUI({
      req(input$select_plot)
      if (!is.null(input$select_plot)) {
        plot_ui_mod <- get(paste("mod", input$select_plot, "ui", sep = "_"))
        plot_ui_mod(ns("card"), var = input$select_var_x)
      }
    }) %>%
      bindEvent(input$ok)

    plotModal <- function() {
      modalDialog(
        selectInput(ns("select_plot"),
          "Select plot type",
          choices = names(plot_meta),
          multiple = FALSE,
          selected = "plot_histogram",
          selectize = TRUE
        ),
        uiOutput(ns("select_plot_ui")),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(ns("ok"), "OK")
        )
      )
    }

    mod_observer <- observe(
      {
        showModal(plotModal())
      },
      label = ns("launch-modal-obs")
    )

    observeEvent(input$ok,
      {
        req(input$select_plot)
        if (!is.null(input$select_plot)) {
          plot_server_mod <- get(paste("mod",
            input$select_plot,
            "server",
            sep = "_"
          ))
          plot_server_mod("card", comb_tbl, input$select_var_x)
        }
        mod_observer$destroy()
        removeModal()
      },
      label = ns("modal-ok-obs-event")
    )
  })
}

## To be copied in the UI
# mod_var_plot_modal_ui("var_plot_modal_1")

## To be copied in the server
# mod_var_plot_modal_server("var_plot_modal_1")
