#' Generate a request for the {{api_title}} API
#'
#' Prepare a request for the Slack API, using the opinionated framework defined
#' in [nectar::req_init()], [nectar::req_modify()], [nectar::req_tidy_policy()],
#' and [nectar::req_pagination_policy()].
#'
#' You may wish to export this function (if the API changes often or you do not
#' fully implement the API, for example).
#'{{#has_security}}
#' @inheritParams .shared-params{{/has_security}}
#' @inheritParams nectar::req_prepare
#' @inherit nectar::req_prepare return
#' @keywords internal
{{api_abbr}}_req_prepare <- function(path,
                              query = list(),
                              body = NULL,
                              method = NULL,
                              tidy_fn = nectar::resp_tidy_unknown,{{#has_security}}{{{security_signature}}},{{/has_security}}
                              call = rlang::caller_env()) {
  req <- nectar::req_prepare(
    "{{base_url}}",
    path = path,
    query = query,
    body = body,
    method = method,
    tidy_fn = tidy_fn,
    call = call
  )
  {{#has_security}}req <- .{{api_abbr}}_req_auth(req, {{security_arg_list}}){{/has_security}}
  return(req)
}
