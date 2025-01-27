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
    find_package_root_file(path = base_path),
    error = function(cnd) NULL
  )
  !is.null(root_file)
}

.read_config <- function(config_file = "_beekeeper.yml") {
  config <- read_yaml(config_file)
  return(.stabilize_config(config)) # nocov
}

# covr doesn't see the line above and a bunch below for some reason.
# nocov start
.stabilize_config <- function(config) {
  config$api_title <- stabilize_string(config$api_title)
  config$api_abbr <- stabilize_string(config$api_abbr)
  config$api_version <- stabilize_string(config$api_version)
  config$rapid_file <- stabilize_string(config$rapid_file)
  config$updated_on <- strptime(
    config$updated_on,
    format = "%Y-%m-%d %H:%M:%S",
    tz = "UTC"
  )
  return(config)
}
# nocov end

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
  quietly(use_httptest2)()
  use_package("nectar")
  use_package("beekeeper", type = "Suggests")
}
