test_that("plot_events_by_year works", {
  tblBAS <- load_comb_tbl("tblBAS")
  tbl <- load_comb_tbl("tblBAS")
  event1 <- "enrol_d"
  event2 <- "recart_d"

  expect_doppelganger(
    title = "tblBAS enrol_d-recart_d",
    {
    plot_events_by_year(tblBAS, event1, event2,
                        t0_tally = TRUE, mark_cutoff = TRUE)
    }
  )

  expect_doppelganger(
    title = "tblBAS enrol_d-recart_d t0_tally=FALSE",
    {
    plot_events_by_year(tblBAS, event1, event2,
                        t0_tally = FALSE, mark_cutoff = TRUE)
    }
  )
})
