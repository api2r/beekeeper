# Write the rapid definition file

Write the rapid definition file

## Usage

``` r
.write_rapid(api_definition, rapid_filename, pkg_dir)
```

## Arguments

- api_definition:

  ([`rapid::class_rapid`](https://rdrr.io/pkg/rapid/man/class_rapid.html))
  The API definition to generate package code from.

- rapid_filename:

  (`character(1)` or `fs_path`) The path to the R API definition (rapid)
  file (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`) The written file path.
