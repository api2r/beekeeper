test_that("as_bk_data warns for unknown classes", {
  stbl::expect_pkg_warning_snapshot(
    {
      test_result <- as_bk_data("a")
    },
    "beekeeper",
    "bk_data",
    "missing_method"
  )

  # Workaround for wranglezone/stbl#234
  test_result <- suppressWarnings(as_bk_data("a"))
  expect_type(test_result, "list")
  expect_length(test_result, 0)
})
