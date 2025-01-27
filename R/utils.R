`%|0|%` <- function(x, y) {
  if (!length(x)) {
    y
  } else {
    x
  }
}

`%|"|%` <- function(x, y) {
  if (!nzchar(x)) {
    y
  } else {
    x
  }
}

.coalesce <- function(x, y) {
  ifelse(is.na(x), y, x)
}

.collapse_comma <- function(x) {
  glue_collapse(x, sep = ", ")
}

.collapse_comma_newline <- function(x) {
  glue_collapse(x, sep = ",\n")
}

.collapse_quote_comma <- function(x) {
  stringr::str_flatten_comma(paste0('"', x, '"'))
}

.to_snake <- function(x) {
  to_snake_case(x, parsing_option = 3)
}

.flatten_df <- S7::new_generic(
  ".flatten_df",
  dispatch_args = "x"
)

S7::method(.flatten_df, class_data.frame) <- function(x) {
  return(x)
}

S7::method(.flatten_df, class_list) <- function(x) {
  return(purrr::list_rbind(x))
}

S7::method(.flatten_df, NULL) <- function(x) {
  return(data.frame())
}
