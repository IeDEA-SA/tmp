#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
    options(shiny.maxRequestSize=100*1024^2)
  # Your application server logic
    dataset_1 <- mod_access_data_server("access_data_1")
    dataset_2 <- mod_access_data_server("access_data_2")

    shared_tables <- reactive({
      req(dataset_1)
      req(dataset_2)
      intersect(names(dataset_1()),
                names(dataset_2()))
    })
    output$shared_files <- renderText(shared_tables())

    selected_tables <- mod_select_tbls_server("select_tbls", shared_tables)
    mod_read_tbls_server("read_tbls", selected_tables, dataset_1, dataset_2)

}
