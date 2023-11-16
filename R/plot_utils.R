plot_interactive <- function(p, interactive = TRUE) {
    if (interactive) {
        return(plotly::ggplotly(p))
    }
    p
}
