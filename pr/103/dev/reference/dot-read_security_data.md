# Read saved security metadata

Read saved security metadata

## Usage

``` r
.read_security_data(
  pkg_dir = ".",
  config_filename = "_beekeeper.yml",
  security_data_filename = .read_security_data_filename(pkg_dir, config_filename)
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
