#' MATCHA bslib theme
#'
#' @return the MATCHA bslib theme
#' @export
matcha_theme <- function() {
  bs_theme(
    bg = "white",
    fg = "#494544",
    primary = "maroon",
    secondary = "#494544",
    base_font = font_google("Hind", wght = c(400, 700)),
    heading_font = font_google("Montserrat", wght = c(700)),
    version = 5,
    spacer = "0.4rem"
  ) %>%
    # Rule to allow overflow in cards with dropdown menus
    bs_add_rules(
      list(
        ".card-dropdown {overflow: visible !important;}"
      )
    ) %>%
    bs_theme_update(
      success = "#54C9A4", info = "#25A9A5",
      warning = "#DB865C", danger = "#F08787"
    )
}

#' MATCHA reports bslib theme
#'
#' @return the MATCHA bslib theme adapted for reports
#' @export
matcha_report_theme <- function() {
  matcha_theme() %>%
    bs_theme_update(
      spacer = "0.6rem") %>%
    # Make each heading a fraction smaller than default for use in report. Each
    # heading should still be progressively smaller than the previous one.
    bs_add_variables(
      "h1-font-size" = "1.75rem",
      "h2-font-size" = "1.5rem",
      "h3-font-size" = "1.25rem",
      "h4-font-size" = "1.15rem",
      "h5-font-size" = "1.05rem",
      "h6-font-size" = "1rem"
    )

}
