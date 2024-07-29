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
