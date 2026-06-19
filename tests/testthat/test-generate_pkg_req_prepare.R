test_that(".generate_prepare() generates prepare file.", {
  skip_on_cran()
  config <- guru_config
  api_definition <- guru_api_definition
  prepare_expected <- readLines(test_path(
    "_fixtures",
    "guru",
    "R",
    "010-prepare.R"
  ))
  t_prepare_expected <- readLines(test_path(
    "_fixtures",
    "guru",
    "tests",
    "testthat",
    "test-010-prepare.R"
  ))

  create_local_package()
  usethis::use_testthat()
  test_result <- .generate_prepare(config, api_definition, list())

  expect_identical(
    basename(test_result),
    c("010-prepare.R", "test-010-prepare.R")
  )

  prepare_result <- scrub_testpkg(readLines("R/010-prepare.R"))
  expect_identical(prepare_result, prepare_expected)
  t_prepare_result <- scrub_testpkg(readLines(
    "tests/testthat/test-010-prepare.R"
  ))
  expect_identical(t_prepare_result, t_prepare_expected)
})

test_that("generate_pkg_req_prepare() reads saved inputs from config (#101)", {
  skip_on_cran()
  config_text <- readLines(test_path("_fixtures", "trello", "_beekeeper.yml"))
  prepare_expected <- readLines(test_path(
    "_fixtures",
    "trello",
    "R",
    "010-prepare.R"
  ))

  create_local_package()
  writeLines(config_text, "_beekeeper.yml")
  saveRDS(trello_api_definition, "_beekeeper_rapid.rds")
  generate_pkg_auth()

  test_result <- generate_pkg_req_prepare()

  expect_identical(
    basename(test_result),
    c("010-prepare.R", "test-010-prepare.R")
  )
  expect_identical(
    scrub_testpkg(readLines("R/010-prepare.R")),
    prepare_expected
  )
})
