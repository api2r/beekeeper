test_that(".generate_shared_params() returns file path for no-security API (#65)", {
  skip_on_cran()
  tmp <- withr::local_tempdir()
  local_mocked_bindings(.bk_use_template_impl = make_writing_impl(tmp))

  result <- .generate_shared_params(list())

  expect_identical(result, file.path(tmp, "R", "000-shared.R"))
})

test_that(".generate_shared_params() writes correct content for no-security API (#65)", {
  skip_on_cran()
  shared_expected <- readLines(test_path("_fixtures", "guru", "000-shared.R"))
  tmp <- withr::local_tempdir()
  local_mocked_bindings(.bk_use_template_impl = make_writing_impl(tmp))

  .generate_shared_params(list())

  expect_identical(
    readLines(file.path(tmp, "R", "000-shared.R")),
    shared_expected
  )
})

test_that(".generate_shared_params() writes security params for API with security (#65)", {
  skip_on_cran()
  tmp <- withr::local_tempdir()
  local_mocked_bindings(.bk_use_template_impl = make_writing_impl(tmp))
  security_data <- .generate_security(
    trello_config$api_abbr,
    trello_api_definition@components@security_schemes
  )
  shared_expected <- readLines(test_path("_fixtures", "trello", "000-shared.R"))
  .generate_shared_params(security_data)
  expect_identical(
    readLines(file.path(tmp, "R", "000-shared.R")),
    shared_expected
  )
})
