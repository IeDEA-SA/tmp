get_test_combined_data <- function() {
  tblname <- "tblVIS"
  ext <- "csv"
  test_dir <- "csv"
  file <- fs::path(tblname, ext = ext)
  set.seed(1)

  combine_tbls(
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
}

