test_that("as_bk_data warns for unknown classes", {
  expect_warning(
    {
      test_result <- as_bk_data("a")
    },
    "No method for as_bk_data"
  )
  expect_type(test_result, "list")
  expect_length(test_result, 0)
})
