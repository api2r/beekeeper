#' Parameters used in multiple functions
#'
#' Reused parameter definitions are gathered here for easier editing.
#'
#' @param max_reqs (length-1 `integer`) The maximum number of separate requests to
#'   perform. Passed on to [nectar::req_perform_opinionated()].
#' @param max_tries_per_req (length-1 `integer`) The maximum number of times to attempt
#'   each individual request. Passed on to [nectar::req_perform_opinionated()].
#' @param req (`httr2_request`) The request object to modify.
#' @param ... These dots are for future extensions and must be empty.{{#shared_arg_helps}}
#' @param {{name}} {{{description}}}{{/shared_arg_helps}}{{#security_arg_helps}}
#' @param {{name}} {{{description}}}{{/security_arg_helps}}
#'
#' @name .shared-params
#' @keywords internal
NULL
