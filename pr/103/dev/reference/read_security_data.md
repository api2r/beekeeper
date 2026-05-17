# Read saved security metadata

Read prepared security metadata from a YAML file (default name
`_beekeeper_security.yml`) generated via
[`generate_pkg_auth()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_auth.md).

## Usage

``` r
read_security_data(
  pkg_dir = ".",
  config_filename = "_beekeeper.yml",
  security_data_filename = read_security_data_filename(pkg_dir, config_filename)
)
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- security_data_filename:

  (`character(1)` or `fs_path`) The path to the saved security metadata
  file (relative to the package root).

## Value

(`list`) Saved security metadata.

## See also

Other config readers:
[`read_api_abbr()`](https://beekeeper.api2r.org/dev/reference/read_api_abbr.md),
[`read_api_definition()`](https://beekeeper.api2r.org/dev/reference/read_api_definition.md),
[`read_api_title()`](https://beekeeper.api2r.org/dev/reference/read_api_title.md),
[`read_config()`](https://beekeeper.api2r.org/dev/reference/read_config.md),
[`read_rapid_filename()`](https://beekeeper.api2r.org/dev/reference/read_rapid_filename.md),
[`read_security_data_filename()`](https://beekeeper.api2r.org/dev/reference/read_security_data_filename.md),
[`read_security_schemes()`](https://beekeeper.api2r.org/dev/reference/read_security_schemes.md)
