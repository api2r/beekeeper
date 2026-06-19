test_that("skip_if_not_exported() skips when function is not exported (#133)", {
  expect_skip(
    skip_if_not_exported(".generate_paths", "beekeeper")
  )
})

test_that("skip_if_not_exported() does not skip when function is exported (#133)", {
  expect_no_skip(
    skip_if_not_exported("generate_pkg_paths", "beekeeper")
  )
})

test_that("skip_if_not_exported() defaults pkg to testing_package() (#133)", {
  # During testing, testing_package() returns "beekeeper"
  expect_no_skip(
    skip_if_not_exported("generate_pkg_paths")
  )
})

test_that("skip_if_not_exported() uses getNamespaceExports when pkg is dev pkg (#133)", {
  local_mocked_bindings(
    is_dev_package = function(pkg) TRUE,
    .package = "pkgload"
  )
  expect_no_skip(
    skip_if_not_exported("generate_pkg_paths", "beekeeper")
  )
})

test_that("skip_if_not_exported() still checks exports when pkg is not a dev pkg (#133)", {
  local_mocked_bindings(
    is_dev_package = function(pkg) FALSE,
    .package = "pkgload"
  )
  # beekeeper is already loaded, so require() is a no-op; export check still works
  expect_no_skip(
    skip_if_not_exported("generate_pkg_paths", "beekeeper")
  )
  expect_skip(
    skip_if_not_exported(".generate_paths", "beekeeper")
  )
})
