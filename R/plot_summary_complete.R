#' Study Subject Data Completeness.
#'
#' @param pk  List containing tibble of primary key information for each table loaded.
#' Usually stored in userData$pk.
#' @param pk_col  Column name of primary key in each table. Default is "patient".
#' @return Primary key completeness ggplot bar plot.
#' @importFrom ggplot2 ggplot aes geom_bar labs theme facet_grid element_blank
#' @importFrom dplyr full_join group_by summarise_all select mutate all_of
#' @export
plot_summary_complete <- function(pk, pk_col = "patient") {
  # Inner join all tables on pk
  purrr::imap(
    pk,
    function(x, idx) {
      names(x)[names(x) == pk_col] <- idx
      return(x)
    }
  ) %>%
    purrr::reduce(
      function(x, y) {
        full_join(x, y, by = c("tbl", "pk"))
      }
    ) %>%
    select(-"pk") %>%
    group_by(.data[["tbl"]]) %>%
    # Calculate percentage pk completeness for each table group by current/previous
    summarise_all(
      list(~ (length(.) - sum(is.na(.))) / length(.) * 100)
    ) %>%
    tidyr::gather(key = "tbl_name", value = "complete", -"tbl") %>%
    # Order factor levels by frequency so most complete table (pk_tbl) will appear at the top
    # of the plot
    mutate(
      tbl_name = forcats::fct_infreq(
        .data[["tbl_name"]],
        w = .data[["complete"]]
      ) %>%
        forcats::fct_rev()
    ) %>%
    # Plot missing values.
    # Remove legend for tbl_name
    ggplot(aes(y = .data[["tbl_name"]],
               x = .data[["complete"]],
               fill = .data[["tbl_name"]])) +
    geom_bar(stat = "identity") +
    theme(axis.title.y = element_blank()) +
    facet_grid(~tbl) +
    labs(title = "Study Subject Data Completeness by table",
         x = "% Completeness") +
    theme(legend.position = "none")
}
