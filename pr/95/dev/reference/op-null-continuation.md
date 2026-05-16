# Default value for non-`NULL`

Default value for non-`NULL`

## Usage

``` r
x %&&% y
```

## Arguments

- x:

  (`any`) Object to check.

- y:

  (`any`) Default value for non-`NULL` `x`.

## Value

If `x` is `NULL`, will return `x`; otherwise returns `y`.

## See also

Other empty operators:
[`op-lengthless-default`](https://beekeeper.api2r.org/dev/reference/op-lengthless-default.md),
[`op-no-char-default`](https://beekeeper.api2r.org/dev/reference/op-no-char-default.md),
[`op-null-default`](https://beekeeper.api2r.org/dev/reference/op-null-default.md)
