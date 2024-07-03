test_that("get_date_ceiling works", {
  tblBAS <- load_comb_tbl("tblBAS")
  expect_equal(get_date_ceiling(tblBAS, "birth_d", "year"), "2011-01-01")
  # Include vars with NAs
  expect_equal(get_date_ceiling(tblBAS, "hiv_pos_d", "day"), "2018-07-16")
  expect_equal(get_date_ceiling(tblBAS, "hiv_pos_d", "year"), "2018-07-16")
})
