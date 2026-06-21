# Skip a test if a function is not exported

Skip tests when functions aren't exported by a package (yet). Useful for
auto-generated tests, so the tests are not active until the function has
been reviewed and exported.

## Usage

``` r
skip_if_not_exported(fn_name, pkg = testthat::testing_package())
```

## Arguments

- fn_name:

  (`character(1)`) The name of the function to check.

- pkg:

  (`character(1)`) The name of the package to check. Defaults to the
  name of the package being tested via
  [`testthat::testing_package()`](https://testthat.r-lib.org/reference/is_testing.html).
  If the package is *not* the package currently being tested, it must be
  installed on the testing system.

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
