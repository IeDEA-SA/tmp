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
    waiter::useWaiter(),
    layout_column_wrap(
      width = 1 / 2,
      card(
        card_header("Valid shared variables"),
        card_body(strong(textOutput(ns("valid_cols"))))
      ),
      card(
        id = ns("spinner")
      )
    ),
    accordion(
      accordion_panel(
        title = "Variable validation",
        icon = icon("font"),
        uiOutput(ns("tab_validation_boxes"))
      ),
      accordion_panel(
        "tbl Structure",
        icon = icon("magnifying-glass-chart"),
        navset_card_tab(
          height = 450,
          full_screen = TRUE,
          nav_panel(
            "Previous",
            card_title("Previous data summary"),
            verbatimTextOutput(ns("tbl_skim_previous"))
          ),
          nav_panel(
            "Current",
            card_title("Current data summary"),
            verbatimTextOutput(ns("tbl_skim_current"))
          )
        )
      ),
      accordion_panel(
        id = ns("schema_config_panel"),
        title = "Configure Table schema",
        icon = icon("table"),
        mod_schema_tbl_config_ui(ns("schema_config"))
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

    tbl <- validate_tbl(tbl, check)

    output$tab_validation_boxes <- renderUI({
      tab_validation_boxes(
        valid_vars = check$check_coltypes$valid_cols,
        invalid_vars = check$check_coltypes$invalid_cols,
        coerced_vars = check$check_coltypes$coerced_cols)
    })

    output$valid_cols <- renderText({
      glue::glue_collapse(
        check$check_coltypes$valid_cols,
        sep = ", "
      )
    })

    schema_config <- mod_schema_tbl_config_server(
      "schema_config", tbl
    )

    waiting_screen <- tagList(
      waiter::spin_flower(),
      h4("Applying schema changes...")
    )

    # return table with schema applied, ready for plotting
    schema_tbl <- reactive({
      w <- waiter::Waiter$new(
        id = ns("spinner"),
        html = waiting_screen, color = "maroon",
        fadeout = TRUE,
        hide_on_render = TRUE
      )
      w$show()
      on.exit({
        w$hide()
      })

      schema_list <- schema_config %>%
        reactiveValuesToList()
      apply_schema(
        tbl,
        schema_list
      )
    })

    output$tbl_skim_current <- renderPrint({
      skimr::skim(schema_tbl()$current)
    })
    output$tbl_skim_previous <- renderPrint({
      skimr::skim(schema_tbl()$previous)
    })

    # Return the clean table with any schema changes applied
    schema_tbl
  })
}
