# Begin tests
test_that("var_type_fn returns the correct function for each var_type code", {
  expect_true(var_type_fn("numeric")(42))
  expect_false(var_type_fn("numeric")("42"))

  expect_true(var_type_fn("integer")(42L))
  expect_false(var_type_fn("integer")(42.1))

  expect_true(var_type_fn("double")(42.1))
  expect_false(var_type_fn("double")(42L))

  expect_true(var_type_fn("Date")(as.Date("2021-01-01")))
  expect_false(var_type_fn("Date")("2021-01-01"))

  expect_true(var_type_fn("character")("test"))
  expect_false(var_type_fn("character")(42))

  expect_true(var_type_fn("factor")(factor("test")))
  expect_false(var_type_fn("factor")("test"))

  expect_true(var_type_fn("character_or_factor")("test"))
  expect_true(var_type_fn("character_or_factor")(factor("test")))
  expect_false(var_type_fn("character_or_factor")(42))

  expect_true(var_type_fn("character_or_factor_or_integer")("test"))
  expect_true(var_type_fn("character_or_factor_or_integer")(factor("test")))
  expect_true(var_type_fn("character_or_factor_or_integer")(42L))
  expect_false(var_type_fn("character_or_factor_or_integer")(42.1))

  expect_true(var_type_fn("all")("anything"))
  expect_true(var_type_fn("all")(42))
  expect_true(var_type_fn("all")(factor("test")))
  expect_true(var_type_fn("all")(as.Date("2021-01-01")))
  expect_true(var_type_fn("all")(NULL))
})

test_that("get_arg_choices returns the correct column options", {
  tblBAS <- load_comb_tbl("tblBAS")
  tblDIS <- load_comb_tbl("tblDIS")

  expect_equal(
    get_arg_choices(
      arg_type = "Date",
      comb_tbl = function(x = tblBAS) {
        return(x)
      }
    ),
    c("birth_d", "enrol_d", "recart_d", "aids_d", "hiv_pos_d")
  )
  expect_equal(
    get_arg_choices(
      arg_type = "character_or_factor_or_integer",
      comb_tbl = function(x = tblBAS) {
        return(x)
      }
    ),
    c("patient", "program", "enrol_d_a", "recart_d_a", "aids_d_a",
      "hiv_pos_d_a")
  )
  # Check that all NA columns (i.e. dis_ed) are excluded as options
  expect_equal(
    get_arg_choices(
      arg_type = "Date",
      comb_tbl = function(x = tblDIS) {
        return(x)
      }
    ),
    "dis_d"
  )
})
