# Error if not in package

Error if not in package

## Usage

``` r
.assert_is_pkg(pkg_dir = usethis::proj_get(), call = caller_env())
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- call:

  (`environment`) The caller environment for error messages.

## Value

(`NULL`, invisibly) Called for error side effect.
