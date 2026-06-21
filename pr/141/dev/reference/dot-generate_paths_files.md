# Generate files for all operations

Generate files for all operations

## Usage

``` r
.generate_paths_files(
  paths_by_operation,
  api_abbr,
  security_data,
  pagination_data,
  use_prefix = FALSE,
  pkg_dir = "."
)
```

## Arguments

- paths_by_operation:

  (`list`) Template-ready operations keyed by operation identifier.

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- security_data:

  (`list`) Generated security metadata.

- pagination_data:

  (`list`) Pagination metadata used while generating path files.

- use_prefix:

  (`logical(1)`) Whether to include `api_abbr` as a prefix in generated
  path function names. When `FALSE` (the default), functions are named
  `{operation_id}` and `req_{operation_id}`. When `TRUE`, functions are
  named `{api_abbr}_{operation_id}` and `req_{api_abbr}_{operation_id}`.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character`) Generated file paths.
