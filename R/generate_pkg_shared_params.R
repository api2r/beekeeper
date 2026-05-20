#' Generate shared parameter docs
#'
#' Generate the shared roxygen parameter definitions used across scaffolded
#' functions. This supports incremental package scaffolding when you want to
#' review or customize the shared parameter topic independently while iterating
#' on the rest of the generated package files.
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated file path. As a side effect,
#'   `R/000-shared.R` is generated.
#' @export
#' @family package generation functions
#' @examplesIf rlang::is_installed("withr")
#' # Set up an empty package.
#' pkg_dir <- unclass(fs::path_norm(withr::local_tempdir()))
#' usethis::create_package(pkg_dir, open = FALSE, check_name = FALSE)
#' bk_files <- c("_beekeeper.yml", "_beekeeper_rapid.rds")
#' fs::file_copy(
#'   fs::path_package("beekeeper", "trello", bk_files),
#'   fs::path(pkg_dir, bk_files)
#' )
#' usethis::local_project(pkg_dir)
#'
#' # Generate shared parameters.
#' generate_pkg_shared_params()
#' fs::dir_ls("R")
#'
#' # Clean up.
#' withr::deferred_run()
generate_pkg_shared_params <- function(
  security_data = read_security_data(pkg_dir, "_beekeeper.yml"),
  pkg_dir = "."
) {
  .assert_is_pkg(pkg_dir)
  .use_r_directory(pkg_dir)
  .use_nectar(pkg_dir)
  .use_pkg_beekeeper(pkg_dir)
  .generate_shared_params(security_data)
}

#' Generate shared parameter docs
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated file path.
#' @keywords internal
.generate_shared_params <- function(security_data) {
  shared_file_path <- .bk_use_template(
    template = "000-shared.R",
    data = list(
      shared_arg_helps = list(),
      security_arg_helps = security_data$security_arg_helps
    )
  )
  return(shared_file_path)
}
