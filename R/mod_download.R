#' download UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_ui <- function(id) {
  ns <- NS(id)
  tagList(
    downloadButton(ns("report"), "Generate report", class = "btn-secondary"),
  )
}

#' download Server Functions
#'
#' @noRd
mod_download_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$report <- downloadHandler(
      filename = function() {
        paste0("report_", Sys.Date(), ".html")
      },
      content = function(file) {
        w <- add_waiter(msg = "Generating report...")

        tempReport <- file.path(tempdir(), "report.Rmd")
        report_path <- system.file("report.Rmd", package = "MATCHA")
        file.copy(report_path, tempReport, overwrite = TRUE)


        rmarkdown::render(
          input = tempReport,
          output_file = file,
          params = list(
            plots = session$userData$plots
          )
        )
      }
    )
  })
}

## To be copied in the UI
# mod_download_ui("download_1")

## To be copied in the server
# mod_download_server("download_1")
