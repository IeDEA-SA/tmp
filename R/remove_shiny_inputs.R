remove_shiny_inputs <- function(id, .input) {
  invisible(
    lapply(grep(id, names(.input), value = TRUE), function(i) {
      .subset2(.input, "impl")$.values$remove(i)
    })
  )
}


remove_shiny_outputs <- function(id, .output) {
  delete_ui <- grep(id, names(outputOptions(.output)), value = TRUE)
  print("Delete UI")
  print(id)
  print(delete_ui)

  purrr::walk(
    delete_ui,
    ~  removeUI(
      selector = sprintf("div:has(> #%s)", .x),
      multiple = TRUE
    )
  )

  print("After delete UIs")
  print(names(outputOptions(.output)))
}
