#' MATCHA bslib theme
#'
#' @return the MATCHA bslib theme
#' @export
matcha_theme <- function() {
  bs_theme(
  bg = "white",
  fg = "#494544",
  primary = "maroon",
  base_font = font_google("Montserrat"),
  version = 5
) %>%
  # Rule to allow overflow in cards with dropdown menus
  bs_add_rules(".card-dropdown {overflow: visible !important;}")
}
