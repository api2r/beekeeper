#' Prepare rapid objects for beekeeper
#'
#' Convert `rapid` objects to lists of properties to use in beekeeper templates.
#'
#' @inheritParams rlang::args_dots_empty
#' @param x The object to coerce. Currently supports conversion of
#'   [rapid::class_security_schemes()] objects.
#'
#' @returns A list.
#' @keywords internal
as_bk_data <- S7::new_generic("as_bk_data", dispatch_args = "x")

S7::method(as_bk_data, class_any) <- function(x) {
  cli::cli_warn("No method for as_bk_data() for class {.cls {class(x)}}.")
  return(list())
}
