# Prepare parameter arguments

Prepare parameter arguments

## Usage

``` r
.prep_param_args(params, security_args)
```

## Arguments

- params:

  (`list`) Parameter metadata for a single operation.

- security_args:

  (`character`) Security argument names to remove from operation
  parameters (because they are defined once, separately).

## Value

(`character(1)`) A comma-separated named-argument string.
