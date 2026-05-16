# Read a beekeeper config file

Read a beekeeper config file

## Usage

``` r
read_config(pkg_dir = ".", config_file = "_beekeeper.yml")
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- config_file:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config
  file.

## Value

A `list` of configuration information, with elements `api_title`,
`api_abbr`, `api_version`, `rapid_file`, and `updated_on`.
