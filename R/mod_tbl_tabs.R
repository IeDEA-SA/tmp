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
#'
#' @importFrom shiny insertTab
mod_tbl_tabs_server <- function(id, tbls) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    checks <- reactive({
      purrr::map(tbls(), ~ check_tbls(.x))
    })

    clean_tbls <- reactiveValues()

    observe({
      req(tbls())

      selected_sources_lookup <- get_tbl_hash_lookup(tbls())
      selected_source_hashes <- names(selected_sources_lookup)
      tab_list_source_hashes <- names(session$userData$tab_list)

      remove_tabs <- session$userData$tab_list[
        setdiff(tab_list_source_hashes, selected_source_hashes)
      ]
      add_tabs <- selected_sources_lookup[
        setdiff(selected_source_hashes, tab_list_source_hashes)
      ]

      selected_tab <- input$tab

      # If any tabs deleted, clear them
      if (isTRUE(length(remove_tabs) > 0)) {
        log_debug("remove tabs {remove_tabs}")
        remove_tab_ns <- ns(remove_tabs)
        purrr::walk2(
          remove_tab_ns, remove_tabs,
          ~ {
            # removeUI(selector = sprintf("div:has(> #%s)", .x),
            #          multiple = TRUE)
            removeUI(
              selector = "div:has(> '#shiny-modal')",
              multiple = TRUE
            )

            removeTab("tab", .x)
            remove_shiny_inputs(.x, input, parent_id = sprintf("%s-", ns(NULL)))
            remove_shiny_outputs(.x, output, parent_id = sprintf("%s-", ns(NULL)))
            # Remove any previously created plots
            session$userData$plots[[.y]] <- NULL
            session$userData$add_plot_observers[[.y]]$destroy()
          }
        )
      }

      for (tbl_name in add_tabs) {
        tab_index <- which(names(tbls()) %in% tbl_name)
        tab_panel <- tabPanel(
          title = tbl_name,
          mod_display_check_ui(ns(tbl_name)),
          mod_tbl_plots_ui(ns(tbl_name)),
          value = ns(tbl_name),
          icon = if (checks()[[tbl_name]]$valid) icon("check") else icon("x")
        )
        if(tab_index == 1) {
          prependTab(
            inputId = "tab",
            tab_panel,
            select = selected_tab
          )
        } else {
          insertTab(
            inputId = "tab",
            target = names(tbls())[tab_index - 1] %>% ns(),
            position = "after",
            tab_panel,
            select = selected_tab
          )
        }

        clean_tbls[[tbl_name]] <- mod_display_check_server(
          id = tbl_name,
          tbl = tbls()[[tbl_name]],
          tbl_name = tbl_name,
          check = checks()[[tbl_name]]
        )

        mod_tbl_plots_server(
          id = tbl_name,
          tbl = clean_tbls[[tbl_name]],
          tbl_name = tbl_name
        )
      }
      session$userData$tab_list <- get_tbl_hash_lookup(tbls())
    }) %>%
      bindEvent(tbls())
  })
}
