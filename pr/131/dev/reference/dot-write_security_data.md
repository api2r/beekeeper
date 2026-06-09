# Write saved security metadata and update the config

Write saved security metadata and update the config

## Usage

``` r
.write_security_data(
  security_data,
  security_data_filename,
  config_filename,
  pkg_dir
)
```

## Arguments

- security_data:

  (`list`) Generated security metadata.

- security_data_filename:

  (`character(1)` or `fs_path`) The path to the saved security metadata
  file (relative to the package root).

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`) The saved security metadata filename.
