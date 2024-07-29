init_app_driver <- function(...) {
  app_driver <- shinytest2::AppDriver
  app_driver$set("public", "run_js_delay", function(js_string, sys_sleep = 1) {
    self$run_js(js_string)
    Sys.sleep(sys_sleep)
  }, overwrite = TRUE)

  app_driver$new(run_app(), ...)
}

get_html_classes <- function(html) {
  html %>%
    xml2::read_html() %>%
    xml2::xml_find_all(".//div") %>%
    xml2::xml_attr("class")
}
