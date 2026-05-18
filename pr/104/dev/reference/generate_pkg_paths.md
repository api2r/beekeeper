# Generate files for API paths

Generate operation functions and their tests from the API paths stored
in the OpenAPI definition. This supports incremental package scaffolding
when you want to review or customize endpoint wrappers separately from
other package components.

## Usage

``` r
generate_pkg_paths(
  api_abbr = read_api_abbr(pkg_dir, config_filename),
  api_definition = read_api_definition(pkg_dir, read_rapid_filename(pkg_dir,
    config_filename)),
  security_data = read_security_data(pkg_dir, config_filename),
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
)
```

## Arguments

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- api_definition:

  ([`rapid::class_rapid`](https://rapid.api2r.org/reference/class_rapid.html))
  The API definition to generate package code from.

- security_data:

  (`list`) Generated security metadata.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character`) Generated file paths. As a side effect, zero or more
`R/paths-*.R` files are generated from the paths in the
`api_definition`, as well as the associated test files as
`tests/testthat/test-paths-*.R`.

## See also

Other package generation functions:
[`generate_pkg()`](https://beekeeper.api2r.org/dev/reference/generate_pkg.md),
[`generate_pkg_auth()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_auth.md),
[`generate_pkg_req_prepare()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_req_prepare.md),
[`generate_pkg_shared_params()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_shared_params.md)
