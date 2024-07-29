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
  if (p$labels$fill == p$labels$y) {
    tooltip <- c("x", "fill")
  }
  # Used to correct the tooltip for the event by year plot
  if (isTRUE(grepl("event[1:2]", p$labels$text))) {
    tooltip <- c("fill", "text")
  }
  pltly <- plotly::ggplotly(p, tooltip = tooltip)

  # Multiple overrides required to get the plotly object to look like the ggplot object for
  # boxplots. Solutions derived from https://github.com/plotly/plotly.R/issues/1114
  # 1. Change the color of the boxplot outliers to match the ggplot object
  if (any(is_boxplot(p))) {
    pltly$x$data <- lapply(pltly$x$data, FUN = function(x) {
      if (x$type != "box") {
        return(x)
      }
      x$marker$outliercolor <- x$line$color # When creating plot p with ggplot if you specify fill = cut use x$fill$color instead of $line$color
      x$marker$color <- x$line$color # When creating plot p with ggplot if you specify fill = cut use x$fill$color instead $line$color
      x$marker$line <- x$line$color # When creating plot p with ggplot if you specify fill = cut use x$fill$color instead $line$color
      return(x)
    })

    # 2. To remove the outliers from the plotly object, need to modify the plotly
    # object and make outlier points have opacity equal to 0
    if (!has_outliers(p)) {
      pltly$x$data <- lapply(pltly$x$data, FUN = function(x) {
        if (x$type == "box") {
          x$marker <- list(opacity = 0)
        }
        return(x)
      })
    }
  }

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


is_boxplot <- function(p) {
  purrr::map_lgl(
    p$layers,
    ~ inherits(.x$geom, "GeomBoxplot")
  )
}

#' @importFrom ggplot2 ggplot_build
has_outliers <- function(p) {
  params <- ggplot_build(p)$data[[which(is_boxplot(p))]] %>%
    names() %>%
    suppressWarnings()

  "outliers" %in% params
}
