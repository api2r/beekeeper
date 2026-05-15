#' Signal a package-scoped error
#'
#' @inheritParams .shared-params
#' @inheritParams stbl::pkg_abort
#' @returns Does not return.
#' @keywords internal
.pkg_abort <- function(
  message,
  subclass,
  parent = NULL,
  call = rlang::caller_env(),
  message_env = rlang::caller_env(),
  ...
) {
  stbl::pkg_abort(
    "beekeeper",
    message,
    subclass,
    call = call,
    message_env = message_env,
    parent = parent,
    ...
  )
}

#' Signal a package-scoped warning
#'
#' @inheritParams .shared-params
#' @inheritParams stbl::pkg_warn
#' @returns `NULL`, invisibly (called for warning side effect).
#' @keywords internal
.pkg_warn <- function(
  message,
  subclass,
  parent = NULL,
  call = rlang::caller_env(),
  message_env = rlang::caller_env(),
  ...
) {
  stbl::pkg_warn(
    "beekeeper",
    message,
    subclass,
    call = call,
    message_env = message_env,
    parent = parent,
    ...
  )
}

#' Signal a package-scoped message
#'
#' @inheritParams .shared-params
#' @inheritParams stbl::pkg_inform
#' @returns `NULL`, invisibly (called for message side effect).
#' @keywords internal
.pkg_inform <- function(
  message,
  subclass,
  parent = NULL,
  call = rlang::caller_env(),
  message_env = rlang::caller_env(),
  ...
) {
  stbl::pkg_inform(
    "beekeeper",
    message,
    subclass,
    call = call,
    message_env = message_env,
    parent = parent,
    ...
  )
}
