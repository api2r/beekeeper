# Generate shared parameter docs

Generate shared parameter docs

## Usage

``` r
generate_pkg_shared_params(
  security_data = .read_security_data(pkg_dir, config_filename),
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
)
```

## Arguments

- security_data:

  (`list`) Generated security metadata.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`) The generated file path.
