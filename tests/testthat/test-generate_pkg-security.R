test_that(".generate_security() generates security file", {
  skip_on_cran()
  config <- .read_config(test_path("_fixtures", "trello_beekeeper.yml"))
  api_definition <- readRDS(test_path("_fixtures", "trello_rapid.rds"))
  security_expected <- readLines(test_path("_fixtures", "trello-020-auth.R"))
  create_local_package()

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

  security_result <- scrub_testpkg(readLines("R/020-auth.R"))
  expect_identical(security_result, security_expected)
})
