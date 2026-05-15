test_that(".generate_security() returns empty list for no security", {
  result <- .generate_security("test", rapid::class_security_schemes())
  expect_identical(result, list())
})

test_that("as_bk_data() dispatches correctly for security_scheme_details", {
  trello_rapid <- readRDS(test_path(
    "_fixtures",
    "trello",
    "_beekeeper_rapid.rds"
  ))
  details <- trello_rapid@components@security_schemes@details
  result <- as_bk_data(details)
  expect_length(result, 2L)
  expect_identical(result[[1]]$type, "api_key")
  expect_identical(result[[1]]$arg_name, "key")
  expect_identical(result[[2]]$arg_name, "token")
})

test_that("as_bk_data() returns empty list for empty api_key_security_scheme", {
  expect_identical(as_bk_data(rapid::class_api_key_security_scheme()), list())
})

test_that(".generate_security() generates security file for trello", {
  skip_on_cran()
  config <- read_config(pkg_dir = test_path("_fixtures", "trello"))
  api_definition <- readRDS(test_path(
    "_fixtures",
    "trello",
    "_beekeeper_rapid.rds"
  ))
  security_expected <- readLines(test_path("_fixtures", "trello", "020-auth.R"))
  tmp <- withr::local_tempdir()
  local_mocked_bindings(.bk_use_template_impl = make_writing_impl(tmp))
  test_result <- .generate_security(
    config$api_abbr,
    api_definition@components@security_schemes
  )
  expect_named(
    test_result,
    c(
      "has_security",
      "security_schemes",
      "security_arg_names",
      "security_arg_list",
      "security_arg_helps",
      "security_arg_nulls",
      "security_file_path",
      "security_signature"
    )
  )
  expect_identical(
    readLines(file.path(tmp, "R", "020-auth.R")),
    security_expected
  )
})
