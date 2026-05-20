#' Generate a request for the OpenFEC API
#'
#' Prepare a request for the OpenFEC API, using the opinionated framework
#' defined in [nectar::req_init()], [nectar::req_modify()],
#' [nectar::req_tidy_policy()], and [nectar::req_pagination_policy()].
#'
#' You may wish to export this function (if the API changes often or you do not
#' fully implement the API, for example).
#'
#' @inheritParams .shared-params
#' @inheritParams nectar::req_prepare
#' @inherit nectar::req_prepare return
#' @keywords internal
fec_req_prepare <- function(
  path,
  query = list(),
  body = NULL,
  header = list(),
  cookie = list(),
  method = NULL,
  tidy_policy = nectar::tidy_policy_unknown(),
api_key = Sys.getenv("FEC_API_KEY"),
  call = rlang::caller_env()) {
  req <- nectar::req_prepare(
    "https://api.open.fec.gov/v1",
    path = path,
    query = query,
    body = body,
    header = header,
    cookie = cookie,
    method = method,
    tidy_policy = tidy_policy,
    call = call
  )
  req <- .fec_req_auth(req, api_key = api_key)
  return(req)
}
