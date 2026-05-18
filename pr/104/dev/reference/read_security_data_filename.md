# Read saved security metadata filename

Read the `security_data_filename` field from a beekeeper config file.

## Usage

``` r
read_security_data_filename(pkg_dir = ".", config_filename = "_beekeeper.yml")
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

## Value

(`character(1)`) The configured security metadata file path.

## See also

Other config readers:
[`read_api_abbr()`](https://beekeeper.api2r.org/dev/reference/read_api_abbr.md),
[`read_api_definition()`](https://beekeeper.api2r.org/dev/reference/read_api_definition.md),
[`read_api_title()`](https://beekeeper.api2r.org/dev/reference/read_api_title.md),
[`read_config()`](https://beekeeper.api2r.org/dev/reference/read_config.md),
[`read_rapid_filename()`](https://beekeeper.api2r.org/dev/reference/read_rapid_filename.md),
[`read_security_data()`](https://beekeeper.api2r.org/dev/reference/read_security_data.md),
[`read_security_schemes()`](https://beekeeper.api2r.org/dev/reference/read_security_schemes.md)

## Examples

``` r
read_security_data_filename(
  pkg_dir = fs::path_package("beekeeper"),
  config_filename = "example_config.yml"
)
#> [1] "example_security_data.yml"
```
