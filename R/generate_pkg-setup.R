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
.setup_r <- function(pkg_dir, include_stbl = FALSE) {
  if (as.character(pkg_dir) != ".") {
    usethis::local_project(pkg_dir, quiet = TRUE) # nocov
  }
  usethis::use_directory("R")
  withr::with_options(list(usethis.quiet = TRUE), usethis::use_testthat())
  purrr::quietly(httptest2::use_httptest2)()
  usethis::use_package("nectar")
  if (include_stbl) {
    usethis::use_package("stbl")
  }
  usethis::use_package("beekeeper", type = "Suggests")
}
