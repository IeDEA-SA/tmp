test_that("get_tbl_tabs_lookup correctly processes input list", {
  tbls <- list(
    tbl_pair1 = list(
      previous = iris,
      current = mtcars
    ) %>%
      structure(source_hash = "hash1")
  )
  existing_tbl_tabs_lookup <- tibble(
    source_hash = character(),
    tbl_name = character(),
    tab_id = character()
  )
  result <- get_tbl_tabs_lookup(tbls, existing_tbl_tabs_lookup)

  expect_s3_class(result, "tbl")
  expect_equal(names(result), c("source_hash", "tbl_name", "tab_id"))

  # it does not recalculate existing tab ids
  existing_tbl_tabs_lookup <- tibble(
    source_hash = "hash1",
    tbl_name = "tbl_pair1",
    tab_id = "foo_123"
  )
  result <- get_tbl_tabs_lookup(tbls, existing_tbl_tabs_lookup)
  expect_equal(result$tab_id, "foo_123")
})

test_that("Error when 'tbl_list' and 'source_files' lengths do not match", {
  df1 <- data.frame(x = 1:10)
  tbl_list <- list(df1)
  source_files <- c("file1.txt", "file2.txt")

  expect_error(
    set_source_hash(tbl_list, source_files),
    "'source_files' length not match"
  )
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


test_that("'source_hash' attribute stays consistent when files are read by data.table", {
  path_1 <- system.file("test-data", "csv", "01_previous", "tblART.csv",
    package = "MATCHA"
  )
  path_2 <- system.file("test-data", "csv", "02_current", "tblART.csv",
    package = "MATCHA"
  )
  source_files <- c(path_1, path_2)

  # Create tbl list 1
  tbl_list <- list(
    data.table::fread(path_1),
    data.table::fread(path_2)
  )
  hash_1 <- attr(set_source_hash(tbl_list, source_files), "source_hash")

  # Reread tables and check that the same hash is generated
  tbl_list <- list(
    data.table::fread(path_1),
    data.table::fread(path_2)
  )
  hash_2 <- attr(set_source_hash(tbl_list, source_files), "source_hash")

  expect_equal(hash_1, hash_2)
})
