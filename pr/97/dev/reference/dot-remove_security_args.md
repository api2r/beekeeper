# Remove security parameters

Remove security parameters

## Usage

``` r
.remove_security_args(params, security_args)
```

## Arguments

- params:

  (`list`) Parameter metadata for a single operation.

- security_args:

  (`character`) Security argument names to remove from operation
  parameters (because they are defined once, separately).

## Value

A `list` of non-security parameters.
