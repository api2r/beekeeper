# .pkg_abort works

    Code
      (expect_pkg_error_classes(.pkg_abort("This is a test error", c("subclass",
        "test_error")), "beekeeper", "subclass", "test_error"))
    Output
      <error/beekeeper-error-subclass-test_error>
      Error:
      ! This is a test error

