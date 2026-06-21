test_that("skip_if_not_exported() skips when function is not exported (#133)", {
  expect_skip(
    skip_if_not_exported("fake_function", "beekeeper")
  )
})

test_that("skip_if_not_exported() does not skip when function is exported (#133)", {
  expect_no_skip(
    skip_if_not_exported("print", "base")
  )
})

test_that("skip_if_not_exported() defaults pkg to testing_package() (#133)", {
  # During testing of this package, testing_package() returns "beekeeper"
  expect_no_skip(
    skip_if_not_exported("skip_if_not_exported")
  )
})
