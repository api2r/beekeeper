test_that("config writes a yml", {
  local_mocked_bindings(
    use_build_ignore = function(...) {
      invisible(TRUE)
    },
    .package = "usethis"
  )
  config_path <- withr::local_tempfile(fileext = ".yml")
  rapid_write_path <- withr::local_tempfile(fileext = ".rds")
  test_result <- use_beekeeper(
    guru_api_definition,
    api_abbr = "guru",
    config_file = config_path,
    rapid_file = rapid_write_path
  )
  expect_identical(test_result, config_path)
  reread_rapid <- readRDS(rapid_write_path)
  expect_identical(guru_api_definition, reread_rapid)
  test_result_file <- scrub_config(readLines(config_path))
  expected_result_file <- scrub_config(
    readLines(test_path("_fixtures", "guru", "_beekeeper.yml"))
  )
  expect_identical(test_result_file, expected_result_file)
})
