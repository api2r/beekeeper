# Default value for `NULL`

Default value for `NULL`

## Usage

``` r
x %||% y
```

## Arguments

- x:

  (`any`) The object to check or coerce.

- y:

  (`any`) The default value.

## Value

If `x` is `NULL`, will return `y`; otherwise returns `x`.

## See also

Other empty operators:
[`op-lengthless-default`](https://beekeeper.api2r.org/dev/reference/op-lengthless-default.md),
[`op-na-coalesce`](https://beekeeper.api2r.org/dev/reference/op-na-coalesce.md),
[`op-no-char-default`](https://beekeeper.api2r.org/dev/reference/op-no-char-default.md),
[`op-null-continuation`](https://beekeeper.api2r.org/dev/reference/op-null-continuation.md)
