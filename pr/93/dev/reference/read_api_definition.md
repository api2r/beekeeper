# Read an API definition file

Read an API definition file

## Usage

``` r
read_api_definition(pkg_dir = ".", rapid_file = "_beekeeper_rapid.rds")
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- rapid_file:

  (`character(1)` or `fs_path`) The path to the R API definition (rapid)
  file.

## Value

A
[`rapid::class_rapid()`](https://rapid.api2r.org/reference/class_rapid.html)
with the definition of the API.
