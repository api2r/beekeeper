# Check whether we're in a package

Inspired by usethis:::is_package.

## Usage

``` r
.is_pkg(pkg_dir = usethis::proj_get())
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`logical(1)`) `TRUE` if the project is a package, `FALSE` if not.
