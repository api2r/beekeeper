# Generate a security argument signature

Generate a security argument signature

## Usage

``` r
.generate_security_signature(security_arg_names, api_abbr)
```

## Arguments

- security_arg_names:

  (`character`) Security argument names to exclude from generated
  operation signatures.

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

## Value

(`character(1)`) A function-signature fragment.
