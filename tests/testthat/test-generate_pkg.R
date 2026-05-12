test_that("generate_pkg() returns a vector of created files", {
  skip_on_cran()
  config_text <- readLines(test_path("_fixtures", "guru", "_beekeeper.yml"))
  api_definition <- readRDS(test_path(
    "_fixtures",
    "guru",
    "_beekeeper_rapid.rds"
  ))

  test_dir <- create_local_package()
  writeLines(config_text, "_beekeeper.yml")
  saveRDS(api_definition, "_beekeeper_rapid.rds")

  test_result <- generate_pkg()
  test_result <- scrub_path(test_result)
  # 7 guru operations all in "apis" tag: 7 R files + 1 test file + setup
  expected_result <- c(
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
  config_text <- readLines(test_path(
    "_fixtures",
    "trello",
    "_beekeeper.yml"
  ))
  api_definition <- readRDS(test_path(
    "_fixtures",
    "trello",
    "_beekeeper_rapid.rds"
  ))
  prepare_expected <- readLines(test_path(
    "_fixtures",
    "trello",
    "010-prepare.R"
  ))

  create_local_package()
  writeLines(config_text, "_beekeeper.yml")
  saveRDS(api_definition, "_beekeeper_rapid.rds")

  generate_pkg()

  prepare_result <- scrub_testpkg(readLines("R/010-prepare.R"))
  expect_identical(prepare_result, prepare_expected)
})
