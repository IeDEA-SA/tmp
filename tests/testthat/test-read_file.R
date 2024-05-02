test_that("read_file works", {
  expect_snapshot(
    read_file(
      system.file("test-data", "stata", "01_previous", "tblART.dta",
        package = "MATCHA"
      )
    )
  )
  expect_snapshot(
    read_file(
      system.file("test-data", "csv", "01_previous", "tblART.csv",
        package = "MATCHA"
      )
    )
  )
})
