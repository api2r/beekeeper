#' Generate a request for the APIs.guru API
#'
#' Prepare a request for the Slack API, using the opinionated framework defined
#' in [nectar::req_init()], [nectar::req_modify()], [nectar::req_tidy_policy()],
#' and [nectar::req_pagination_policy()].
#'
#' You may wish to export this function (if the API changes often or you do not
#' fully implement the API, for example).
#'
#' @inheritParams nectar::req_prepare
#' @inherit nectar::req_prepare return
#' @keywords internal
guru_req_prepare <- function(
  path,
  query = list(),
  body = NULL,
  method = NULL,
  tidy_fn = nectar::resp_tidy_unknown,
  call = rlang::caller_env()
) {
  req <- nectar::req_prepare(
    "https://api.apis.guru/v2",
    path = path,
    query = query,
    body = body,
    method = method,
    tidy_fn = tidy_fn,
    call = call
  )

  return(req)
}
