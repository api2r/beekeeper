# Default value for empty strings

Default value for empty strings

## Usage

``` r
x %|a|% y
```

## Arguments

- x:

  (`any`) Object to check.

- y:

  (`character`) Default value for `x`.

- x_arg:

  (`character(1)`) The name of the `x` argument for error messages.

- call:

  (`environment`) The caller environment for error messages.

## Value

If `!nzchar(x)`, will return `y`; otherwise returns `x`.

## See also

Other empty operators:
[`op-lengthless-default`](https://beekeeper.api2r.org/dev/reference/op-lengthless-default.md),
[`op-na-coalesce`](https://beekeeper.api2r.org/dev/reference/op-na-coalesce.md),
[`op-null-continuation`](https://beekeeper.api2r.org/dev/reference/op-null-continuation.md),
[`op-null-default`](https://beekeeper.api2r.org/dev/reference/op-null-default.md)
