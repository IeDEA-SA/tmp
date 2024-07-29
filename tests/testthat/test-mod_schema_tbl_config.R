# Write the unit test
test_that("mod_schema_tbl_config_server works correctly", {
  tbl <- list(
    previous = tibble(
      a = 1:5,
      b = letters[1:5],
      c = factor(letters[1:5])
    ),
    current = tibble(
      a = 6:10,
      b = letters[6:10],
      c = factor(letters[6:10])
    )
  )

  testServer(
    mod_schema_tbl_config_server,
    args = list(tbl = tbl),
    {
      # Test shared_vars are correctly identified
      expect_equal(shared_vars, c("a", "b", "c"))

      # Test schema_widget classes
      schema_widget_classes <- output$schema_widget$html %>%
        get_html_classes()

      expect_snapshot(schema_widget_classes)

      # Test schema reactiveValues are correctly set
      expect_true(is.reactivevalues(schema))
      expect_equal(names(schema), c("a", "b", "c"))
    }
  )
})
