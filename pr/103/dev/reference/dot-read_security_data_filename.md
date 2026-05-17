# Read saved security metadata filename

Read the `security_data_filename` field from a beekeeper config file.

## Usage

``` r
.read_security_data_filename(pkg_dir = ".", config_filename = "_beekeeper.yml")
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

## Value

(`character(1)`) The configured security metadata file path.
