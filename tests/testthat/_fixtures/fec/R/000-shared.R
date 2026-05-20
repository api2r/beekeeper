#' Parameters used in multiple functions
#'
#' Reused parameter definitions are gathered here for easier editing.
#'
#' @param max_reqs (`integer`) The maximum number of separate requests to
#'   perform. Passed on to [nectar::req_perform_opinionated()].
#' @param max_tries_per_req (`integer`) The maximum number of times to attempt
#'   each individual request. Passed on to [nectar::req_perform_opinionated()].
#' @param req (`httr2_request`) The request object to modify.
#' @param ... These dots are for future extensions and must be empty.
#' @param api_key An API key provided by the API provider. This key is not clearly documented in the API description. Check the API documentation for details.
#'
#' @name .shared-params
#' @keywords internal
NULL
