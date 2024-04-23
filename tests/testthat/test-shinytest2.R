library(shinytest2)

test_that("{shinytest2} recording: MATCHA_INIT", {
  shiny_app <- MATCHA::run_app()
  app <- AppDriver$new(shiny_app, variant = platform_variant(), name = "MATCHA_INIT", height = 899,
                       width = 609)
  app$expect_screenshot()
})
