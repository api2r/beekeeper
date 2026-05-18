# Read security schemes from an API definition

Read the security schemes from an API definition stored as a
[`rapid::class_rapid()`](https://rdrr.io/pkg/rapid/man/class_rapid.html)
object.

## Usage

``` r
read_security_schemes(
  pkg_dir = ".",
  rapid_filename = read_rapid_filename(pkg_dir)
)
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- rapid_filename:

  (`character(1)` or `fs_path`) The path to the R API definition (rapid)
  file (relative to the package root).

## Value

([`rapid::class_security_schemes`](https://rdrr.io/pkg/rapid/man/class_security_schemes.html))
Security schemes from the API definition.

## See also

Other config readers:
[`read_api_abbr()`](https://beekeeper.api2r.org/dev/reference/read_api_abbr.md),
[`read_api_definition()`](https://beekeeper.api2r.org/dev/reference/read_api_definition.md),
[`read_api_title()`](https://beekeeper.api2r.org/dev/reference/read_api_title.md),
[`read_config()`](https://beekeeper.api2r.org/dev/reference/read_config.md),
[`read_rapid_filename()`](https://beekeeper.api2r.org/dev/reference/read_rapid_filename.md),
[`read_security_data()`](https://beekeeper.api2r.org/dev/reference/read_security_data.md),
[`read_security_data_filename()`](https://beekeeper.api2r.org/dev/reference/read_security_data_filename.md)
