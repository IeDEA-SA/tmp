test_that("Invalilid table pairs are captured correctly", {
  tbls_invalid <- reactive(
    list(
      tbl_pair1 = list(
        previous = iris,
        current = mtcars
      ) %>%
        structure(source_hash = "hash1")
    )
  )
  testServer(
    mod_tbl_tabs_server,
    args = list(
      tbls = tbls_invalid
    ), {
      pair_checks <- checks()$tbl_pair1
      expect_false(pair_checks$valid)
      expect_false(pair_checks$check_names$valid)
      expect_false(pair_checks$check_coltypes$valid)
    }
  )
})
