remove_tbl_tab <- function(tbl_name, tab_id, ns, input, output, session) {
  log_debug("remove tab {tbl_name}")
  tbl_id_ns <- ns(tab_id)

  removeUI(
    selector = "div:has(> '#shiny-modal')",
    multiple = TRUE
  )

  removeTab("tab", tbl_id_ns)
  remove_shiny_inputs(tbl_id_ns, input, parent_id = sprintf("%s-", ns(NULL)))
  remove_shiny_outputs(tbl_id_ns, output, parent_id = sprintf("%s-", ns(NULL)))

  session$userData$plots[[tbl_name]] <- NULL
  session$userData$pk[[tbl_name]] <- NULL
  if (isFALSE(is.null(session$userData$add_plot_observers[[tab_id]]))
  ) {
    session$userData$add_plot_observers[[tab_id]]$destroy()
  }

  if (tbl_name == session$userData$pk_tbl_name) {
    log_debug("Removing primary key table {tbl_name}.")
    showNotification(
      glue::glue("Table {tbl_name} removed as source of primary key info."),
      type = "default"
    )
  }
}

remove_rv <- function(x, name) {
  if (isFALSE(is.reactivevalues(x))) {
    stop("Input must be a reactiveValues object.")
  }
  rv <- .subset2(x, "impl")
  rv$.values$remove(name)
  rv$.nameOrder <- setdiff(rv$.nameOrder, name)
}

get_tab_icon <- function(valid, tbl_name, pk_tbl_name) {
  if (valid) {
    if (tbl_name == pk_tbl_name) {
      icon("key")
    } else {
      icon("check")
    }
  } else {
    icon("x")
  }
}

tbl_tab_ui <- function(tbl_name, tab_id, ns, tbl_valid_cols, tbl_valid, clean_tbls,
                       session) {
  log_debug("adding tab {tbl_name}")
  tab_index <- which(names(clean_tbls) %in% tab_id)
  tab_icon <- get_tab_icon(
    tbl_valid, tbl_name,
    session$userData$pk_tbl_name
  )

  tab_panel <- tabPanel(
    title = tbl_name,
    mod_pk_column_ui(
      ns(tab_id),
      colnames = tbl_valid_cols,
      add = session$userData$pk_col
    ),
    mod_display_check_ui(ns(tab_id)),
    mod_tbl_plots_ui(ns(tab_id)),
    value = ns(tab_id),
    icon = tab_icon
  )
  if (tab_index == 1) {
    log_debug("Prepend as first tab")
    prependTab(
      inputId = "tab",
      tab_panel,
      select = FALSE
    )
  } else {
    target_tab <- ns(names(clean_tbls)[tab_index - 1])
    log_debug("Insert as tab after {target_tab} (from clean_tbls)")
    insertTab(
      inputId = "tab",
      target = target_tab,
      position = "after",
      tab_panel,
      select = FALSE
    )
  }
}

tbl_tab_pk <- function(tbl_name, session, tbl_valid_cols) {
  if (tbl_name == session$userData$pk_tbl_name) {
    if (session$userData$pk_col %in% tbl_valid_cols) {
      showNotification(
        glue::glue("Table {tbl_name} set as source of primary key info."),
        type = "default"
      )
    } else {
      log_debug("Failed to subset {tbl_name} for primary key info.
                      pk_col {session$userData$pk_col} missing.")
      showNotification(
        glue::glue(
          "Expected primary key column '{session$userData$pk_col}' not found
                in primary key table. Please check data or use `pk_col` argument
                in `run_app` to re-configure primary key column."
        ),
        duration = NULL,
        type = "error"
      )
    }
  }
}

tbl_tab_server <- function(tab_id, tbl_name, comb_tbl) {
  if (isFALSE(is.reactive(comb_tbl))) {
    stop("Input must be a reactive expression.")
  }
  mod_pk_column_server(
    id = tab_id,
    comb_tbl = comb_tbl,
    tbl_name = tbl_name
  )

  mod_tbl_plots_server(
    id = tab_id,
    comb_tbl = comb_tbl
  )
}

summary_tab <- function(ns, input, output, session) {
  remove_tbl_tab(
    "summary", "summary",
    ns, input, output, session
  )

  log_debug("Append summary tab at the end of the tab list.")
  summary_panel <- tabPanel(
    title = "Data Completeness",
    value = ns("summary"),
    icon = icon("rectangle-list"),
    mod_tbl_plots_ui(ns("summary"))
  )
  appendTab(
    inputId = "tab",
    summary_panel,
    select = FALSE
  )

  mod_tbl_plots_server(
    id = "summary",
    comb_tbl = NULL
  )
}
