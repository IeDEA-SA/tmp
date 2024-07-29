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
#' @importFrom bslib card card_header tooltip
mod_access_data_ui <- function(id, dataset) {
  ns <- NS(id)
  tagList(
    card(
      card_header(
        paste(dataset, "dataset"),
        file_access_info
      ),
      shinyDirButton(
        id = ns("folder"), label = "Select a folder",
        title = "Please select a folder",
        multiple = FALSE,
        icon = icon("folder"),
        buttonType = "primary"
      ),
      verbatimTextOutput(ns("folder_path"))
    )
  )
}

#' access_data Server Functions
#'
#' @noRd
#' @importFrom shinyFiles shinyDirChoose parseDirPath
mod_access_data_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    roots <- c(
      demo_data = system.file("test-data", package = "MATCHA"),
      "home" = fs::path_home(),
      "." = getwd()
    )

    shinyDirChoose(input, "folder",
      roots = roots,
      filetypes = c("", "csv", "rds", "dta", "sav", "por", "sas7bdat", "sas7bcat"),
      allowDirCreate = FALSE
    )

    output$folder_path <- renderPrint({
      req(input$folder)
      parseDirPath(roots, input$folder)
    })

    reactive({
      folder <- input$folder
      req(folder)

      file_paths <- fs::dir_ls(parseDirPath(roots, folder))
      names(file_paths) <- fs::path_file(file_paths) %>%
        fs::path_ext_remove()

      if (any(duplicated(names(file_paths)))) {
        dup_names <- names(file_paths)[duplicated(names(file_paths))]
        showNotification(
          ui = markdown(glue::glue(
            "### Duplicate File names

            Duplicate file names {vector_to_md_list(dup_names, as_code = TRUE, bold = TRUE, sep = ',')}
            detected in: `{parseDirPath(roots, folder)}`."
          )),
          action = markdown(
            "
            ***

            Please close app,
            ensure all files in source directories have unique names,
            **regardless of file extension** and try again."
          ),
          duration = NULL,
          type = "error"
        )
      }

      file_paths
    })
  })
}
