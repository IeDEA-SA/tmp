#' pk-column UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_pk_column_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("pk_col_select"))
  )
}

#' pk-column Server Functions
#'
#' @noRd
mod_pk_column_server <- function(id, comb_tbl, tbl_name){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$pk_col_select <- renderUI({
      selectInput(ns("pk_col"), "Select Primary Key Column",
                  choices = names(comb_tbl),
                  selected = select_pk_col(comb_tbl,
                                           add = session$userData$pk_col)
      )
    })

   get_pk_col <- reactive({
     req(input$pk_col)
     if (is.null(input$pk_col)) {
       showNotification(
         glue::glue("No primary key column found in table {tbl_name}.
    Please configure a primary key column for the table and try again.",
                    type = "error"
         )
       )
       log_debug("pk col for tbl {tbl_name} not detected.")
       NULL
     } else {
       log_debug("pk col for tbl {tbl_name} assigned.")
       subset_pk_tbl_cols(comb_tbl, pk_col = input$pk_col)
     }
    })

      observe({
        session$userData$pk[[tbl_name]] <- get_pk_col()
      })


  })
}

## To be copied in the UI
# mod_pk_column_ui("pk-column_1")

## To be copied in the server
# mod_pk_column_server("pk-column_1")
