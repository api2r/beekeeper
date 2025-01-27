test_that(".generate_prepare() generates prepare file.", {
  skip_on_cran()
  config <- .read_config(test_path("_fixtures", "guru_beekeeper.yml"))
  api_definition <- readRDS(test_path("_fixtures", "guru_rapid.rds"))
  prepare_expected <- readLines(test_path("_fixtures", "guru-010-prepare.R"))
  t_prepare_expected <- readLines(test_path("_fixtures", "guru-test-010-prepare.R"))

  create_local_package()
  usethis::use_testthat()
  test_result <- .generate_prepare(config, api_definition, list())

  expect_identical(
    basename(test_result),
    c("010-prepare.R", "test-010-prepare.R")
  )

  prepare_result <- scrub_testpkg(readLines("R/010-prepare.R"))
  expect_identical(prepare_result, prepare_expected)
  t_prepare_result <- scrub_testpkg(readLines("tests/testthat/test-010-prepare.R"))
  expect_identical(t_prepare_result, t_prepare_expected)
})
