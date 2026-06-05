# Generate one operation file

Generate one operation file

## Usage

``` r
.generate_paths_file(
  path_operation,
  operation_id,
  api_abbr,
  security_data,
  use_prefix = FALSE
)
```

## Arguments

- path_operation:

  (`list`) Template data for one operation.

- operation_id:

  (`character(1)`) The operation identifier used in generated file
  names.

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- security_data:

  (`list`) Generated security metadata.

- use_prefix:

  (`logical(1)`) Whether to include `api_abbr` as a prefix in generated
  path function names. When `FALSE` (the default), functions are named
  `{operation_id}` and `req_{operation_id}`. When `TRUE`, functions are
  named `{api_abbr}_{operation_id}` and `req_{api_abbr}_{operation_id}`.

## Value

(`character(1)`) The generated file path.
