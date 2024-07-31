load_comb_tbl <- function(tblname, ext = "dta", test_dir = "stata") {
  file <- fs::path(tblname, ext = ext)

  combine_tbls(
    previous_tbl = suppressWarnings(
      read_file(
        system.file("test-data", test_dir, "01_previous", file, package = "MATCHA")
      )
    ),
    current_tbl = suppressWarnings(
      read_file(
        system.file("test-data", test_dir, "02_current", file, package = "MATCHA")
      )
    ),
    tbl_name = tblname
  )
}

load_comb_testdata_tbl <- function(tblname = "tblBAS", ext = "dta",
                                   test_dir = "no-vtype") {
  file <- fs::path(tblname, ext = ext)

  combine_tbls(
    previous_tbl = suppressWarnings(
      read_file(
        testthat::test_path("testdata", test_dir, "pre", file)
      )
    ),
    current_tbl = suppressWarnings(
      read_file(
        testthat::test_path("testdata", test_dir, "cur", file)
      )
    ),
    tbl_name = tblname
  )
}
