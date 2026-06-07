# Get an origin field if it exists

Get an origin field if it exists

## Usage

``` r
.optional_origin_field(api_definition, field)
```

## Arguments

- api_definition:

  ([`rapid::class_rapid`](https://rapid.api2r.org/reference/class_rapid.html))
  The API definition to generate package code from.

- field:

  (`character`) The name of the field to extract.

## Value

(`any`, most likely `character(1)` or `NULL`) The value of the field, if
it exists in the `origin` property of the `info` property of
`api_definition` object.
