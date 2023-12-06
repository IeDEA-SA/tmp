#' tbls_check UI Function
#'
#' @description Module for checking validity of variables of selected tables
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom bslib navset_underline
mod_tbls_check_ui <- function(id) {
  ns <- NS(id)
  navset_underline(id = ns("chk_tbls"))
}

#' tbls_check Server Functions
#'
#' @param tbls Reactive. List of previous and current tibbles for each selected
#' table. Output of the `mod_read_tbls()` module.
#' @param rv Reactive values object containing a `tab_list` element. Used to keep
#' track of currently opened tabs to ensure they are closed each time `tbls()` is
#' updated.
#'
#' @return Reactive. A list of valid tables, processed to clean names and subse
#' to valid shared variables where appropriate.
#'
#' @noRd
mod_tbls_check_server <- function(id, tbls, rv) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    checks <- reactive({
      purrr::map(tbls(), ~ check_tbls(.x))
    })

    observe({
      req(tbls())
      # Clear previous tabs
      if (!is.null(rv$tab_list)) {
        purrr::walk(
          rv$tab_list,
          ~ removeTab("chk_tbls", .x)
        )
      }

      for (tbl_name in names(tbls())) {
        tbl_id <- paste("chk", tbl_name, sep = "_")
        tbl_plots_id <- paste("plt", tbl_name, sep = "_")

        appendTab(
          inputId = "chk_tbls",
          tabPanel(
            title = tbl_name,
            mod_display_check_ui(ns(tbl_id)),
            mod_tbl_plots_ui(ns(tbl_plots_id)),
            value = ns(tbl_name),
            icon = if (checks()[[tbl_name]]$valid) icon("check") else icon("x")
          )
        )

        mod_display_check_server(
          id = tbl_id,
          tbl = tbls()[[tbl_name]],
          tbl_name = tbl_name,
          check = checks()[[tbl_name]]
        )

        mod_tbl_plots_server(
          id = tbl_plots_id,
          tbl = tbls()[[tbl_name]],
          tbl_name = tbl_name,
          check = checks()[[tbl_name]]
        )

        rv$tab_list <- c(rv$tab_list, ns(tbl_name))
      }
    }) %>%
      bindEvent(tbls())
  })
}
