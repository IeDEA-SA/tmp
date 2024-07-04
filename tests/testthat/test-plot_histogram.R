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
      plot_histogram(tbl_tblART, x = "art_comb", position = "mirror")
    }
  )

  expect_doppelganger(
    title = "tbl_tblART art_comb dodge histogram",
    {
      plot_histogram(tbl_tblART, x = "art_comb", position = "dodge")
    }
  )


  expect_doppelganger(
    title = "tbl_tblART art_rs NAs histogram",
    {
      plot_histogram(tbl_tblART, x = "art_rs", position = "dodge")
    }
  )
})

test_that("plot_histogram log works", {

  tblLAB <- load_comb_tbl("tblLAB")
  expect_doppelganger(
    title = "tblLAB lab_v no-log histogram",
    {
      plot_histogram(tblLAB, x = "lab_v")
    }
  )
  expect_doppelganger(
    title = "tblLAB lab_v log histogram",
    {
      plot_histogram(tblLAB, x = "lab_v", log = TRUE)
    }
  )

  tblLAB_CD4 <- load_comb_tbl("tblLAB_CD4")
  expect_doppelganger(
    title = "tblLAB_CD4 cd4_v log histogram",
    {
      plot_histogram(tblLAB_CD4, x = "cd4_v", log = TRUE)
    }
  )
})
