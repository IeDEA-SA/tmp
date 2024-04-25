library(vdiffr)

test_that("plot_cat_count_by_year works", {
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
    title = "tbl_tblART std",
    {
      plot_cat_count_by_year(tbl_tblART, date_col = "art_sd", y = "art_id")
    }
  )

  expect_doppelganger(
    title = "tbl_tblART n=6",
    {
      plot_cat_count_by_year(tbl_tblART,
        date_col = "art_sd", y = "art_id",
        n = 6
      )
    }
  )
  expect_doppelganger(
    title = "tbl_tblART mark_cutoff=TRUE",
    {
      plot_cat_count_by_year(tbl_tblART,
        date_col = "art_sd", y = "art_id",
        mark_cutoff = FALSE
      )
    }
  )
})
