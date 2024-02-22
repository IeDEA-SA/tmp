# Function to remove inputs within to dynamically created table tabs.
# Function was adapted from code and discussions in the following links:
# - https://www.r-bloggers.com/2020/02/shiny-add-removing-modules-dynamically/
# - https://github.com/rstudio/shiny/issues/2374
remove_shiny_inputs <- function(id, .input, parent_id = "") {
  id <- gsub(parent_id, "", id)

  invisible(
    lapply(grep(id, names(.input), value = TRUE), function(i) {
      .subset2(.input, "impl")$.values$remove(i)
    })
  )
}


# https://appsilon.com/how-to-safely-remove-a-dynamic-shiny-module/
remove_shiny_outputs <- function(id, .output, parent_id = "") {
  delete_ui <- grep(id, names(outputOptions(.output)), value = TRUE)
  # delete_ui_id <- gsub(parent_id, "", delete_ui)

  purrr::walk(
    delete_ui,
    ~ {
      removeUI(
        selector = sprintf("div:has(> #%s)", .x),
        # selector = sprintf("#%s", .x),
        multiple = TRUE,
        immediate = TRUE
      )
    }
  )

  #
  #   purrr::walk(
  #     delete_ui_id,
  #     ~ {
  #     .output[[.x]] <- NULL
  #     }
  #   )
  #
  #   invisible(
  #     lapply(grep(id, names(.output), value = TRUE), function(i) {
  #       .subset2(.output, "impl")$.values$remove(i)
  #     })
  #   )
}
