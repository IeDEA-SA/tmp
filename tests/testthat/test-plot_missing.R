test_that("plot_missing works", {
  tblBAS <- load_comb_tbl("tblBAS")
  pk_tbl <- subset_pk_tbl_cols(tblBAS, add_pk_col = TRUE)

  tbl <- load_comb_tbl("tblART")
  rm_ids <- tbl$patient %>%
    unique() %>%
    head()
  tbl <- dplyr::filter(tbl, !patient %in% rm_ids)

  expect_doppelganger(
    title = "tbl_tblART missing plot",
    {
      plot_missing(tbl, pk_tbl)
    }
  )
})
