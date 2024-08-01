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
    base_font = font_google("Poppins", wght = c(400, 700)),
    heading_font = font_google("Alfa Slab One"),
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
