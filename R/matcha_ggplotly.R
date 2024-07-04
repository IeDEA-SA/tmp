#' Render a ggplot object as a plotly object with a caption and modified tooltip
#'
#' @param p a ggplot plot object
#'
#' @return a ggplotly object with a caption and modified tooltip where appropriate
#' @export
matcha_ggplotly <- function(p) {
  if ("text" %in% names(p$labels)) {
    tooltip <- c("x", "text", "fill")
  } else {
    tooltip <- c("x", "y", "fill")
  }
  pltly <- plotly::ggplotly(p, tooltip = tooltip)

  if (!is.null(p$labels$caption)) {
    plotly::layout(pltly,
      margin = list(l = 50, r = 50, b = 100, t = 50),
      annotations =
        list(
          x = 1, y = -0.3, text = p$labels$caption,
          showarrow = F, xref = "paper", yref = "paper",
          xanchor = "right", yanchor = "auto", xshift = 0, yshift = 0,
          font = list(size = 11, color = "red")
        )
    )
  } else {
    pltly
  }
}
