# .assert_is_pkg() errors informatively for non-packages

    Code
      .assert_is_pkg(tempdir())
    Condition
      Error in `.assert_is_pkg()`:
      ! Can't generate package files outside of a package.
      TMPDIR is not inside a package.

# .read_config() reads configs

    Code
      config
    Output
      $api_title
      [1] "APIs.guru"
      
      $api_abbr
      [1] "guru"
      
      $api_version
      [1] "2.2.0"
      
      $rapid_file
      [1] "_beekeeper_rapid.rds"
      
      $updated_on
      [1] "2026-05-12 07:57:02 UTC"
      

