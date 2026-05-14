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

.read_config <- function(config_file = "_beekeeper.yml") {
  config <- yaml::read_yaml(config_file)
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

.read_api_definition <- function(pkg_dir, rapid_file) {
  readRDS(
    path(pkg_dir, rapid_file)
  )
}

.setup_r <- function(pkg_dir) {
  if (as.character(pkg_dir) != ".") {
    usethis::local_project(pkg_dir, quiet = TRUE) # nocov
  }
  use_directory("R")
  use_testthat()
  purrr::quietly(use_httptest2)()
  use_package("nectar")
  use_package("beekeeper", type = "Suggests")
}
