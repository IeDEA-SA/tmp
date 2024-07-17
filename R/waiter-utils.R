waiting_screen <- function(msg = "Applying schema changes...") {
  tagList(
    waiter::spin_flower(),
    h4(msg)
  )
}

add_waiter <- function(id = NULL, msg, color = "maroon") {
  hide_on_render <- ifelse(is.null(id), FALSE, TRUE)
  w <- waiter::Waiter$new(
    id = id,
    html = waiting_screen(msg),
    color = color,
    fadeout = TRUE,
    hide_on_render = hide_on_render
  )

  w$show()
  on.exit({
    w$hide()
  })
}
