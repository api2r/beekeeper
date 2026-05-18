test_that("use_beekeeper writes a yml config (#10)", {
  pkg_tempdir <- withr::local_tempdir()
  local_mocked_bindings(
    use_build_ignore = function(...) {
      invisible(TRUE)
    },
    with_project = function(...) {
      invisible(NULL)
    },
    .package = "usethis"
  )
  local_mocked_bindings(
    .assert_is_pkg = function(pkg_dir) {
      expect_identical(pkg_dir, pkg_tempdir)
      invisible(NULL)
    }
  )
  test_result <- use_beekeeper(
    guru_api_definition,
    api_abbr = "guru",
    pkg_dir = pkg_tempdir
  )
  expect_identical(test_result, fs::path(pkg_tempdir, "_beekeeper.yml"))
  reread_rapid <- readRDS(fs::path(pkg_tempdir, "_beekeeper_rapid.rds"))
  expect_identical(guru_api_definition, reread_rapid)
  test_result_file <- scrub_config(readLines(test_result))
  expected_result_file <- scrub_config(
    readLines(test_path("_fixtures", "guru", "_beekeeper.yml"))
  )
  expect_identical(test_result_file, expected_result_file)
})

test_that(".assert_config_exists errors informatively when config file is missing", {
  create_local_package()
  stbl::expect_pkg_error_snapshot(
    {
      .assert_config_exists(".", "_beekeeper.yml")
    },
    "beekeeper",
    "setup",
    "missing_config",
    transform = scrub_tempdir
  )
})
