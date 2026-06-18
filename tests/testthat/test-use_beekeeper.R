test_that("use_beekeeper writes a yml config (#10, #108)", {
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
  config <- yaml::read_yaml(test_result)
  expect_identical(
    config$api_definition_origin,
    list(
      url = "https://api.apis.guru/v2/openapi.yaml",
      format = "openapi",
      version = "3.0"
    )
  )
  test_result_file <- scrub_config(readLines(test_result))
  expected_result_file <- scrub_config(
    readLines(test_path("_fixtures", "guru", "_beekeeper.yml"))
  )
  # With just use_beekeeper(), the result won't have security info yet.
  expected_result_file <- stringr::str_subset(
    expected_result_file,
    "^security_data_filename",
    negate = TRUE
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

test_that(".write_config_field() updates an existing config file (#101)", {
  withr::defer(memoise::forget(read_config))
  create_local_package()
  local_mocked_bindings(
    use_build_ignore = function(...) {
      invisible(TRUE)
    },
    with_project = function(...) {
      invisible(NULL)
    },
    .package = "usethis"
  )

  use_beekeeper(guru_api_definition, api_abbr = "guru")
  expect_null(read_config()[["security_data_filename"]])

  result <- .write_config_field(
    field = "security_data_filename",
    value = "custom_security.yml",
    config_filename = "_beekeeper.yml",
    pkg_dir = "."
  )

  expect_identical(result, "_beekeeper.yml")
  expect_identical(
    read_security_data_filename(pkg_dir = ".", config_filename = result),
    "custom_security.yml"
  )
})
