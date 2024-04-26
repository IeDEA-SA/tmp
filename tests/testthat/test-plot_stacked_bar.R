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
    title = "tbl_tblART art_id std stacked bar plot",
    {
      plot_stacked_bar(tbl_tblART, x = "art_id")
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_id stacked bar plot top 4",
    {
      plot_stacked_bar(tbl_tblART, x = "art_id", n = 4)
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_id stacked bar plot top 4 factors",
    {
      tbl_tblART %>%
        dplyr::mutate(art_id = as.factor(.data[["art_id"]])) %>%
      plot_stacked_bar(x = "art_id", n = 4)
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_id count stacked bar plot",
    {
      plot_stacked_bar(tbl_tblART, x = "art_id", position = "stack")
    }
  )
})
