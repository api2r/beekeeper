# Write the beekeeper config file

Write the beekeeper config file

## Usage

``` r
.write_config(
  api_definition,
  api_abbr,
  rapid_filename,
  config_filename,
  pkg_dir
)
```

## Arguments

- api_definition:

  ([`rapid::class_rapid`](https://rdrr.io/pkg/rapid/man/class_rapid.html))
  The API definition to generate package code from.

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- rapid_filename:

  (`character(1)` or `fs_path`) The path to the R API definition (rapid)
  file (relative to the package root).

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`) The written config file path.
