#' Skip a test if a function is not exported
#'
#' Use this in generated test files to skip tests for functions that haven't
#' been exported yet. By default, `generate_pkg_paths()` generates path
#' functions with `@keywords internal` rather than `@export`. Tests for those
#' functions will be skipped until you update the roxygen block to use
#' `@export`.
#'
#' @param fn_name (`character(1)`) The name of the function to check.
#' @param pkg (`character(1)`) The name of the package to check. Defaults to
#'   [testthat::testing_package()].
#'
#' @returns (`NULL`, invisibly) Called for its side effect: skips the current
#'   test if `fn_name` is not exported by `pkg`.
#' @export
#'
#' @examples
#' # In a generated test file, place this at the top of the test_that() block:
#' \dontrun{
#' test_that("my_fn() returns expected result", {
#'   skip_if_not_exported("my_fn")
#'   # ... rest of test
#' })
#' }
skip_if_not_exported <- function(
  fn_name,
  pkg = testthat::testing_package()
) {
  fn_name <- stbl::to_chr_scalar(fn_name)
  pkg <- stbl::to_chr_scalar(pkg)

  if (!pkgload::is_dev_package(pkg)) {
    require(pkg, character.only = TRUE, quietly = TRUE)
  }

  if (!fn_name %in% getNamespaceExports(pkg)) {
    testthat::skip(paste0(fn_name, "() is not exported from ", pkg))
  }

  invisible(NULL)
}
