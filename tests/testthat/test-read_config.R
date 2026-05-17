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
