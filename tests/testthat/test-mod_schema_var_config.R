test_that("Variable config inputs captured correctly", {
  testServer(mod_schema_var_config_server, {
    var_type <- "date"
    unknown <- "99"
    session$setInputs(var_type = var_type, unknown = unknown)

    res <- var_config()

    expect_equal(res, list(var_type = "date", unknown = "99"))
  })
})

test_that("mod_schema_var_config_ui config creates expected HTML", {
  expect_snapshot(mod_schema_var_config_ui("x", "test_var", "numeric"))
})
