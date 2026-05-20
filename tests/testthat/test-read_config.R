test_that("read_config() reads configs (#82)", {
  withr::defer(memoise::forget(read_config))
  config <- read_config(pkg_dir = test_path("_fixtures", "guru"))
  expect_s3_class(config$updated_on, c("POSIXlt", "POSIXt"))
  expect_snapshot({
    config
  })
})

test_that("read_api_definition() reads api definitions (#82)", {
  withr::defer(memoise::forget(read_config))
  expect_s7_class(
    read_api_definition(test_path("_fixtures", "guru")),
    rapid::class_rapid
  )
})

test_that("read_api_abbr() reads api abbrs (#99)", {
  withr::defer(memoise::forget(read_config))
  expect_equal(read_api_abbr(test_path("_fixtures", "guru")), "guru")
})

test_that("read_api_title() reads api titles (#99)", {
  withr::defer(memoise::forget(read_config))
  expect_equal(read_api_title(test_path("_fixtures", "guru")), "APIs.guru")
})

test_that("read_security_schemes() reads security schemes (#101)", {
  withr::defer(memoise::forget(read_config))
  result <- read_security_schemes(test_path("_fixtures", "trello"))
  expect_s7_class(result, rapid::class_security_schemes)
  expect_identical(
    result@name,
    trello_api_definition@components@security_schemes@name
  )
})

test_that("read_security_data_filename() defaults when config omits it (#101)", {
  withr::defer(memoise::forget(read_config))
  expect_identical(
    read_security_data_filename(test_path("_fixtures", "guru")),
    "_beekeeper_security.yml"
  )
})

test_that("read_security_data_filename() reads configured filenames (#101)", {
  withr::defer(memoise::forget(read_config))
  pkg_dir <- withr::local_tempdir()
  config_text <- c(
    readLines(test_path("_fixtures", "guru", "_beekeeper.yml")),
    "security_data_filename: custom_security.yml"
  )
  writeLines(config_text, fs::path(pkg_dir, "_beekeeper.yml"))
  expect_identical(read_security_data_filename(pkg_dir), "custom_security.yml")
})

test_that("read_security_data() reads saved security data (#101)", {
  withr::defer(memoise::forget(read_config))
  result <- read_security_data(fs::path_package("beekeeper", "trello"))
  expect_true(result$has_security)
  expect_identical(result$security_arg_names, c("key", "token"))
})

test_that("read_security_data() returns empty list for missing files (#101)", {
  withr::defer(memoise::forget(read_config))
  expect_identical(read_security_data(test_path("_fixtures", "guru")), list())
})
