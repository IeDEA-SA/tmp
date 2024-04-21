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
    actionButton(ns("readBtn"), "Read Selected Tables",
      class = "btn-secondary"
    )
  )
}

#' Read Tables Module Server
#'
#' This Shiny module server function reads tables from disk based on a list of
#' selected tables. It updates the UI with notifications for each successfully
#' read table and stores the read data reactively for further processing. The
#' module is designed to be triggered by a UI event (e.g., clicking a "Read
#' Tables" button).
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
#'
mod_read_tbls_server <- function(id, selected_tables, previous_dat, current_dat) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe({
      req(selected_tables)
      purrr::map(
        setdiff(selected_tables(), session$userData$tab_list$table_name),
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
      log_debug("reading data from disk")
      purrr::map(
        .x = purrr::set_names(selected_tables()),
        ~ {
          previous_file_path <- previous_dat()[.x]
          current_file_path <- current_dat()[.x]

          list(
            previous = read_file(previous_file_path),
            current = read_file(current_file_path)
          ) %>%
            set_source_hash(c(previous_file_path, current_file_path))
        }
      )
    }) %>% bindEvent(input$readBtn,
      ignoreNULL = TRUE,
      ignoreInit = TRUE
    )
  })
}
