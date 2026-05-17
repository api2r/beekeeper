# Generate authentication helpers

Generate authentication helpers

## Usage

``` r
generate_pkg_auth(
  api_abbr = read_api_abbr(pkg_dir, config_filename),
  security_schemes = read_security_schemes(pkg_dir, read_rapid_filename(pkg_dir,
    config_filename)),
  save_security_data = TRUE,
  security_data_filename = "_beekeeper_security.yml",
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
)
```

## Arguments

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- security_schemes:

  ([`rapid::class_security_schemes`](https://rapid.api2r.org/reference/class_security_schemes.html))
  Security schemes from the API definition.

- save_security_data:

  (`logical(1)`) Whether to save generated security metadata to a file
  and record that file in the beekeeper config.

- security_data_filename:

  (`character(1)` or `fs_path`) The path to the saved security metadata
  file (relative to the package root).

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`list`) Generated security metadata.
