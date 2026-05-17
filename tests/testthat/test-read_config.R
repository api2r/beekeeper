test_that("read_config() reads configs", {
  config <- read_config(pkg_dir = test_path("_fixtures", "guru"))
  expect_s3_class(config$updated_on, c("POSIXlt", "POSIXt"))
  expect_snapshot({
    config
  })
})

test_that("read_api_definition() reads api_definitions", {
  api_definition <- read_api_definition(
    pkg_dir = test_path("_fixtures", "guru")
  )
  expect_s7_class(api_definition, rapid::class_rapid)
})
