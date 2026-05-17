# Generate request-prepare helpers

Generate request-prepare helpers

## Usage

``` r
generate_pkg_req_prepare(
  api_abbr = read_api_abbr(pkg_dir, config_filename),
  api_definition = read_api_definition(pkg_dir, read_rapid_filename(pkg_dir,
    config_filename)),
  api_title = read_api_title(pkg_dir, config_filename),
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

- api_title:

  (`character(1)`) The API title used in generated package files.

- security_data:

  (`list`) Generated security metadata.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character`) Generated file paths.
