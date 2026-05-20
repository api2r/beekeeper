# Default value for empty strings

Default value for empty strings

## Usage

``` r
x %|a|% y
```

## Arguments

- x:

  (`any`) The object to check or coerce.

- y:

  (`character`) The default value.

## Value

(`character`) If `!nzchar(x)`, returns `y`; otherwise returns `x`.

## See also

Other empty operators:
[`op-lengthless-default`](https://beekeeper.api2r.org/reference/op-lengthless-default.md),
[`op-na-coalesce`](https://beekeeper.api2r.org/reference/op-na-coalesce.md),
[`op-null-continuation`](https://beekeeper.api2r.org/reference/op-null-continuation.md),
[`op-null-default`](https://beekeeper.api2r.org/reference/op-null-default.md)
