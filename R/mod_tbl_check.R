#' tbl_check UI Function
#'
#' @description Check a set of `previous` & `current` data tables for ability to
#' be compared and display the results of the checks.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_tbl_check_ui <- function(id){
  ns <- NS(id)
  tagList(
    h3(textOutput(ns("tbl_name"))),
    verbatimTextOutput(ns("tbl_summary")),
    h4("Check tbl variable names"),
    textOutput(ns("names_msg")),
    hr(),
    h4("Check tbl variable data types"),
    textOutput(ns("coltypes_msg")),
    h4(textOutput(ns("valid")))
  )
}

#' tbl_check Server Functions
#' @param tbl a list containing two elements:
#' - `previous`: a tibble of previous data
#' - `current`: a tibble of current data
#' to compare.
#' @param tbl_name Character string. The table name.
#' @return a list of the results of checks output from [check_tbls()].
#'
#' @noRd
mod_tbl_check_server <- function(id, tbl, tbl_name){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    print(tbl_name)
    output$tbl_name <- renderText(tbl_name)
    output$tbl_summary <- renderPrint(str(tbl))

    checks <- check_tbls(tbl)
    output$names_msg <- renderText(checks$check_names$msg)
    output$coltypes_msg <- renderText(checks$check_coltypes$msg)
    output$valid <- renderText({
      if (checks$valid) "Tables are valid" else "Tables are invalid"
      })

    return(checks)
  })
}

## To be copied in the UI
# mod_tbl_check_ui("tbl_check_1")

## To be copied in the server
# mod_tbl_check_server("tbl_check_1")
