# Default value for length 0

Default value for length 0

## Usage

``` r
x %|0|% y
```

## Arguments

- x:

  (`any`) The object to check or coerce.

- y:

  (`any`) The default value.

## Value

(`any`) If `!length(x)`, returns `x`; otherwise returns `y`.

## See also

Other empty operators:
[`op-na-coalesce`](https://beekeeper.api2r.org/reference/op-na-coalesce.md),
[`op-no-char-default`](https://beekeeper.api2r.org/reference/op-no-char-default.md),
[`op-null-continuation`](https://beekeeper.api2r.org/reference/op-null-continuation.md),
[`op-null-default`](https://beekeeper.api2r.org/reference/op-null-default.md)
