test_that("generate_pkg() returns a vector of created files", {
  skip_on_cran()
  create_local_package()

  test_result <- generate_pkg(
    api_abbr = guru_config$api_abbr,
    api_definition = guru_api_definition,
    api_title = guru_config$api_title
  )
  test_result <- scrub_path(test_result)
  # 7 guru operations all in "apis" tag: 7 R files + 1 test file + setup
  expected_result <- c(
    "/R/000-shared.R",
    "/R/010-prepare.R",
    "/tests/testthat/test-010-prepare.R",
    "/R/paths-apis-list_apis.R",
    "/R/paths-apis-get_metrics.R",
    "/R/paths-apis-get_providers.R",
    "/R/paths-apis-get_api.R",
    "/R/paths-apis-get_service_api.R",
    "/R/paths-apis-get_provider.R",
    "/R/paths-apis-get_services.R",
    "/tests/testthat/test-paths-apis.R",
    "/tests/testthat/setup.R"
  )

  expect_identical(test_result, expected_result)
})

test_that("generate_pkg() generates call function with API keys", {
  skip_on_cran()
  local_mocked_bindings(
    .generate_paths = function(...) {
      character()
    }
  )
  prepare_expected <- readLines(test_path(
    "_fixtures",
    "trello",
    "010-prepare.R"
  ))

  create_local_package()
  generate_pkg(
    api_abbr = trello_config$api_abbr,
    api_definition = trello_api_definition,
    api_title = trello_config$api_title
  )

  prepare_result <- scrub_testpkg(readLines("R/010-prepare.R"))
  expect_identical(prepare_result, prepare_expected)
})

test_that("generate_pkg() can read values from config and rapid files", {
  skip_on_cran()
  config_text <- readLines(test_path("_fixtures", "guru", "_beekeeper.yml"))
  create_local_package()
  writeLines(config_text, "_beekeeper.yml")
  saveRDS(guru_api_definition, "_beekeeper_rapid.rds")

  expect_no_error(generate_pkg())
})
