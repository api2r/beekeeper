# Write the beekeeper config file

Write the beekeeper config file

## Usage

``` r
.write_config(api_definition, api_abbr, rapid_file, config_file)
```

## Arguments

- api_definition:

  ([`rapid::class_rapid`](https://rapid.api2r.org/reference/class_rapid.html))
  The API definition to generate package code from.

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- rapid_file:

  (`character(1)` or `fs_path`) The path to the R API definition (rapid)
  file.

- config_file:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config
  file.

## Value

(`character(1)`) The written config file path.
