# .assert_is_pkg() errors informatively for non-packages

    Code
      .assert_is_pkg(tempdir())
    Condition
      Error in `.assert_is_pkg()`:
      ! Can't generate package files outside of a package.
      TMPDIR is not inside a package.

