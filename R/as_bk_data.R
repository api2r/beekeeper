#' Prepare rapid objects for beekeeper
#'
#' Convert `rapid` objects to lists of properties to use in beekeeper templates.
#'
#' @inheritParams .shared-params
#' @param ... Additional parameters passed to methods.
#' @returns (`list`) A list.
#' @keywords internal
as_bk_data <- S7::new_generic("as_bk_data", dispatch_args = "x")

S7::method(as_bk_data, class_any) <- function(x, ...) {
  .pkg_warn(
    "No method for as_bk_data() for class {.cls {class(x)}}.",
    c("bk_data", "missing_method")
  )
  return(list())
}
