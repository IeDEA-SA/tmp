test_that("check tables functions work when invalid var present", {

  x <- list(
    previous = read_file(testthat::test_path('testdata/coltype-error/pre/tblBAS.dta')),
    current = read_file(testthat::test_path('testdata/coltype-error/cur/tblBAS.dta'))
  )
  names_checks <- check_tbl_names(x)
  expect_snapshot(names_checks)

  x <- process_tbl(x, clean_names = names_checks$clean_names,
                   select_vars = names_checks$valid_cols)

  expect_snapshot(str(x))

  colytpes_check <- check_tbl_coltypes(x)
  expect_snapshot(colytpes_check)
})

