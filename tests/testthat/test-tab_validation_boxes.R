test_that("tab-validation-boxes works", {
  expect_snapshot(
    tab_validation_boxes(c("var1", "var2"), NULL, integer(0))
  )
})
