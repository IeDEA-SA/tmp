#' var_plot_modal UI Function
#'
#' @description Module for launching modal to configure new plot.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_var_plot_modal_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("plot_ui"))
  )
}

#' var_plot_modal Server Functions
#'
#' @param comb_tbl a reactive tbl_df object. The output of [`combine_tbls`:
#' - `previous`: a tibble of previous data
#' - `current`: a tibble of current data
#' to compare.
#' @noRd
mod_var_plot_modal_server <- function(id, comb_tbl) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    if (!is_summary_tab(ns) && isFALSE(is.reactive(comb_tbl))) {
      stop("Input must be a reactive expression.")
    }

    output$select_plot_ui <- renderUI({
      req(input$select_plot)
      if (!is.null(input$select_plot)) {
        output <- tagList()

        plot_name <- input$select_plot
        plot_args <- get_plot_arg_names(plot_name)
        if (length(plot_args) == 0L && !is_summary_tab(ns)) {
          shinyjs::enable(id = "ok")
        }
        if (is_summary_tab(ns)) {
          summary_valid <- validate_summary(session)
          if (summary_valid) {
            shinyjs::enable(id = "ok")
          }
          validate(
            need(
              summary_valid,
              glue::glue(
                "`pk_col` values across tables cannot be merged.
                Please check `pk_col` columns are valid and can be merged."
              )
            )
          )
        }
        plot_arg_ids <- create_arg_ids(plot_args)

        for (i in seq_along(plot_args)) {
          arg_name <- plot_args[i]
          arg_type <- get_plot_arg_type(plot_name, arg_name)
          id <- plot_arg_ids[i]
          arg_choices <- get_arg_choices(arg_type, comb_tbl)
          validate(
            need(
              length(arg_choices) > 0,
              glue::glue(
                "No valid variable of type `{arg_type}` to select for arg `{arg_name}`.
                Please select another plot type."
              )
            )
          )

          output[[i]] <- selectInput(ns(id),
            paste("Select", arg_name, "variable", "to compare"),
            choices = arg_choices,
            multiple = FALSE,
            selected = NULL,
            selectize = TRUE
          )
          validate_ok_button(input, plot_arg_ids)
        }
        output
      }
    })

    output$plot_ui <- renderUI({
      req(input$select_plot)
      if (!is.null(input$select_plot)) {
        plot_ui_mod <- get(paste("mod", input$select_plot, "ui", sep = "_"))
        plot_ui_mod(
          ns("card"),
          x = input$select_var_x,
          y = input$select_plot
        )
      }
    }) %>%
      bindEvent(input$ok)

    plotModal <- function() {
      choices <- names(plot_meta)
      names(choices) <- purrr::map_chr(plot_meta, ~ .x$label)
      if (is_summary_tab(ns)) {
        choices <- grep("summary", choices, value = TRUE)
      } else {
        choices <- grep("summary", choices, value = TRUE, invert = TRUE)
      }
      modalDialog(
        selectInput(ns("select_plot"),
          "Select plot type",
          choices = choices,
          multiple = FALSE,
          selectize = TRUE
        ),
        uiOutput(ns("select_plot_ui")),
        footer = tagList(
          modalButton("Cancel"),
          shinyjs::disabled(actionButton(ns("ok"), "OK"))
        )
      )
    }

    mod_observer <- observe(
      {
        showModal(plotModal())
      },
      label = ns("launch-modal-obs")
    )

    observeEvent(input$ok,
      {
        req(input$select_plot)
        if (!is.null(input$select_plot)) {
          plot_server_mod <- get(paste("mod",
            input$select_plot,
            "server",
            sep = "_"
          ))

          w <- add_waiter(msg = "Generating plot...")

          if (is_summary_tab(ns)) {
            plot_server_mod("card", comb_tbl,
              x = input$select_var_x,
              y = input$select_var_y
            )
          } else {
            plot_server_mod("card", comb_tbl(),
              x = input$select_var_x,
              y = input$select_var_y
            )
          }
        }
        mod_observer$destroy()
        removeModal()
      },
      label = ns("modal-ok-obs-event")
    )
  })
}

## To be copied in the UI
# mod_var_plot_modal_ui("var_plot_modal_1")

## To be copied in the server
# mod_var_plot_modal_server("var_plot_modal_1")


create_arg_ids <- function(args) {
  purrr::map_chr(
    args,
    ~ sprintf(
      "select_var_%s",
      .x
    )
  )
}

get_plot_args_values <- function(input, args) {
  purrr::map_chr(
    args,
    ~ input[[sprintf("select_var_%s", .x)]]
  )
}
get_plot_arg_names <- function(plot_name) {
  names(plot_meta[[plot_name]]$args)
}

get_plot_arg_type <- function(plot_name, arg_name) {
  plot_meta[[plot_name]]$args[[arg_name]]
}

get_arg_choices <- function(arg_type, comb_tbl) {
  fn <- var_type_fn(arg_type)
  arg_choices <- setdiff(
    names(comb_tbl())[purrr::map_lgl(comb_tbl(), ~ fn(.x))],
    c("tbl", "tbl_name")
  )
}

validate_ok_button <- function(input, plot_arg_ids) {
  plot_args_valid <- purrr::map_lgl(
    plot_arg_ids,
    ~ !(is.null(input[[.x]]) || input[[.x]] == "")
  ) |> all()
  if (plot_args_valid) {
    shinyjs::enable(id = "ok")
  }
}

validate_summary <- function(session) {
  #browser()
  check <- session$userData$pk |>
    purrr::map(~ head(.x["pk"])) |>
    purrr::reduce(dplyr::bind_rows) |>
    try(silent = TRUE)
  !inherits(check, "try-error")
}
