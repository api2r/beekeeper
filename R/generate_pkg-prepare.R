#' Generate prepare files
#'
#' @inheritParams .shared-params
#' @returns (`character`) Generated file paths.
#' @keywords internal
.generate_prepare <- function(config, api_definition, security_data) {
  c(
    .generate_prepare_r(config, api_definition, security_data),
    .generate_prepare_test(config$api_abbr)
  )
}

#' Generate the prepare helper
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated file path.
#' @keywords internal
.generate_prepare_r <- function(config, api_definition, security_data) {
  .bk_use_template(
    template = "010-prepare.R",
    data = list(
      api_title = config$api_title,
      api_abbr = config$api_abbr,
      base_url = api_definition@servers@url,
      has_security = security_data$has_security,
      security_arg_helps = security_data$security_arg_helps,
      security_signature = security_data$security_signature,
      security_arg_list = security_data$security_arg_list
    )
  )
}

#' Generate prepare tests
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated test file path.
#' @keywords internal
.generate_prepare_test <- function(api_abbr) {
  .bk_use_template(
    template = "test-010-prepare.R",
    dir = "tests/testthat",
    data = list(api_abbr = api_abbr)
  )
}
