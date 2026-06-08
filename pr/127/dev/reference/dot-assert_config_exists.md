# Assert the beekeeper config file exists

Assert the beekeeper config file exists

## Usage

``` r
.assert_config_exists(pkg_dir, config_filename, call = caller_env())
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- call:

  (`environment`) The caller environment for error messages.

## Value

(`NULL`, invisibly) Called for side effect of asserting the config file
exists.
