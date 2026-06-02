# Update one config field

Update one config field

## Usage

``` r
.write_config_field(field, value, config_filename, pkg_dir)
```

## Arguments

- field:

  (`character(1)`) The config field to write.

- value:

  (`character(1)`) The value to write.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`) The written config filename.
