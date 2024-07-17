library(vdiffr)

test_that("plot_boxplot works", {
  tblname <- "tblVIS"
  ext <- "csv"
  test_dir <- "csv"
  file <- fs::path(tblname, ext = ext)
  set.seed(1)

  tbl <- combine_tbls(
    previous = suppressWarnings(
      read_file(
        system.file("test-data", test_dir, "01_previous", file, package = "MATCHA")
      )
    ),
    current = suppressWarnings(
      read_file(
        system.file("test-data", test_dir, "02_current", file, package = "MATCHA")
      )
    ),
    tbl_name = tblname
  )

  tbl[tbl == 999] <- NA

  expect_doppelganger(
    title = "plot_boxplot plain",
    plot_boxplot(tbl = tbl, x = "weigh", log = FALSE)
  )

  expect_doppelganger(
    title = "plot_boxplot no outliers",
    plot_boxplot(tbl = tbl, x = "weigh", show_outliers = FALSE)
  )

  expect_doppelganger(
    title = "plot_boxplot log",
    plot_boxplot(tbl = tbl, x = "weigh", log = TRUE)
  )

  expect_doppelganger(
    title = "plot_boxplot full",
    plot_boxplot(
      tbl = tbl, x = "weigh", include_violin = TRUE,
      include_points = TRUE
    )
  )

  # Check ggplotly
  pltly_no_outl <- plot_boxplot(tbl = tbl, x = "weigh", show_outliers = FALSE) %>%
    matcha_ggplotly()
  expect_snapshot(
    purrr::map(pltly_no_outl$x$data, ~ .x$marker)
  )


  pltly_outl <- plot_boxplot(tbl = tbl, x = "weigh", show_outliers = TRUE) %>%
    matcha_ggplotly()
  expect_snapshot(
    purrr::map(pltly_outl$x$data, ~ .x$marker)
  )


  pltly_full <- plot_boxplot(
    tbl = tbl, x = "weigh", include_violin = TRUE,
    include_points = TRUE
  ) %>%
    matcha_ggplotly()
  expect_snapshot(str(pltly_full$x$data))
})
