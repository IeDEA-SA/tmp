plot_interactive <- function(p, interactive = TRUE) {
  if (interactive) {
    return(plotly::ggplotly(p))
  }
  p
}

make_uuid <- function(prefix = "plt") {
  checkmate::assert_string(prefix, null.ok = TRUE)
  ifelse(is.null(prefix),
    digest::digest(uuid::UUIDgenerate(), "xxhash32"),
    paste(prefix, digest::digest(uuid::UUIDgenerate(), "xxhash32"), sep = "_")
  )
}
