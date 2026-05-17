test_that(".generate_security() returns empty list for no security", {
  result <- .generate_security("test", rapid::class_security_schemes())
  expect_identical(result, list())
})

test_that("as_bk_data() dispatches correctly for security_scheme_details", {
  details <- trello_api_definition@components@security_schemes@details
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
  config <- trello_config
  api_definition <- trello_api_definition
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
    readLines(fs::path(tmp, "R", "020-auth.R")),
    security_expected
  )
})

test_that("generate_pkg_auth() writes auth files and saved security data (#101)", {
  skip_on_cran()
  config_text <- readLines(test_path("_fixtures", "trello", "_beekeeper.yml"))
  security_expected <- readLines(test_path("_fixtures", "trello", "020-auth.R"))

  create_local_package()
  writeLines(config_text, "_beekeeper.yml")
  saveRDS(trello_api_definition, "_beekeeper_rapid.rds")

  result <- generate_pkg_auth()

  expect_identical(
    basename(result$security_file_path),
    "020-auth.R"
  )
  expect_identical(scrub_testpkg(readLines("R/020-auth.R")), security_expected)
  expect_true(file.exists("_beekeeper_security.yml"))
  expect_identical(
    read_config()$security_data_filename,
    "_beekeeper_security.yml"
  )

  saved_security_data <- .read_security_data()
  expect_identical(
    saved_security_data$security_arg_names,
    result$security_arg_names
  )
  expect_false("security_file_path" %in% names(saved_security_data))
})
