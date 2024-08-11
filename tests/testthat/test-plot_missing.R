library(vdiffr)

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
  pltly <- plot_missing(tbl, pk_tbl) %>%
    matcha_ggplotly()
  # check ggplotly hover text correct
  expect_snapshot(pltly$x$data[[1]]$text)
  expect_snapshot(pltly$x$data[[2]]$text)

  expect_doppelganger(
    title = "tbl_tblART missing plot + pk",
    {
      plot_missing(tbl, pk_tbl, compare_pk = TRUE)
    }
  )
})
