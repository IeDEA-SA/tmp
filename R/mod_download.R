#' download UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom shinyWidgets awesomeRadio
mod_download_ui <- function(id) {
  ns <- NS(id)
  tagList(
    downloadButton(ns("report"), "Generate report", class = "btn-secondary"),
    awesomeRadio(ns("format"), "Select report format:",
                 choices = c("html", "pdf"),
                 selected = "html",
                 inline = TRUE,
                 checkbox = TRUE)
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
        glue::glue("report_{Sys.Date()}.{input$format}")
        #paste0("report_", Sys.Date(), ".html")
      },
      content = function(file) {
        w <- add_waiter(msg = "Generating report...")

        tempReport <- file.path(tempdir(), "report.Rmd")
        report_path <- system.file("report.Rmd", package = "MATCHA")
        file.copy(report_path, tempReport, overwrite = TRUE)

        format <- switch(input$format,
                         html = "html_document",
                         pdf = "pdf_document")

        rmarkdown::render(
          input = tempReport,
          output_file = file,
          output_format = format,
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
