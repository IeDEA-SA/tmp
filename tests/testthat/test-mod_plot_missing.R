library(vdiffr)

test_that("mod_plot_missing_ui generates expected html", {
  html <- mod_plot_missing_ui(
    id = "foo_id",
    x = "foo_col",
    y = NULL
  ) %>%
    as.character()

  expect_snapshot(get_html_classes(html))
})

test_that("mod_plot_missing_server works", {
  # first test table
  tbl <- load_comb_tbl("tblART")
  rm_ids <- tbl$patient %>%
    unique() %>%
    head()
  tbl <- dplyr::filter(tbl, !patient %in% rm_ids)

  # second test table
  pk_tbl <- load_comb_tbl("tblBAS") %>%
    subset_pk_tbl_cols(add_pk_col = TRUE)

  # mock session with userData
  mock_session <- MockShinySession$new()
  mock_session$userData$pk_tbl_name <- "tblBAS"
  mock_session$userData$pk_col <- "patient"
  mock_session$userData$pk[[mock_session$userData$pk_tbl_name]] <- pk_tbl
  mock_session$userData$pk[["tblART"]] <- subset_pk_tbl_cols(tbl, add_pk_col = TRUE)

  testServer(
    mod_plot_missing_server,
    args = list(
      comb_tbl = tbl,
      x = NULL,
      y = NULL
    ),
    session = mock_session,
    {
      # exclude ui is generated
      exclude_ui_selectise <- output$exclude_ui$html

      expect_snapshot(exclude_ui_selectise)

      # updating inputs
      session$setInputs(
        interactive = TRUE,
        exclude = NULL,
        pk = TRUE
      )
      # generates a plot
      missing_data_plot <- generate_plot()

      expect_doppelganger(
        title = "missing_data_plot",
        missing_data_plot
      )

      # creates a plotly html output
      plot_output_div <- get_html_classes(output$plot$html)
      expect_snapshot(plot_output_div)

      # adds plot metadata to user session
      session_plot_list <- session$userData$plots[[1]][[1]]

      expect_equal(
        session_plot_list$x,
        NULL
      )

      expect_s3_class(
        session_plot_list$plot,
        "ggplot"
      )

      expect_true(session_plot_list$interactive)

      expect_equal(
        session_plot_list$plot_type,
        "missing"
      )

      # delete plot cleans user session data
      session$setInputs(
        delete = 1
      )
      expect_error(session$userData$plots[[1]][[1]], regexp = "subscript out of bounds")

      # updating inputs
      session$setInputs(
        interactive = TRUE,
        exclude = NULL,
        pk = FALSE
      )
      expect_doppelganger(
        title = "missing_data_plot no pk",
        session$userData$plots[[1]][[1]]$plot
      )
    }
  )
})
