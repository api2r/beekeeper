# Skip a test if a function is not exported

Use this in generated test files to skip tests for functions that
haven't been exported yet. By default,
[`generate_pkg_paths()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_paths.md)
generates path functions with `@keywords internal` rather than
`@export`. Tests for those functions will be skipped until you update
the roxygen block to use `@export`.

## Usage

``` r
skip_if_not_exported(fn_name, pkg = testthat::testing_package())
```

## Arguments

- fn_name:

  (`character(1)`) The name of the function to check.

- pkg:

  (`character(1)`) The name of the package to check. Defaults to
  [`testthat::testing_package()`](https://testthat.r-lib.org/reference/is_testing.html).

## Value

(`NULL`, invisibly) Called for its side effect: skips the current test
if `fn_name` is not exported by `pkg`.

## Examples

``` r
# In a generated test file, place this at the top of the test_that() block:
if (FALSE) { # \dontrun{
test_that("my_fn() returns expected result", {
  skip_if_not_exported("my_fn")
  # ... rest of test
})
} # }
```
