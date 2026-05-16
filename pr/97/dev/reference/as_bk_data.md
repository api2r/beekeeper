# Prepare rapid objects for beekeeper

Convert `rapid` objects to lists of properties to use in beekeeper
templates.

## Usage

``` r
as_bk_data(x, ...)

## S7 method for class <any>
as_bk_data(x, ...)

## S7 method for class <rapid::paths>
as_bk_data(x, ...)

## S7 method for class <rapid::security_schemes>
as_bk_data(x, ...)

## S7 method for class <rapid::security_scheme_details>
as_bk_data(x, ...)

## S7 method for class <rapid::api_key_security_scheme>
as_bk_data(x, ...)
```

## Arguments

- x:

  The object to coerce.

- ...:

  These dots are for future extensions and must be empty.

## Value

A list.
