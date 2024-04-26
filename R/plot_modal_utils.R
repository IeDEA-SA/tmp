# Return appropriate function for checking variable type according to accepted
# var type codes.
var_type_fn <- function(var_type) {
  switch(var_type,
         numeric = is.numeric,
         integer = is.integer,
         double = is.double,
         Date = function(x) {
           inherits(x, "Date")
         },
         character = is.character,
         factor = is.factor,
         character_or_factor = function(x) {
           is.character(x) | is.factor(x)
         }
  )
}
