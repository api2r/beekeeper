# Generate files for API paths

Generate files for API paths

## Usage

``` r
.generate_paths(
  paths,
  api_abbr,
  security_data,
  pagination_data = list(),
  base_url
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

## Value

(`character`) Generated file paths.
