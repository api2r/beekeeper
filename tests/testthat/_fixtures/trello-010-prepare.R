#' Generate a request for the Trello API
#'
#' Prepare a request for the Slack API, using the opinionated framework defined
#' in [nectar::req_init()], [nectar::req_modify()], [nectar::req_tidy_policy()],
#' and [nectar::req_pagination_policy()].
#'
#' You may wish to export this function (if the API changes often or you do not
#' fully implement the API, for example).
#'
#' @inheritParams .shared-params
#' @inheritParams nectar::req_prepare
#' @inherit nectar::req_prepare return
#' @keywords internal
trello_req_prepare <- function(path,
                               query = list(),
                               body = NULL,
                               method = NULL,
                               tidy_fn = nectar::resp_tidy_unknown, key = Sys.getenv("TRELLO_KEY"),
                               token = Sys.getenv("TRELLO_TOKEN"),
                               call = rlang::caller_env()) {
  req <- nectar::req_prepare(
    "https://trello.com/1",
    path = path,
    query = query,
    body = body,
    method = method,
    tidy_fn = tidy_fn,
    call = call
  )
  req <- .trello_req_auth(req, key = key, token = token)
  return(req)
}
