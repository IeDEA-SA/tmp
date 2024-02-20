#' display_check UI Function
#'
#' @description Check a set of `previous` & `current` data tables for ability to
#' be compared and display the results of the checks.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom bslib card card_header card_body accordion accordion_panel
mod_display_check_ui <- function(id) {
  ns <- NS(id)
  tagList(
    card(
      card_header("Valid shared variables"),
      card_body(strong(textOutput(ns("valid_cols"))))
    ),
    accordion(
      accordion_panel(
        title = "Variable names",
        icon = icon("font"),
        textOutput(ns("names_msg"))
      ),
      accordion_panel(
        title = "Variable data types",
        icon = icon("table"),
        #textOutput(ns("coltypes_msg"))
        mod_schema_config_ui(ns("schema_config"))
      ),
      accordion_panel(
        "tbl Structure",
        icon = icon("magnifying-glass-chart"),
        verbatimTextOutput(ns("tbl_summary"))
      ),
      open = FALSE
    )
  )
}

#' display_check Server Functions
#' @param tbl a list containing two elements:
#' - `previous`: a tibble of previous data
#' - `current`: a tibble of current data
#' to compare.
#' @param tbl_name Character string. The table name.
#' @param check a list of the results of checks output from [check_tbls()].
#'
#' @noRd
mod_display_check_server <- function(id, tbl, tbl_name, check) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$valid_cols <- renderText({
      glue::glue_collapse(
        check$check_coltypes$valid_cols,
        sep = ", "
      )
    })
    output$tbl_summary <- renderPrint({
      message(paste0("printing summary for table", tbl_name))
      utils::str(tbl)
    })

    output$names_msg <- renderText(check$check_names$msg)
    #output$coltypes_msg <- renderText(check$check_coltypes$msg)
    schema_config <- mod_schema_config_server("schema_config", tbl)

    observe(schema_config())
    output$valid <- renderText({
      if (check$valid) "Tables are valid" else "Tables are invalid"
    })
    check_valid_cols <- check$check_coltypes$valid_cols
  })
}
