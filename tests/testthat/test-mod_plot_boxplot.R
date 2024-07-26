library(vdiffr)

test_that("mod_plot_boxplot_server works", {
  testServer(
    mod_plot_boxplot_server,
    args = list(
      x = "weigh",
      comb_tbl = get_test_combined_data()[1:20, ],
      y = NULL
    ), {
    tbl_name <- "foo_table"
    plot_id <- "foo_plot_id"

    session$setInputs(
      include_violin = FALSE,
      interactive = TRUE,
      varwidth = TRUE,
      show_outliers = TRUE,
      log = FALSE,
      include_points = TRUE
    )

    # generates a plot
    box_plot <- generate_plot()

    expect_doppelganger(
      title = "plot_boxplot log",
      box_plot
    )

    # creates a plotly html output
    plot_output_div <- output$plot$html %>%
      xml2::read_html() %>%
      xml2::xml_find_all(".//div") %>%
      xml2::xml_attr("class")

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

    expect_true(session_plot_list$interactive)

    expect_equal(
      session_plot_list$plot_type,
      "boxplot"
    )
  })
})
