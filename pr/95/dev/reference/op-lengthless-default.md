# Default value for length 0

Default value for length 0

## Usage

``` r
x %|0|% y
```

## Arguments

- x:

  (`any`) Object to check.

- y:

  (`any`) Default value for `x`.

## Value

If `!length(x)`, will return `x`; otherwise returns `y`.

## See also

Other empty operators:
[`op-na-coalesce`](https://beekeeper.api2r.org/dev/reference/op-na-coalesce.md),
[`op-no-char-default`](https://beekeeper.api2r.org/dev/reference/op-no-char-default.md),
[`op-null-continuation`](https://beekeeper.api2r.org/dev/reference/op-null-continuation.md),
[`op-null-default`](https://beekeeper.api2r.org/dev/reference/op-null-default.md)
