#' access_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList fileInput
#' @importFrom shinyFiles shinyDirButton
mod_access_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyDirButton(ns("folder"), "Select a folder",
                   "Please select a folder",
                   FALSE),
    textOutput(ns("folder_path"))

  )
}

#' access_data Server Functions
#'
#' @noRd
#' @importFrom shinyFiles shinyDirChoose parseDirPath
mod_access_data_server <- function(id){
  moduleServer( id, function(input, output, session){

    ns <- session$ns
    roots <- c("." = here::here(), "home" = fs::path_home())

    shinyDirChoose(input, "folder", roots = roots,
                   filetypes = c("", "csv", "rds", "dta"),
                   allowDirCreate = FALSE)

    output$folder_path <- renderText({
      req(input$folder)
      parseDirPath(roots, input$folder)
      })

    reactive({
      folder <- input$folder
      req(folder)

      file_paths <- fs::dir_ls(parseDirPath(roots, folder))
      names(file_paths) <- fs::path_file(file_paths) %>%
        fs::path_ext_remove()

      file_paths
      })
  })
}

## To be copied in the UI
# mod_access_data_ui("access_data_1")

## To be copied in the server
# mod_access_data_server("access_data_1")
