library(vdiffr)

test_that("plot_summary_complete works", {
  pk <- purrr::map(
    purrr::set_names(c("tblBAS", "tblART", "tblDIS")),
    ~ subset_pk_tbl_cols(
      load_comb_tbl(.x),
      add_pk_col = TRUE
    )
  )

  expect_doppelganger(
    title = "tblBAS tblART tblDIS",
    {
      plot_summary_complete(pk)
    }
  )

  pltly <- plot_summary_complete(pk) %>%
    matcha_ggplotly()
  expect_snapshot(pltly$x$data)
})
