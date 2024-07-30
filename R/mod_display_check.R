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
    uiOutput(ns("valid_cols")),
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


    output$valid_cols <- renderUI({
      card(
        id = ns("display-spinner"),
        card_header("Valid shared variables", class = "bg-secondary"),
        card_body(
          markdown(
            paste(
              "The following variables are valid and shared between the `previous` and `current` tables: \n\n",
              vector_to_md_list(check$check_coltypes$valid_cols,
                sep = ",", bold = TRUE
              )
            )
          )
        ),
        if (check$check_names$clean) {
          card_footer(
            icon("broom"),
            " Name cleaning required to match variables between tables."
          )
        } else {
          NULL
        }
      )
    })

    output$tab_validation_boxes <- renderUI({
      tab_validation_boxes(
        valid_vars = check$check_coltypes$valid_cols,
        invalid_vars = check$check_coltypes$invalid_cols,
        coerced_vars = check$check_coltypes$coerced_cols
      )
    })

    schema_config <- mod_schema_tbl_config_server(
      "schema_config", tbl
    )

    # return table with schema applied, ready for plotting
    schema_tbl <- reactive({
      w <- add_waiter(
        msg = "Applying schema changes...",
        id = ns("display-spinner")
      )

      schema_list <- schema_config %>%
        reactiveValuesToList()
      apply_schema(
        tbl,
        schema_list
      )
    })


    skim_tables <- reactive({
      skim_tables <- list(
        current = skimr::skim(schema_tbl()$current),
        previous = skimr::skim(schema_tbl()$previous)
      )
      skim_tables
    })

    output$tbl_skim_current <- renderPrint({
      session$userData$skims[[tbl_name]]$current <- skim_tables()$current
      skim_tables()$current
    })

    output$tbl_skim_previous <- renderPrint({
      session$userData$skims[[tbl_name]]$previous <- skim_tables()$previous
      skim_tables()$previous
    })
    # Force the output to be executed even if it's not visible
    outputOptions(output, "tbl_skim_current", suspendWhenHidden = FALSE)
    outputOptions(output, "tbl_skim_previous", suspendWhenHidden = FALSE)

     # Return the clean table with any schema changes applied
    schema_tbl
  })
}
