library(shinytest2)

app_driver <- AppDriver
app_driver$set("public", "run_js_delay", function(js_string, sys_sleep = 1) {
  self$run_js(js_string)
  Sys.sleep(sys_sleep)
}, overwrite = TRUE)

app <- app_driver$new(
  MATCHA::run_app(),
  variant = FALSE,
  name = "MATCHA_INIT",
  height = 899,
  width = 609,
  seed = 123
)

test_that("{shinytest2} recording: MATCHA_INIT", {
  app$expect_values(screenshot_args = FALSE)
})

test_that("{shinytest2} SET_PREVIOUS_PATH", {
  app$run_js_delay("$('#access_prev_dat-folder').click()")
  app$run_js_delay("
    $('.sF-content')
      .find('.sF-expander')
      .first()
      .find('.glyphicon-triangle-right')
      .click()
  ")
  app$run_js_delay("
    $('.sF-file-name')
      .find('div:contains(\\\"01_previous\\\")')
      .first()
      .click()
  ")
  app$run_js_delay("$('#sF-selectButton').click()")

  expect_match(
    app$get_value(output = "access_prev_dat-folder_path"),
    "test-data/csv/01_previous"
  )
})

test_that("{shinytest2} SET_CURRENT_PATH", {
  app$run_js_delay("$('#access_curr_dat-folder').click()")
  app$run_js_delay("
    $('.sF-content')
      .find('.sF-expander')
      .first()
      .find('.glyphicon-triangle-right')
      .click()
  ")
  app$run_js_delay("
    $('.sF-file-name')
      .find('div:contains(\\\"02_current\\\")')
      .first()
      .click()
  ")
  app$run_js_delay("$('#sF-selectButton').click()")

  expect_match(
    app$get_value(output = "access_prev_dat-folder_path"),
    "test-data/csv/01_previous"
  )
  expect_match(
    app$get_value(output = "access_curr_dat-folder_path"),
    "test-data/csv/02_current"
  )
})

test_that("{shinytest2} GET_VANILLA_REPORT", {
  report_file <- app$get_download("download-report")

  all_classes <- report_file %>%
    xml2::read_html() %>%
    xml2::xml_find_all(".//div") %>%
    xml2::xml_attr("class")

  expect_snapshot(all_classes)
})

test_that("{shinytest2} READ_TABLES", {
  app$set_inputs(`select_tbls-tables` = c("tblBAS", "tblART"), wait_ = FALSE)
  app$click("read_tbls-readBtn")
  app$run_js_delay("$('#tbl_tab-tab').find('a').first().click()")

  valid_cols <- app$get_value(
    output = "tbl_tab-tblBAS_4oncnyz0e01i28hz-valid_cols"
  )
  expect_snapshot(valid_cols)

  expect_equal(
    app$get_value(input = "tbl_tab-tab"),
    "tbl_tab-tblBAS_4oncnyz0e01i28hz"
  )
})

test_that("{shinytest2} GENERATE_PLOT", {
  app$run_js_delay("$('#tbl_tab-tblBAS_4oncnyz0e01i28hz-add_plot').click()")
  app$run_js_delay(
    "$('.modal-footer').find('button:contains(\\\"OK\\\")').click()",
    sys_sleep = 2
  )

  plot_class <- app$get_value(
    output = "tbl_tab-tblBAS_4oncnyz0e01i28hz-plt_5y72ehlmr60yuoz4-card-plot"
  ) %>%
    purrr::chuck("html") %>%
    xml2::read_html() %>%
    xml2::xml_find_all(".//div") %>%
    xml2::xml_attr("class")

  expect_snapshot(plot_class)
})

test_that("{shinytest2} GET_PLOT_REPORT", {
  report_file <- app$get_download("download-report")

  all_classes <- report_file %>%
    xml2::read_html() %>%
    xml2::xml_find_all(".//div") %>%
    xml2::xml_attr("class")

  expect_snapshot(all_classes)
})
