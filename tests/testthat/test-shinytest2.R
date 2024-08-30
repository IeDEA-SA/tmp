library(shinytest2)

# Initialise app
app <- init_app_driver(
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
  # Select demo_data/csv/01_previous folder as previous data folder
  app$run_js_delay("$('#access_prev_dat-folder').click()")
  app$run_js_delay("
  var dropdown = document.querySelector('.sF-breadcrumps');
  var options = dropdown.options;
  for (var i = 0; i < options.length; i++) {
    if (options[i].text === 'demo_data') {
      dropdown.selectedIndex = i;
      dropdown.dispatchEvent(new Event('change'));
      break;
    }
  }
")

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

  # Check that selected folder matches the expected path
  expect_match(
    app$get_value(output = "access_prev_dat-folder_path"),
    "test-data/csv/01_previous"
  )
})

test_that("{shinytest2} SET_CURRENT_PATH", {
  # Select demo_data/csv/02_current folder as current data folder
  app$run_js_delay("$('#access_curr_dat-folder').click()")
  app$run_js_delay("
  var dropdown = document.querySelector('.sF-breadcrumps');
  var options = dropdown.options;
  for (var i = 0; i < options.length; i++) {
    if (options[i].text === 'demo_data') {
      dropdown.selectedIndex = i;
      dropdown.dispatchEvent(new Event('change'));
      break;
    }
  }
")

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

  # Check both folders match the expected paths
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
  # Create a blank HTML report
  report_file <- app$get_download("download-report")

  all_classes <- get_html_classes(report_file)

  expect_snapshot(all_classes)
})

test_that("{shinytest2} READ_TABLES", {
  # Load tblBAS and tblART tables
  app$set_inputs(`select_tbls-tables` = c("tblBAS", "tblART"), wait_ = FALSE)
  app$click("read_tbls-readBtn")
  # Navigate to first tab (tblBAS)
  app$run_js_delay("$('#tbl_tab-tab').find('a').first().click()")

  # Check the output of the valid columns check
  valid_cols <- app$get_value(
    output = "tbl_tab-tblBAS_4oncnyz0-valid_cols"
  )$html
  expect_snapshot(valid_cols)

  # Check the name of the first table (including the unique identifier used to
  # keep track of unique instances of tables from table metadata)
  expect_equal(
    app$get_value(input = "tbl_tab-tab"),
    "tbl_tab-tblBAS_4oncnyz0"
  )
})

test_that("{shinytest2} GENERATE_PLOT", {
  # Add a plot to the tblBAS table
  app$run_js_delay("$('#tbl_tab-tblBAS_4oncnyz0-add_plot').click()")
  app$run_js_delay(
    "$('.modal-footer').find('button:contains(\\\"OK\\\")').click()",
    sys_sleep = 2
  )

  # Check plot card against expectations
  plot_class <- app$get_value(
    output = "tbl_tab-tblBAS_4oncnyz0-plt_gis9nqlo-card-plot"
  ) %>%
    purrr::chuck("html") %>%
    get_html_classes()

  expect_snapshot(plot_class)
})

test_that("{shinytest2} GET_PLOT_REPORT", {
  # Generate a report with the plot
  report_file <- app$get_download("download-report")

  all_classes <- get_html_classes(report_file)

  expect_snapshot(all_classes)
})

test_that("{shinytest2} SUMMARY_TAB", {
  # Navigate to the summary tab
  app$run_js_delay("$('#tbl_tab-tab').find('[data-value=tbl_tab-summary]').click()")
  # Add plot to the summary tab
  app$run_js_delay("$('#tbl_tab-summary-add_plot').click()")

  selected_summary_plot <- app$get_value(
    input = "tbl_tab-summary-plt_5gijw0g0-select_plot"
  )
  # Check the selected plot against expectations
  expect_snapshot(selected_summary_plot)
})
