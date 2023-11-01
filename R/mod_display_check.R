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
#' @importFrom bslib card card_header card_body
mod_display_check_ui <- function(id){
  ns <- NS(id)
  tagList(
    h3(textOutput(ns("tbl_name"))),
    h4(textOutput(ns("valid"))),
    card(
      card_header("Valid shared variables"),
      card_body(strong(textOutput(ns("valid_cols"))))
      ),
    h4("Check tbl variable names"),
    textOutput(ns("names_msg")),
    hr(),
    h4("Check tbl variable data types"),
    textOutput(ns("coltypes_msg")),
    hr(),
    h4("tbl Structure"),
    verbatimTextOutput(ns("tbl_summary"))
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
mod_display_check_server <- function(id, tbl, tbl_name, check){
  moduleServer( id, function(input, output, session){
    print(tbl_name)
    print(tbl)
    print(check)
    ns <- session$ns
    output$tbl_name <- renderText(tbl_name)
    output$valid_cols <- renderText({
      glue::glue_collapse(
        check$check_coltypes$valid_cols,
        sep = ", ")
      })
    output$tbl_summary <- renderPrint(str(tbl))
    output$names_msg <- renderText(check$check_names$msg)
    output$coltypes_msg <- renderText(check$check_coltypes$msg)
    output$valid <- renderText({
      if (check$valid) "Tables are valid" else "Tables are invalid"
    })
  })
}

