#' tbls_check UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_tbls_check_ui <- function(id) {
  ns <- NS(id)
  tabsetPanel(id = ns("chk_tbls"))
}

#' tbls_check Server Functions
#'
#' @noRd
mod_tbls_check_server <- function(id, tbls, rv) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    checks <- NULL

    observe({
      req(tbls())
      # Clear previous tabs
      if (!is.null(rv$tab_list)) {
        purrr::walk(
          rv$tab_list,
          ~ removeTab("chk_tbls", .x)
        )
      }

      checks <- as.list(vector(length = length(tbls()))) %>%
        setNames(names(tbls()))

      for (tbl_name in names(tbls())) {
        tbl_id <- paste("chk", tbl_name, sep = "_")
        appendTab(
          inputId = "chk_tbls",
          tabPanel(
            title = tbl_name,
            mod_tbl_check_ui(ns(tbl_id)),
            value = ns(tbl_name)
          )
        )

        checks[[tbl_name]] <- mod_tbl_check_server(
          id = tbl_id,
          tbl = tbls()[[tbl_name]],
          tbl_name = tbl_name
        )
        rv$tab_list <- c(rv$tab_list, ns(tbl_name))
      }
    }) %>%
      bindEvent(tbls())

    return(checks)
  })
}
