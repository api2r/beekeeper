# Generate one operation file

Generate one operation file

## Usage

``` r
.generate_paths_file(path_operation, operation_id, api_abbr, security_data)
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

## Value

(`character(1)`) The generated file path.
