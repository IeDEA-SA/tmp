library(vdiffr)

test_that("mod_plot_boxplot_ui generates expected html", {
  html <- mod_plot_boxplot_ui(id = "foo_id", x = "weigh") %>%
    as.character()

  expect_snapshot(get_html_classes(html))
})

test_that("mod_plot_boxplot_server works", {
  testServer(
    mod_plot_boxplot_server,
    args = list(
      x = "weigh",
      comb_tbl = get_test_combined_data()[1:20, ],
      y = NULL
    ),
    {
      set.seed(123)
      session$setInputs(
        include_violin = FALSE,
        interactive = TRUE,
        varwidth = TRUE,
        show_outliers = TRUE,
        log = FALSE,
        include_points = TRUE
      )

      # creates a plotly html output
      plot_output_div <- get_html_classes(output$plot$html)
      expect_snapshot(plot_output_div)

      # adds plot metadata to user session
      session_plot_list <- session$userData$plots[[1]][[1]]

      expect_equal(
        session_plot_list$x,
        "weigh"
      )

      expect_s3_class(
        session_plot_list$plot,
        "ggplot"
      )

      expect_doppelganger(
        title = "plot_boxplot-mod",
        session_plot_list$plot
      )

      expect_true(session_plot_list$interactive)

      expect_equal(
        session_plot_list$plot_type,
        "boxplot"
      )

      # delete plot cleans user session data
      session$setInputs(
        delete = 1
      )
      expect_error(session$userData$plots[[1]][[1]], regexp = "subscript out of bounds")
    }
  )
})
