# .assert_config_exists errors informatively when config file is missing

    Code
      (expect_pkg_error_classes({
        .assert_config_exists(".", "_beekeeper.yml")
      }, "beekeeper", "setup", "missing_config"))
    Output
      <error/beekeeper-error-setup-missing_config>
      Error:
      ! No beekeeper configuration found.
      i Expected to find a config file at TMPDIR
      i Use `beekeeper::use_beekeeper()` to create a configuration.

