# Build security argument help entries

Build security argument help entries

## Usage

``` r
.generate_security_arg_help(security_scheme_collection, security_args)
```

## Arguments

- security_scheme_collection:

  (`list`) Collected security scheme metadata.

- security_args:

  (`character`) Security argument names to remove from operation
  parameters (because they are defined once, separately).

## Value

A `list` of template-ready parameter help entries.
