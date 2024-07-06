plot_interactive <- function(p, interactive = TRUE) {
  if (interactive) {
    return(plotly::ggplotly(p))
  }
  p
}

make_uuid <- function(prefix = "plt") {
  checkmate::assert_string(prefix, null.ok = TRUE)
  uuid <- sample(c(letters, 0:9), 8, replace = TRUE) %>%
    paste0(collapse = "")
  ifelse(is.null(prefix),
    uuid,
    paste(prefix, uuid, sep = "_")
  )
}
