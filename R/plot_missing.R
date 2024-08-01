#' Missing Values plot
#'
#' @param tbl Combined table of previous and current data. Output of [combine_tbls()].
#' @param pk_tbl Tibble of primary key information. Usually stored in
#' `session$userData$pk[[session$userData$pk_tbl_name]]`.
#' @param exclude Columns to exclude from plot.
#' @param compare_pk Logical. Whether to compare table missing values to overall
#' primary key values.
#' @importFrom ggplot2 ggplot aes geom_bar labs scale_x_continuous
#' @return Missing value ggplot bar plot.
#' @export
plot_missing <- function(tbl, pk_tbl, exclude = NULL, compare_pk = FALSE,
                         tbl_pk_col = "patient") {
  exclude <- c("tbl_name", exclude)
  x_lab <- "% missing"
  if (compare_pk) {
    tbl <- join_pk(tbl, pk_tbl, pk_col = tbl_pk_col)
    x_lab <- paste(x_lab, "(compared to primary key)")
  }

  tbl %>%
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
    scale_x_continuous(limits = c(0, 100)) +
    labs(
      title = "Missingness across Table",
      x = x_lab,
      y = "Variable"
    )
}
