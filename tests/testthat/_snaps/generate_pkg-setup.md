# .assert_is_pkg() errors informatively for non-packages

    Code
      (expect_pkg_error_classes({
        .assert_is_pkg(tempdir())
      }, "beekeeper", "setup", "not_a_package"))
    Output
      <error/beekeeper-error-setup-not_a_package>
      Error:
      ! Can't generate package files outside of a package.
      x TMPDIR is not inside a package.

