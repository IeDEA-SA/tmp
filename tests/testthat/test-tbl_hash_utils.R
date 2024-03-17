test_that("get_tbl_hash_lookup correctly processes input list", {
  tbls <- list(
    tbl_pair1 = list(
      previous = iris,
      current = mtcars
    ) %>%
      structure(source_hash = "hash1")
  )
  result <- get_tbl_hash_lookup(tbls)
  expect_equal(result, c("hash1" = "tbl_pair1"))
})

test_that("Error when 'tbl_list' and 'source_files' lengths do not match", {
  df1 <- data.frame(x = 1:10)
  tbl_list <- list(df1)
  source_files <- c("file1.txt", "file2.txt")

  expect_error(set_source_hash(tbl_list, source_files),
               "'source_files' length not match")
})

test_that("'source_hash' attribute is correctly assigned", {
  withr::with_tempdir({
    source_files <- c("file1.txt", "file3.txt")
    write.csv(iris, source_files[1])
    write.csv(mtcars, source_files[2])
    tbl_list <- list(iris, mtcars)

    result <- set_source_hash(tbl_list, source_files)

    expect_true(!is.null(attr(result, "source_hash")))
  })
})
