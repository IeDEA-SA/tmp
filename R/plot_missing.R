#' Create bar plot of missing value (NA) counts across variables in a tbl
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param pk_tbl Tibble of primary key information. Usually stored in userData$pk_tbl.
#' @param exclude Columns to exclude from plot.
#' @importFrom ggplot2 ggplot aes geom_bar labs ylab
#' @return Missing value ggplot bar plot.
#' @export
plot_missing <- function(tbl, pk_tbl, exclude = NULL) {
  exclude <- c("tbl_name", exclude)
  join_pk(tbl, pk_tbl) %>%
    dplyr::select(-dplyr::any_of(exclude)) %>%
    dplyr::group_by(tbl) %>%
    naniar::miss_var_summary() %>%
    ggplot(
      aes(
        y = .data[["variable"]],
        x = .data[["pct_miss"]],
        fill = .data[["tbl"]]
      )
    ) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(
      title = "Missingness by Table",
      x = "Percent Missing",
      y = "Variable"
    )
}
