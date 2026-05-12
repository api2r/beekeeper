test_that(".generate_paths() generates path files", {
  # 1 tag, no security
  skip_on_cran()
  skip_on_covr()
  config <- .read_config(test_path("_fixtures", "guru", "_beekeeper.yml"))
  api_definition <- readRDS(test_path(
    "_fixtures",
    "guru",
    "_beekeeper_rapid.rds"
  ))

  api_abbr <- "guru"
  expected_path_contents <- load_expected_files(
    api_abbr,
    paste0("/paths-.+\\.R$")
  )
  expected_test_contents <- load_expected_files(
    api_abbr,
    paste0("/test-paths-.+\\.R$")
  )

  create_local_package()
  usethis::use_testthat()

  # 7 operations all in "apis" tag -> 7 R files + 1 test file + setup
  test_result <- .generate_paths(
    paths = api_definition@paths,
    api_abbr = config$api_abbr,
    security_data = list(),
    base_url = api_definition@servers@url
  )
  expect_identical(
    basename(test_result),
    c(
      "paths-apis-list_apis.R",
      "paths-apis-get_metrics.R",
      "paths-apis-get_providers.R",
      "paths-apis-get_api.R",
      "paths-apis-get_service_api.R",
      "paths-apis-get_provider.R",
      "paths-apis-get_services.R",
      "test-paths-apis.R",
      "setup.R"
    )
  )

  purrr::iwalk(expected_path_contents, \(expected, name) {
    expect_identical(readLines(file.path("R", name)), expected)
  })

  purrr::iwalk(expected_test_contents, \(expected, name) {
    expect_identical(readLines(file.path("tests", "testthat", name)), expected)
  })
})

test_that("generate_pkg() generates path tests for guru", {
  # 1 tag, no security
  skip_on_cran()
  skip_on_covr()
  config <- readLines(test_path("_fixtures", "guru", "_beekeeper.yml"))
  guru_rapid <- readRDS(test_path("_fixtures", "guru", "_beekeeper_rapid.rds"))
  expected_file_content <- readLines(
    test_path("_fixtures", "guru", "test-paths-apis.R")
  )

  create_local_package()
  writeLines(config, "_beekeeper.yml")
  saveRDS(guru_rapid, "_beekeeper_rapid.rds")
  generate_pkg()

  generated_file_content <- readLines("tests/testthat/test-paths-apis.R")
  expect_identical(generated_file_content, expected_file_content)
})

test_that("generate_pkg() generates test setup file for guru", {
  # 1 tag, no security
  skip_on_cran()
  config <- readLines(test_path("_fixtures", "guru", "_beekeeper.yml"))
  guru_rapid <- readRDS(test_path("_fixtures", "guru", "_beekeeper_rapid.rds"))
  expected_file_content <- readLines(
    test_path("_fixtures", "guru", "setup.R")
  )

  create_local_package()
  writeLines(config, "_beekeeper.yml")
  saveRDS(guru_rapid, "_beekeeper_rapid.rds")
  generate_pkg()
  generated_file_content <- readLines("tests/testthat/setup.R")
  expect_identical(generated_file_content, expected_file_content)
})

test_that("generate_pkg() generates path functions for fec", {
  # 3 tags (audit, debts, legal), more complicated security
  skip_on_cran()
  config <- readLines(test_path("_fixtures", "fec", "fec_subset_beekeeper.yml"))
  fec_rapid <- readRDS(test_path("_fixtures", "fec", "fec_subset_rapid.rds"))
  expected_file_content <- readLines(
    test_path(
      "_fixtures",
      "fec",
      "paths-audit-get_names_audit_candidates.R"
    )
  )

  create_local_package()
  writeLines(config, "_beekeeper.yml")
  saveRDS(fec_rapid, "fec_subset_rapid.rds")

  changed_files <- generate_pkg()
  expect_snapshot(scrub_path(changed_files))

  generated_file_content <- readLines(
    "R/paths-audit-get_names_audit_candidates.R"
  )
  expect_identical(generated_file_content, expected_file_content)
})

test_that("generate_pkg() generates path functions for trello", {
  # some tags failed before this, more complicated security
  skip_on_cran()
  skip_on_covr()
  config <- readLines(test_path("_fixtures", "trello", "_beekeeper.yml"))
  trello_rapid <- readRDS(test_path(
    "_fixtures",
    "trello",
    "_beekeeper_rapid.rds"
  ))
  expected_file_content <- readLines(
    test_path("_fixtures", "trello", "paths-board-add_boards.R")
  )

  create_local_package()
  writeLines(config, "_beekeeper.yml")
  saveRDS(trello_rapid, "_beekeeper_rapid.rds")

  generate_pkg()
  generated_file_content <- readLines("R/paths-board-add_boards.R")
  expect_identical(generated_file_content, expected_file_content)
})
