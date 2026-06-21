#' Skip a test if a function is not exported
#'
#' Skip tests when functions aren't exported by a package (yet). Useful for
#' auto-generated tests, so the tests are not active until the function has been
#' reviewed and exported.
#'
#' @param fn_name (`character(1)`) The name of the function to check.
#' @param pkg (`character(1)`) The name of the package to check. Defaults to
#'   the name of the package being tested via [testthat::testing_package()]. If
#'   the package is *not* the package currently being tested, it must be
#'   installed on the testing system.
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
skip_if_not_exported <- function(fn_name, pkg = testthat::testing_package()) {
  rlang::check_installed(
    "pkgload",
    "to decide whether to skip a test for unexported functions."
  )
  fn_name <- stbl::to_chr_scalar(fn_name)
  pkg <- stbl::to_chr_scalar(pkg)
  if (!pkgload::is_dev_package(pkg)) {
    # Load non-dev package to check its exports.
    rlang::check_installed(
      pkg,
      paste0("to decide whether to skip a test for ", pkg, "::", fn_name, "().")
    )
    require(pkg, character.only = TRUE, quietly = TRUE)
  }
  if (!fn_name %in% getNamespaceExports(pkg)) {
    testthat::skip(paste0(fn_name, "() is not exported from ", pkg))
  }
  invisible(NULL)
}
