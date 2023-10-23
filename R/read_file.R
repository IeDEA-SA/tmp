read_file <- function(path, label) {
    extension <- fs::path_ext(path)
    tbl <- switch (extension,
        csv = readr::read_csv(file = path),
        rds = readRDS(file = path),
        dta = haven::read_dta(file = path),
        sav = haven::read_sav(file = path),
        por = haven::read_por(file = path),
        sas7bdat = haven::read_sas(data_file = path),
        sas7bcat = haven::read_sas(data_file = path)
    )

    tbl$tbl_name <- label

    tibble::as_tibble(tbl)
}
