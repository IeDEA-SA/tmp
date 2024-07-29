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
    card(
      card_header(
        class = "d-flex justify-content-between",
        "Format",
        awesomeRadio(ns("format"),
          label = "",
          choices = c("HTML" = "html", "PDF" = "pdf"),
          selected = "html",
          inline = TRUE,
          checkbox = TRUE
        )
      ),
      card_body(
        downloadButton(ns("report"),
          "Generate report",
          class = "btn-secondary"
        )
      )
    )
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
      },
      content = function(file) {
        w <- add_waiter(msg = "Generating report...")

        tempReport <- file.path(tempdir(), "report.Rmd")
        report_path <- system.file("report.Rmd", package = "MATCHA")
        file.copy(report_path, tempReport, overwrite = TRUE)

        format <- switch(input$format,
          html = "html_document",
          pdf = "pdf_document"
        )

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
