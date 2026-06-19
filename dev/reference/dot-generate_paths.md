# Generate files for API paths

Generate files for API paths

## Usage

``` r
.generate_paths(
  paths,
  api_abbr,
  security_data,
  pagination_data = list(),
  base_url,
  use_prefix = FALSE,
  exclude_from_response = character(),
  pkg_dir = "."
)
```

## Arguments

- paths:

  ([`rapid::class_paths`](https://rapid.api2r.org/reference/class_paths.html))
  API path definitions.

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- security_data:

  (`list`) Generated security metadata.

- pagination_data:

  (`list`) Pagination metadata used while generating path files.

- base_url:

  (`character(1)`) The base URL used in generated test helpers.

- use_prefix:

  (`logical(1)`) Whether to include `api_abbr` as a prefix in generated
  path function names. When `FALSE` (the default), functions are named
  `{operation_id}` and `req_{operation_id}`. When `TRUE`, functions are
  named `{api_abbr}_{operation_id}` and `req_{api_abbr}_{operation_id}`.

- exclude_from_response:

  (`character`) Field names to remove from response specs before
  generating parsers. Fields matching these names will be dropped from
  the response spec. If only one field remains after exclusion and it is
  of type `"df"`, `"row"`, or `"recursive"`, the spec is simplified so
  that the response parser targets that field directly.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character`) Generated file paths.
