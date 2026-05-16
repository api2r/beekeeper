# Generate files for all operations

Generate files for all operations

## Usage

``` r
.generate_paths_files(
  paths_by_operation,
  api_abbr,
  security_data,
  pagination_data
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

## Value

A `character` vector of generated file paths.
