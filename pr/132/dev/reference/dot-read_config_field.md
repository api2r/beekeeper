# Read a field from beekeeper config

Read a field from beekeeper config

## Usage

``` r
.read_config_field(field, pkg_dir, config_filename, default = NULL)
```

## Arguments

- field:

  (`character(1)`) The name of the config field to read.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- default:

  (`any`) Default value to return if `field` is not in the config.

## Value

(`any`) The value of the requested field, or `default` if not found.
