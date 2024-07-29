library(vdiffr)

test_that("mod_plot_histogram_ui generates expected html", {
  html <- mod_plot_histogram_ui(
    id = "foo_id",
    x = "my_col",
    y = NULL
  ) %>%
    as.character()

  expect_snapshot(get_html_classes(html))
})

test_that("mod_plot_histogram_server works", {
  comb_tbl <- load_comb_tbl("tblART", ext = "csv", test_dir = "csv")

  testServer(
    mod_plot_histogram_server,
    args = list(
      x = "art_comb",
      comb_tbl = comb_tbl,
      y = NULL
    ), {
      session$setInputs(
        position = "dodge",
        bins = 30L,
        interactive = TRUE,
        log = TRUE
      )

      # generates a plot
      histogram_plot <- generate_plot()

      expect_doppelganger(
        title = "histogram_plot",
        histogram_plot
      )

      # creates a plotly html output
      plot_output_div <- get_html_classes(output$plot$html)
      expect_snapshot(plot_output_div)

      # adds plot metadata to user session
      session_plot_list <- session$userData$plots[[1]][[1]]

      expect_equal(
        session_plot_list$x,
        "art_comb"
      )

      expect_s3_class(
        session_plot_list$plot,
        "ggplot"
      )

      expect_true(session_plot_list$interactive)

      expect_equal(
        session_plot_list$plot_type,
        "histogram"
      )

      # delete plot cleans user session data
      session$setInputs(
        delete = 1
      )
      expect_error(session$userData$plots[[1]][[1]], regexp = "subscript out of bounds")
    })
})
