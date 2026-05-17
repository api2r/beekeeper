# Convert one security scheme to a list

Convert one security scheme to a list

## Usage

``` r
.security_scheme_rotate(
  security_scheme_name,
  security_scheme_details,
  security_scheme_description
)
```

## Arguments

- security_scheme_name:

  (`character(1)`) The security scheme name.

- security_scheme_details:

  ([`rapid::class_security_scheme_details`](https://rapid.api2r.org/reference/class_security_scheme_details.html))
  The security scheme details.

- security_scheme_description:

  (`character(1)`) A security scheme description from the API
  definition.

## Value

(`list`) One security scheme description.
