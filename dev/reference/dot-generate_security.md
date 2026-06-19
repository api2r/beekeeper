# Generate security files and metadata

Generate security files and metadata

## Usage

``` r
.generate_security(api_abbr, security_schemes, pkg_dir = ".")
```

## Arguments

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- security_schemes:

  ([`rapid::class_security_schemes`](https://rapid.api2r.org/reference/class_security_schemes.html))
  Security schemes from the API definition.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`list`) Generated security metadata.
