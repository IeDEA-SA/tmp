#' access_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param dataset Character string. Dataset identifier. One of `current` or `previous`.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList fileInput
#' @importFrom shinyFiles shinyDirButton
mod_access_data_ui <- function(id, dataset){
  ns <- NS(id)
  tagList(
    h3(paste(dataset, "dataset")),
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

