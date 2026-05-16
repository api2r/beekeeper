test_that(".assert_is_pkg() errors informatively for non-packages", {
  expect_snapshot(
    .assert_is_pkg(tempdir()),
    error = TRUE,
    transform = scrub_tempdir
  )
})

test_that(".assert_is_pkg() isn't obtrusive for packages", {
  create_local_package()
  expect_null({
    .assert_is_pkg()
  })
})

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

test_that(".setup_r() sets up dependencies (#16)", {
  skip_on_cran()

  create_local_package()
  .setup_r(".")

  dependencies <- desc::desc()$get_deps()
  expect_identical(
    dependencies$package[dependencies$type == "Imports"],
    "nectar"
  )
  expect_contains(
    dependencies$package[dependencies$type == "Suggests"],
    "beekeeper"
  )
  expect_contains(
    dependencies$package[dependencies$type == "Suggests"],
    "httptest2"
  )
  expect_contains(
    dependencies$package[dependencies$type == "Suggests"],
    "testthat"
  )
})

test_that(".setup_r() can include stbl in imports (#69)", {
  skip_on_cran()

  create_local_package()
  .setup_r(".", include_stbl = TRUE)

  dependencies <- desc::desc()$get_deps()
  imports <- dependencies$package[dependencies$type == "Imports"]
  expect_contains(imports, "nectar")
  expect_contains(imports, "stbl")
})
