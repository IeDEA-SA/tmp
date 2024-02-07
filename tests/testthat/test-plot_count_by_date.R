library(vdiffr)

test_that("plot_count_by_date works", {
  tblname <- "tblART"
  ext <- "dta"
  test_dir <- "stata"
  file <- fs::path(tblname, ext = ext)


  tbl_tblART <- combine_tbls(
    previous = suppressWarnings(
      read_file(
        system.file("test-data", test_dir, "01_previous", file, package = "MATCHA")
      )
    ),
    current = suppressWarnings(
      read_file(
        system.file("test-data", test_dir, "02_current", file, package = "MATCHA")
      )
    ),
    tbl_name = tblname
  )

  expect_doppelganger(
    title = "tbl_tblART art_comb mirror plot_count_by_date",
    {
      plot_count_by_date(tbl_tblART, var = "art_sd", position = "mirror")
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_comb dodge plot_count_by_date",
    {
      plot_count_by_date(tbl_tblART, var = "art_sd", position = "dodge")
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_comb diff plot_count_by_date",
    {
      plot_count_by_date(tbl_tblART, var = "art_sd", position = "diff")
    }
  )
})
