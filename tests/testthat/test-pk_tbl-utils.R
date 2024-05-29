test_that("subset_pk_tbl_cols works", {
  tblBAS <- load_comb_tbl("tblBAS")
  pk_tbl <- subset_pk_tbl_cols(tblBAS, add_pk_col = TRUE)
  expect_false(any(is.na(pk_tbl$pk)))
  expect_snapshot(pk_tbl)

  pk_tbl_nopk <- subset_pk_tbl_cols(tblBAS)
  expect_snapshot(pk_tbl_nopk)
})

test_that("join_pk works", {
  tblBAS <- load_comb_tbl("tblBAS")
  pk_tbl <- subset_pk_tbl_cols(tblBAS, add_pk_col = TRUE)

  tbl <- load_comb_tbl("tblART")
  rm_ids <- tbl$patient %>%
    unique() %>%
    head()
  tbl <- dplyr::filter(tbl, !patient %in% rm_ids)

  joined <- join_pk(tbl, pk_tbl)
  expect_true(any(is.na(joined$patient)))
  expect_snapshot(joined)
})
