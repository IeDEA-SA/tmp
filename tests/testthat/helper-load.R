load_comb_tbl <- function(tblname, ext = "dta", test_dir = "stata") {

  file <- fs::path(tblname, ext = ext)

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
