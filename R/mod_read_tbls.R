#' read_tbls UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_read_tbls_ui <- function(id) {
  ns <- NS(id)
  tagList(
    actionButton(ns("readBtn"), "Read Selected Tables"),
    textOutput(ns("msg"))
  )
}

#' read_tbls Server Functions
#'
#' @param selected_tables Reactive. Names of selected shared tables.
#' @param previous_dat Reactive. Named vector of file paths to tables in the
#' directory containing previous data.
#' @param current_dat Reactive. Named vector of file paths to tables in the
#' directory containing current data.
#' @noRd
#' @return A reactive which returns a list, one element for each table in
#' `selected_tables`. Each table element contains a list of two elements:
#' - `previous`: a tibble of previous data
#' - `current`: a tibble of current data
mod_read_tbls_server <- function(id, selected_tables, previous_dat, current_dat) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output[["msg"]] <- renderText({
      req(selected_tables)
      if (length(selected_tables()) > 1L) {
        txt <- "Tables"
      } else {
        txt <- "Table"
      }
      glue::glue("{txt} {selected_tables()} read successfully.")
    }) %>% bindEvent(input$readBtn,
      ignoreNULL = TRUE,
      ignoreInit = TRUE
    )

    observe({
      req(selected_tables)
      purrr::map(
        selected_tables(),
        ~ showNotification(
          glue::glue("Table {.x} read successfully."),
          type = "message"
        )
      )
    }) %>% bindEvent(input$readBtn,
      ignoreNULL = TRUE,
      ignoreInit = TRUE
    )
    reactive({
      req(selected_tables())
      purrr::map(
        .x = purrr::set_names(selected_tables()),
        ~ {
          list(
            previous = read_file(previous_dat()[.x]),
            current = read_file(current_dat()[.x])
          )
        }
      )
    }) %>% bindEvent(input$readBtn,
      ignoreNULL = TRUE,
      ignoreInit = TRUE
    )
  })
}
