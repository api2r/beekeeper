# Generate security files and metadata

Generate security files and metadata

## Usage

``` r
.generate_security(api_abbr, security_schemes)
```

## Arguments

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- security_schemes:

  ([`rapid::class_security_schemes`](https://rapid.api2r.org/reference/class_security_schemes.html))
  Security schemes from the API definition.

## Value

A `list` of generated security metadata.
