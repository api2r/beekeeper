# Generate the prepare helper

Generate the prepare helper

## Usage

``` r
.generate_prepare_r(config, api_definition, security_data)
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

(`character(1)`) The generated file path.
