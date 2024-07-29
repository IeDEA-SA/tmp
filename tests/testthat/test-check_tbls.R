test_that("check tables functions work when invalid var present", {
  x <- list(
    previous = read_file(testthat::test_path("testdata/coltype-error/pre/tblBAS.dta")),
    current = read_file(testthat::test_path("testdata/coltype-error/cur/tblBAS.dta"))
  )
  names_checks <- check_tbl_names(x)
  expect_snapshot(names_checks)

  x <- process_tbl(x,
    clean_names = names_checks$clean_names,
    select_vars = names_checks$valid_cols
  )

  expect_snapshot(str(x))

  colytpes_check <- check_tbl_coltypes(x)
  expect_snapshot(colytpes_check)
})


test_that("check tables functions work when all valid vars present", {
  x_valid <- list(
    previous = read_file(system.file("test-data/csv/01_previous/tblBAS.csv", package = "MATCHA")),
    current = read_file(system.file("test-data/csv/02_current/tblBAS.csv", package = "MATCHA"))
  )
  names_checks_all_valid <- check_tbl_names(x_valid)
  expect_snapshot(names_checks_all_valid)

  x_valid <- process_tbl(x_valid,
    clean_names = names_checks_all_valid$clean_names,
    select_vars = names_checks_all_valid$valid_cols
  )

  expect_snapshot(str(x_valid))

  colytpes_check_all_valid <- check_tbl_coltypes(x_valid)
  expect_snapshot(colytpes_check_all_valid)
})
