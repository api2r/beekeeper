#' Default value for `NULL`
#'
#' @param x (`any`) Object to check.
#' @param y (`any`) Default value for `x`.
#' @returns If `x` is `NULL`, will return `y`; otherwise returns `x`.
#' @name op-null-default
#' @family empty operators
#' @keywords internal
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

# Reexport from base on newer versions of R to avoid conflict messages
if (exists("%||%", envir = baseenv())) {
  `%||%` <- get("%||%", envir = baseenv())
}

#' Default value for non-`NULL`
#'
#' @param x (`any`) Object to check.
#' @param y (`any`) Default value for non-`NULL` `x`.
#' @returns If `x` is `NULL`, will return `x`; otherwise returns `y`.
#' @name op-null-continuation
#' @family empty operators
#' @keywords internal
`%&&%` <- function(x, y) {
  if (!is.null(x)) y else x
}

#' Default value for length 0
#'
#' @param x (`any`) Object to check.
#' @param y (`any`) Default value for `x`.
#' @returns If `!length(x)`, will return `x`; otherwise returns `y`.
#' @keywords internal
#' @name op-lengthless-default
#' @family empty operators
#' @keywords internal
`%|0|%` <- function(x, y) {
  if (!length(x)) y else x
}

#' Default value for empty strings
#'
#' @param x (`any`) Object to check.
#' @param y (`character`) Default value for `x`.
#' @returns If `!nzchar(x)`, will return `y`; otherwise returns `x`.
#' @keywords internal
#' @name op-no-char-default
#' @family empty operators
#' @keywords internal
`%|a|%` <- function(x, y) {
  if (!is.character(x) || !nzchar(x)) {
    stbl::to_chr(y)
  } else {
    x
  }
}

#' Default value for NA elements in vectors
#'
#' @param x (`any`) A vector that may contain `NA` elements.
#' @param y (`any`, coercible to the same class as `x`) A value or vector to
#'   replace `NA` elements in `x`. Will be recycled to the same length as `x`.
#' @returns A vector of the same length as `x`, where each `NA` element in `x`
#'   is replaced by the corresponding element in `y`.
#' @keywords internal
#' @name op-na-coalesce
#' @family empty operators
#' @keywords internal
`%|%` <- function(x, y) {
  ifelse(is.na(x), y, x)
}

#' Collapse to a comma-separated string
#'
#' @inheritParams .shared-params
#' @returns A length-1, comma-separated glue object.
#' @keywords internal
.collapse_comma <- function(to_collapse) {
  glue::glue_collapse(to_collapse, sep = ", ")
}

#' Collapse to a comma-separated vertical string
#'
#' @inheritParams .shared-params
#' @returns A length-1, comma-separated glue object with newlines.
#' @keywords internal
.collapse_comma_newline <- function(to_collapse) {
  glue::glue_collapse(to_collapse, sep = ",\n")
}

#' Collapse to a comma-separated quoted string
#'
#' @inheritParams .shared-params
#' @returns A length-1, comma-separated glue object.
#' @keywords internal
.collapse_quote_comma <- function(to_collapse) {
  stringr::str_flatten_comma(paste0('"', to_collapse, '"'))
}

#' Collapse to a comma-separated x = x string
#'
#' @inheritParams .shared-params
#' @returns A length-1, comma-separated glue object.
#' @keywords internal
.collapse_comma_self_equal <- function(x) {
  .collapse_comma(glue::glue("{x} = {x}"))
}

#' Append text conditionally
#'
#' @param original (`character`) The original text.
#' @param test (`logical`) A condition for each element of `original`.
#' @param addition (`character`) Text to append when `test` is `TRUE`.
#' @returns (`character`) The updated text.
#' @keywords internal
.paste0_if <- function(original, test, addition) {
  ifelse(test, paste0(original, addition), original)
}

#' Interpolate glue with pipe braces
#'
#' @param ... Expressions passed to [glue::glue()].
#' @param .envir (`environment`) The environment in which to evaluate `...`.
#' @returns A glue object.
#' @keywords internal
.glue_pipe_brace <- function(..., .envir = rlang::caller_env()) {
  glue::glue(..., .open = "|{", .close = "}|", .envir = .envir)
}

#' Convert text to snake case
#'
#' @param x (`character`) Text to convert.
#' @returns (`character`) Snake-case text.
#' @keywords internal
.to_snake <- function(x) {
  snakecase::to_snake_case(x, parsing_option = 3)
}

#' Flatten a data frame or list of data frames
#'
#' @param x (`data.frame`, `list`, or `NULL`) The object to flatten.
#' @returns A single `data.frame`. Lists of data frames are flattened with
#'   [purrr::list_rbind()], and `NULL` values are converted to empty data
#'   frames.
#' @keywords internal
.flatten_df <- S7::new_generic(".flatten_df", dispatch_args = "x")

#' Flatten a data frame method
#'
#' @param x (`data.frame`) The object to return unchanged.
#' @returns A `data.frame`.
#' @keywords internal
.flatten_df_data_frame <- function(x) x

S7::method(.flatten_df, class_data.frame) <- .flatten_df_data_frame

#' Flatten a list method
#'
#' @param x (`list`) The objects to row-bind.
#' @returns A `data.frame`.
#' @keywords internal
.flatten_df_list <- function(x) purrr::list_rbind(x)

S7::method(.flatten_df, class_list) <- .flatten_df_list

#' Flatten a `NULL` method
#'
#' @param x (`NULL`) The object to convert.
#' @returns A `data.frame`.
#' @keywords internal
.flatten_df_null <- function(x) data.frame()

S7::method(.flatten_df, NULL) <- .flatten_df_null
