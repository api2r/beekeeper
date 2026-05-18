# Generate prepare files

Generate prepare files

## Usage

``` r
.generate_prepare(config, api_definition, security_data)
```

## Arguments

- config:

  (`list`) Package-generation configuration data.

- api_definition:

  ([`rapid::class_rapid`](https://rdrr.io/pkg/rapid/man/class_rapid.html))
  The API definition to generate package code from.

- security_data:

  (`list`) Generated security metadata.

## Value

(`character`) Generated file paths.
