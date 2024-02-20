var_plot_types <- function(var_nm, tbl) {
  var_class <- class(tbl[[var_nm]])
  var_type <- typeof(tbl[[var_nm]])

  if (var_class == "Date") {
    plots <- c("plot_count_by_date")
    return(plots)
  }
  if (var_class == "numeric") {
    plots <- c("plot_histogram")
    return(plots)
  }
  if (var_class %in% c("character", "factor", "logical")) {
    plots <- c()
    return(plots)
  }
}
