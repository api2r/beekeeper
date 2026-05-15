#' Error if not in package
#'
#' @inheritParams .is_pkg
#'
#' @return `NULL`, invisibly.
#' @keywords internal
.assert_is_pkg <- function(base_path = usethis::proj_get()) {
  if (.is_pkg(base_path)) {
    return(invisible(NULL))
  }
  cli_abort(c(
    "Can't generate package files outside of a package.",
    x = "{.path {base_path}} is not inside a package."
  ))
}

#' Check whether we're in a package
#'
#' Inspired by usethis:::is_package.
#'
#' @param base_path The root URL of the current project.
#'
#' @return `TRUE` if the project is a package, `FALSE` if not.
#' @keywords internal
.is_pkg <- function(base_path = proj_get()) {
  root_file <- try_fetch(
    rprojroot::find_package_root_file(path = base_path),
    error = function(cnd) NULL
  )
  !is.null(root_file)
}

#' Read a beekeeper config file
#'
#' @inheritParams .shared-params
#' @returns A `list` of configuration information, with elements `api_title`,
#'   `api_abbr`, `api_version`, `rapid_file`, and `updated_on`.
#' @export
read_config <- function(pkg_dir = ".", config_file = "_beekeeper.yml") {
  config <- yaml::read_yaml(path(pkg_dir, config_file))
  return(.stabilize_config(config))
}

.stabilize_config <- function(config) {
  config$api_title <- stbl::stabilize_character_scalar(config$api_title)
  config$api_abbr <- stbl::stabilize_character_scalar(config$api_abbr)
  config$api_version <- stbl::stabilize_character_scalar(config$api_version)
  config$rapid_file <- stbl::stabilize_character_scalar(config$rapid_file)
  config$updated_on <- strptime(
    config$updated_on,
    format = "%Y-%m-%d %H:%M:%S",
    tz = "UTC"
  )
  return(config)
}

#' Read an API definition file
#'
#' @inheritParams .shared-params
#' @returns A [rapid::class_rapid()] with the definition of the API.
#' @export
read_api_definition <- function(
  pkg_dir = ".",
  rapid_file = "_beekeeper_rapid.rds"
) {
  readRDS(
    path(pkg_dir, rapid_file)
  )
}

.setup_r <- function(pkg_dir, include_stbl = FALSE) {
  if (as.character(pkg_dir) != ".") {
    usethis::local_project(pkg_dir, quiet = TRUE) # nocov
  }
  use_directory("R")
  use_testthat()
  purrr::quietly(use_httptest2)()
  use_package("nectar")
  if (include_stbl) {
    use_package("stbl")
  }
  use_package("beekeeper", type = "Suggests")
}
