#' Generate request-prepare helpers
#'
#' @inheritParams .shared-params
#' @returns (`character`) Generated file paths.
#' @export
generate_pkg_req_prepare <- function(
  api_abbr = read_api_abbr(pkg_dir, config_filename),
  api_definition = read_api_definition(
    pkg_dir,
    read_rapid_filename(pkg_dir, config_filename)
  ),
  api_title = read_api_title(pkg_dir, config_filename),
  security_data = .read_security_data(pkg_dir, config_filename),
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
) {
  .assert_is_pkg(pkg_dir)
  api_abbr <- stbl::stabilize_character_scalar(api_abbr)
  api_title <- stbl::stabilize_character_scalar(api_title)
  .use_r_directory(pkg_dir)
  .use_testthat(pkg_dir)
  .use_nectar(pkg_dir)
  .use_beekeeper(pkg_dir)
  .generate_prepare(
    config = list(api_abbr = api_abbr, api_title = api_title),
    api_definition = api_definition,
    security_data = security_data
  )
}

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
