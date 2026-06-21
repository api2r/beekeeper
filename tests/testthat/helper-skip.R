# Helpers for testing skip conditions. Inspired by testthat's internal
# expect-self-test.R.

expect_skip <- function(code) {
  saw_skip <- FALSE
  tryCatch(
    code,
    skip = function(cnd) {
      saw_skip <<- TRUE
    }
  )
  if (!saw_skip) {
    testthat::fail("Expected a skip condition but none was thrown.")
  }
  testthat::succeed()
  invisible(NULL)
}

expect_no_skip <- function(code) {
  tryCatch(
    {
      code
      testthat::succeed()
    },
    skip = function(cnd) {
      testthat::fail(
        paste0("Unexpected skip: ", conditionMessage(cnd))
      )
    }
  )
  invisible(NULL)
}
