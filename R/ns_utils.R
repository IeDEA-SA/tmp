get_ns_tbl_name <- function(ns) {
  stringr::str_remove(
    get_ns_tab_id(ns),
    "_(?:.(?!_))+$"
  )
}

get_ns_plot_id <- function(ns) {
  strsplit(ns(NULL), ns.sep)[[1]][3]
}

get_ns_tab_id <- function(ns) {
  strsplit(ns(NULL), ns.sep)[[1]][2]
}
