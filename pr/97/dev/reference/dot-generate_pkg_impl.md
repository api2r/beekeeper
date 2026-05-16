# Generate package files from prepared inputs

Generate package files from prepared inputs

## Usage

``` r
.generate_pkg_impl(config, api_definition, security_data)
```

## Arguments

- config:

  (`list`) Package-generation configuration data.

- api_definition:

  ([`rapid::class_rapid`](https://rapid.api2r.org/reference/class_rapid.html))
  The API definition to generate package code from.

- security_data:

  (`list`) Generated security metadata.

## Value

A `character` vector of generated file paths, invisibly.
