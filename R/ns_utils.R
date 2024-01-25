get_ns_tbl_name <- function(ns) {
    strsplit(ns(NULL), ns.sep)[[1]][2]
}

get_ns_plot_id <- function(ns) {
    strsplit(ns(NULL), ns.sep)[[1]][3]
}
