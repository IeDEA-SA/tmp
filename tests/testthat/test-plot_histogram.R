library(vdiffr)

test_that("plot_histogram works", {
  tblname <- "tblART"
  ext <- "csv"
  test_dir <- "csv"
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
    title = "tbl_tblART art_comb mirror histogram",
    {
      plot_histogram(tbl_tblART, var = "art_comb", position = "mirror")
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_comb dodge histogram",
    {
      plot_histogram(tbl_tblART, var = "art_comb", position = "dodge")
    }
  )
})
