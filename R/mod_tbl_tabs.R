#' tbls_check UI Function
#'
#' @description Module for creating panels for selected tables
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom bslib navset_underline
mod_tbl_tabs_ui <- function(id) {
  ns <- NS(id)
  navset_underline(id = ns("tab"))
}

#' tbls_check Server Functions
#'
#' @param tbls Reactive. List of previous and current tibbles for each selected
#' table. Output of the `mod_read_tbls()` module.
#'
#' @return Reactive. A list of valid tables, processed to clean names and subse
#' to valid shared variables where appropriate.
#'
#' @noRd
mod_tbl_tabs_server <- function(id, tbls) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    checks <- reactive({
      purrr::map(tbls(), ~ check_tbls(.x))
    })

    observe({
      req(tbls())
      # Clear previous tabs

      remove_tabs <- setdiff(session$userData$tab_list, names(tbls()))
      add_tabs <- setdiff(names(tbls()), session$userData$tab_list)


      if (length(remove_tabs) > 0) {
        remove_tabs <- ns(remove_tabs)
        purrr::walk(
          remove_tabs,
          ~ {
            # removeUI(selector = sprintf("div:has(> #%s)", .x),
            #          multiple = TRUE)
            removeTab("tab", .x)
            remove_shiny_inputs(.x, input, parent_id = sprintf("%s-", ns(NULL)))
            remove_shiny_outputs(.x, output, parent_id = sprintf("%s-", ns(NULL)))
          }
        )
        session$userData$plots <- list()
      }

      for (tbl_name in add_tabs) {
        tbl_id <- tbl_name
        tbl_plots_id <- tbl_name

        appendTab(
          inputId = "tab",
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

        session$userData$tab_list <- names(tbls())
      }
    }) %>%
      bindEvent(tbls())
  })
}
