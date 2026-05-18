test_that(".assert_is_pkg() errors informatively for non-packages", {
  stbl::expect_pkg_error_snapshot(
    {
      .assert_is_pkg(tempdir())
    },
    "beekeeper",
    "setup",
    "not_a_package",
    transform = scrub_tempdir
  )
})

test_that(".assert_is_pkg() isn't obtrusive for packages", {
  create_local_package()
  expect_null({
    .assert_is_pkg()
  })
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

test_that(".maybe_use_stbl() can add stbl to imports (#69)", {
  local_mocked_bindings(
    .use_package = function(pkg, type, pkg_dir) {
      if (pkg == "stbl") {
        expect_equal(type, "Imports")
        expect_equal(pkg_dir, "DIR")
      }
      return(pkg)
    },
    .paths_need_stbl = function(paths, security_arg_names) {
      expect_equal(security_arg_names, "SECURITY_ARG_NAMES")
      return(paths == "INSTALL")
    }
  )
  expect_equal(
    .maybe_use_stbl("DIR", "INSTALL", "SECURITY_ARG_NAMES"),
    "stbl"
  )
  expect_null(
    .maybe_use_stbl("DIR", "DONOTINSTALL", "SECURITY_ARG_NAMES")
  )
})
