#' Error if not in package
#'
#' @inheritParams .shared-params
#' @returns (`NULL`, invisibly) Called for error side effect.
#' @keywords internal
.assert_is_pkg <- function(pkg_dir = usethis::proj_get()) {
  if (.is_pkg(pkg_dir)) {
    return(invisible(NULL))
  }
  cli::cli_abort(c(
    "Can't generate package files outside of a package.",
    x = "{.path {pkg_dir}} is not inside a package."
  ))
}

#' Check whether we're in a package
#'
#' Inspired by usethis:::is_package.
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if the project is a package, `FALSE` if not.
#' @keywords internal
.is_pkg <- function(pkg_dir = usethis::proj_get()) {
  root_file <- rlang::try_fetch(
    rprojroot::find_package_root_file(path = pkg_dir),
    error = function(cnd) NULL
  )
  !is.null(root_file)
}

#' Set up package directories and dependencies
#'
#' @inheritParams .shared-params
#' @returns (`NULL`, invisibly) Called for setup side effects.
#' @keywords internal
.setup_r <- function(pkg_dir) {
  .use_r_directory(pkg_dir)
  .use_testthat(pkg_dir)
  .use_httptest2(pkg_dir)
  .use_nectar(pkg_dir)
  .use_beekeeper(pkg_dir)
}

#' Ensure the R directory exists
#'
#' @inheritParams .shared-params
#' @returns (`NULL`, invisibly) Called for setup side effects.
#' @keywords internal
.use_r_directory <- function(pkg_dir) {
  usethis::with_project(
    pkg_dir,
    usethis::use_directory("R"),
    quiet = TRUE
  )
  invisible(NULL)
}

#' Ensure testthat is configured
#'
#' @inheritParams .shared-params
#' @returns (`NULL`, invisibly) Called for setup side effects.
#' @keywords internal
.use_testthat <- function(pkg_dir) {
  usethis::with_project(
    pkg_dir,
    withr::with_options(list(usethis.quiet = TRUE), usethis::use_testthat()),
    quiet = TRUE
  )
  invisible(NULL)
}

#' Ensure httptest2 is configured
#'
#' @inheritParams .shared-params
#' @returns (`NULL`, invisibly) Called for setup side effects.
#' @keywords internal
.use_httptest2 <- function(pkg_dir) {
  usethis::with_project(
    pkg_dir,
    purrr::quietly(httptest2::use_httptest2)(),
    quiet = TRUE
  )
  invisible(NULL)
}

#' Add a package dependency to the DESCRIPTION file
#'
#' @param pkg (`character(1)`) The package name.
#' @param type (`character(1)`) The dependency type, one of "Imports",
#'   "Suggests", or "Depends".
#' @inheritParams .shared-params
#' @returns (`character(1)`, invisibly) The package name.
#' @keywords internal
.use_package <- function(pkg, type = "Imports", pkg_dir = ".") {
  usethis::with_project(
    pkg_dir,
    {
      usethis::use_package(pkg, type = type)
    },
    quiet = TRUE
  )
  invisible(pkg)
}

#' Add nectar to imports
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`, invisibly) The package name.
#' @keywords internal
.use_nectar <- function(pkg_dir = ".") {
  .use_package("nectar", "Imports", pkg_dir)
}

#' Add beekeeper to suggests
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`, invisibly) The package name.
#' @keywords internal
.use_beekeeper <- function(pkg_dir = ".") {
  .use_package("beekeeper", "Suggests", pkg_dir)
}

#' Add stbl to dependencies if needed
#'
#' @inheritParams .shared-params
#' @returns (`character(1)` or `NULL`, invisibly) "stbl" if stbl is used, `NULL`
#'   otherwise.
#' @keywords internal
.maybe_use_stbl <- function(pkg_dir, paths, security_arg_names) {
  if (.paths_need_stbl(paths, security_arg_names)) {
    .use_package("stbl", "Imports", pkg_dir)
  }
}
