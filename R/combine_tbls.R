combine_tbls <- function(current_path, previous_path) {
    curr_tbl <- read_file(current_path, label = "current")
    prev_tbl <- read_file(previous_path, label = "previous")

    shared_cols <- intersect(names(curr_tbl), names(prev_tbl))

    stopifnot(length(shared_cols) == 0L)

    cbind(curr_tbl[, shared_cols], prev_tbl[, shared_cols])
}
