library(vdiffr)

test_that("plot_count_by_date works", {
  tbl_tblART <- load_comb_tbl("tblART")

  expect_doppelganger(
    title = "tbl_tblART art_sd mirror",
    {
      plot_count_by_date(tbl_tblART, x = "art_sd", position = "mirror")
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_sd dodge",
    {
      plot_count_by_date(tbl_tblART, x = "art_sd", position = "dodge")
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_sd diff",
    {
      plot_count_by_date(tbl_tblART, x = "art_sd", position = "diff")
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_sd dodge year",
    {
      plot_count_by_date(tbl_tblART,
        x = "art_sd", position = "dodge",
        time_bin = "year"
      )
    }
  )
})



test_that("plot_count_by_date widths scale", {
  tblBAS <- load_comb_tbl("tblBAS")

  expect_doppelganger(
    title = "hiv_pos_d dodge count_by_date day",
    {
      plot_count_by_date(tblBAS,
        x = "hiv_pos_d", position = "dodge",
        time_bin = "day"
      )
    }
  )

  expect_doppelganger(
    title = "hiv_pos_d dodge count_by_date month",
    {
      plot_count_by_date(tblBAS,
        x = "hiv_pos_d", position = "dodge",
        time_bin = "month"
      )
    }
  )

  expect_doppelganger(
    title = "hiv_pos_d dodge count_by_date year",
    {
      plot_count_by_date(tblBAS,
        x = "hiv_pos_d", position = "dodge",
        time_bin = "year"
      )
    }
  )

  expect_doppelganger(
    title = "hiv_pos_d mirror count_by_date day",
    {
      plot_count_by_date(tblBAS,
        x = "hiv_pos_d", position = "mirror",
        time_bin = "day"
      )
    }
  )
  expect_doppelganger(
    title = "hiv_pos_d mirror count_by_date month",
    {
      plot_count_by_date(tblBAS,
        x = "hiv_pos_d", position = "mirror",
        time_bin = "month"
      )
    }
  )
  expect_doppelganger(
    title = "hiv_pos_d mirror count_by_date year",
    {
      plot_count_by_date(tblBAS,
        x = "hiv_pos_d", position = "mirror",
        time_bin = "year"
      )
    }
  )
})
