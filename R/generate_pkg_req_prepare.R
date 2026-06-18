#' Generate request-prepare helpers
#'
#' Generate the core request helper and its initial test file for a package
#' under development. This supports incremental package scaffolding when you
#' want to review or customize the central request-construction helper used by
#' generated endpoint wrappers separately from other package components.
#'
#' @inheritParams .shared-params
#' @returns (`character`) Generated file paths. As a side effect,
#'   `R/010-prepare.R` and `tests/testthat/test-010-prepare.R` are generated.
#' @export
#' @family package generation functions
#' @examplesIf rlang::is_installed("withr")
#' # Set up an empty package.
#' pkg_dir <- unclass(fs::path_norm(withr::local_tempdir()))
#' usethis::create_package(pkg_dir, open = FALSE, check_name = FALSE)
#' bk_files <- c("_beekeeper.yml", "_beekeeper_rapid.rds")
#' fs::file_copy(
#'   fs::path_package("beekeeper", "guru", bk_files),
#'   fs::path(pkg_dir, bk_files)
#' )
#' usethis::local_project(pkg_dir)
#'
#' # Generate functions and tests for request preparation.
#' generate_pkg_req_prepare()
#' fs::dir_ls("R")
#' fs::dir_ls("tests/testthat")
#'
#' # Clean up.
#' withr::deferred_run()
generate_pkg_req_prepare <- function(
  api_abbr = read_api_abbr(pkg_dir, config_filename),
  api_definition = read_api_definition(
    pkg_dir,
    read_rapid_filename(pkg_dir, config_filename)
  ),
  api_title = read_api_title(pkg_dir, config_filename),
  security_data = read_security_data(pkg_dir, config_filename),
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
) {
  .assert_is_pkg(pkg_dir)
  api_abbr <- stbl::stabilize_chr_scalar(api_abbr)
  api_title <- stbl::stabilize_chr_scalar(api_title)
  .use_r_directory(pkg_dir)
  .use_testthat(pkg_dir)
  .use_nectar(pkg_dir)
  .use_pkg_beekeeper(pkg_dir)
  .generate_prepare(
    config = list(api_abbr = api_abbr, api_title = api_title),
    api_definition = api_definition,
    security_data = security_data,
    pkg_dir = pkg_dir
  )
}

#' Generate prepare files
#'
#' @inheritParams .shared-params
#' @returns (`character`) Generated file paths.
#' @keywords internal
.generate_prepare <- function(
  config,
  api_definition,
  security_data,
  pkg_dir = "."
) {
  c(
    .generate_prepare_r(config, api_definition, security_data, pkg_dir),
    .generate_prepare_test(config$api_abbr, pkg_dir)
  )
}

#' Generate the prepare helper
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated file path.
#' @keywords internal
.generate_prepare_r <- function(
  config,
  api_definition,
  security_data,
  pkg_dir = "."
) {
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
    ),
    pkg_dir = pkg_dir
  )
}

#' Generate prepare tests
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated test file path.
#' @keywords internal
.generate_prepare_test <- function(api_abbr, pkg_dir = ".") {
  .bk_use_template(
    template = "test-010-prepare.R",
    dir = "tests/testthat",
    data = list(api_abbr = api_abbr),
    pkg_dir = pkg_dir
  )
}
