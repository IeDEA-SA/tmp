#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr tibble
#' @noRd
app_server <- function(input, output, session) {
  options(shiny.maxRequestSize = 100 * 1024^2)
  session$userData$plots <- list()
  session$userData$add_plot_observers <- list()
  session$userData$tab_list <- tibble(
    source_hash = character(),
    tbl_name = character(),
    tab_id = character()
  )


  previous_dat <- mod_access_data_server("access_prev_dat")
  current_dat <- mod_access_data_server("access_curr_dat")

  shared_tables <- get_shared_nms_rct(
    previous = reactive(previous_dat()),
    current = reactive(current_dat())
  )

  selected_tables <- mod_dynamic_select_server("select_tbls",
    property = "tables",
    choices = shared_tables
  )
  tbls <- mod_read_tbls_server(
    "read_tbls",
    selected_tables,
    previous_dat,
    current_dat
  )
  mod_tbl_tabs_server("tbl_tab", tbls)

  mod_download_server("download")
}
