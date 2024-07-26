library(vdiffr)

test_that("mod_plot_events_by_year_ui generates expected html", {
  html <- mod_plot_events_by_year_ui(
    id = "foo_id",
    x = "enrol_d",
    y = "recart_d"
  ) %>%
    as.character()

  expect_snapshot(get_html_classes(html))
})

test_that("mod_plot_events_by_year_server works", {
  tblBAS <- load_comb_tbl("tblBAS")
  event1 <- "enrol_d"
  event2 <- "recart_d"

  testServer(
    mod_plot_events_by_year_server,
    args = list(
      x = event1, #date column
      comb_tbl = tblBAS,
      y = event2
    ), {
      session$setInputs(
        n = 4L,
        mark_cutoff = TRUE,
        interactive = TRUE,
        t0_tally = TRUE
      )

      # generates a plot
      events_by_year_plot <- generate_plot()

      expect_doppelganger(
        title = "events_by_year_plot",
        events_by_year_plot
      )

      # creates a plotly html output
      plot_output_div <- get_html_classes(output$plot$html)
      expect_snapshot(plot_output_div)

      # adds plot metadata to user session
      session_plot_list <- session$userData$plots[[1]][[1]]

      expect_equal(
        session_plot_list$x,
        "art_sd"
      )

      expect_s3_class(
        session_plot_list$plot,
        "ggplot"
      )

      expect_true(session_plot_list$interactive)

      expect_equal(
        session_plot_list$plot_type,
        "events_by_year"
      )

      # delete plot cleans user session data
      session$setInputs(
        delete = 1
      )
      expect_error(session$userData$plots[[1]][[1]], regexp = "subscript out of bounds")
    })
})
