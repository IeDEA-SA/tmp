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
  app$run_js_delay("$('.sF-content').find('.sF-expander').first().find('.glyphicon-triangle-right').click()")
  app$run_js_delay("$('.sF-file-name').find('div:contains(\\\"01_previous\\\")').first().click()")
  app$run_js_delay("$('#sF-selectButton').click()")

  expect_match(
    app$get_value(output = "access_prev_dat-folder_path"),
    "test-data/csv/01_previous"
  )
})

test_that("{shinytest2} SET_CURRENT_PATH", {
  app$run_js_delay("$('#access_curr_dat-folder').click()")
  app$run_js_delay("$('.sF-content').find('.sF-expander').first().find('.glyphicon-triangle-right').click()")
  app$run_js_delay("$('.sF-file-name').find('div:contains(\\\"02_current\\\")').first().click()")
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
  app$expect_download("download-report", compare = testthat::compare_file_text)
})

test_that("{shinytest2} READ_TABLES", {
  app$set_inputs(`select_tbls-tables` = c("tblBAS", "tblART"), wait_ = FALSE)
  app$click("read_tbls-readBtn")

  app$expect_values(screenshot_args = FALSE)
})

test_that("{shinytest2} READ_TABLES", {
  app$set_inputs(`select_tbls-tables` = c("tblBAS", "tblART"), wait_ = FALSE)
  app$click("read_tbls-readBtn")

  app$expect_values(screenshot_args = FALSE)
  expect_equal(
    app$get_value(input = "tbl_tab-tab"),
    "tbl_tab-tblBAS_4oncnyz0e01i28hz"
  )
})

test_that("{shinytest2} GENERATE_PLOT", {
  app$run_js_delay("$('#tbl_tab-tblBAS_4oncnyz0e01i28hz-add_plot').click()")
  app$run_js_delay("$('#tbl_tab-tblBAS_4oncnyz0e01i28hz-plt_yw83l438n25gcwou-ok').click()", 2)

  expect_snapshot(app$get_value(output = "tbl_tab-tblBAS_4oncnyz0e01i28hz-valid_cols"))
})

test_that("{shinytest2} GET_PLOT_REPORT", {
  report_file <- app$get_download("download-report")
  html_obj <- xml2::read_html(report_file)

  expect_snapshot(xml2::xml_find_all(html_obj, ".//div"))
})
