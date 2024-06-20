#' Read a data file.
#'
#' Accepted file extensions include `csv`, `rds`, `dta`, `sav`, `por`, `sas7bdat`
#' and `sas7bcat`.
#' @param path path to the file.
#' @noRd
#'
#' @return a tibble
read_file <- function(path) {
  extension <- fs::path_ext(path)
  tbl <- switch(extension,
    csv = data.table::fread(path) %>% convert_IDate(),
    rds = readRDS(file = path),
    dta = haven::read_dta(file = path),
    sav = haven::read_sav(file = path),
    por = haven::read_por(file = path),
    sas7bdat = haven::read_sas(data_file = path),
    sas7bcat = haven::read_sas(data_file = path),
    validate(
      glue::glue(
        "{basename(path)} is invalid file; Please select a file with appropriate extension."
      )
    )
  )

  readr::type_convert(tbl, guess_integer = TRUE) %>%
    suppressMessages() %>%
    tibble::as_tibble()
}

convert_IDate <- function(tbl) {
  for (var in names(tbl)) {
    if (inherits(tbl[[var]], "IDate")){
      tbl[, var] <- as.Date(tbl[[var]])
    }
  }
  tbl
}
