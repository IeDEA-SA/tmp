#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

    options(shiny.maxRequestSize=100*1024^2)
    rv <- reactiveValues(tab_list = NULL)

    previous_dat <- mod_access_data_server("access_prev_dat")
    current_dat <- mod_access_data_server("access_curr_dat")

    shared_tables <- reactive({
      req(previous_dat(), current_dat())
      intersect(names(previous_dat()),
                names(current_dat()))
    })
    output$shared_files <- renderText(shared_tables())

    selected_tables <- mod_select_tbls_server("select_tbls", shared_tables)
    tbls <- mod_read_tbls_server("read_tbls",
                                 selected_tables,
                                 previous_dat,
                                 current_dat)

    checks <- mod_tbls_check_server("check_tbls", tbls, rv)

    observe({
      req(checks)
      print(checks)
    })
}
