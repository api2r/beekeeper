# Default value for empty strings

Default value for empty strings

Default value for NA elements in vectors

## Usage

``` r
x %|a|% y

x %|% y
```

## Arguments

- x:

  (`any`) A vector that may contain `NA` elements.

- y:

  (`any`, coercible to the same class as `x`) A value or vector to
  replace `NA` elements in `x`. Will be recycled to the same length as
  `x`.

## Value

If `!nzchar(x)`, will return `y`; otherwise returns `x`.

A vector of the same length as `x`, where each `NA` element in `x` is
replaced by the corresponding element in `y`.

## See also

Other empty operators:
[`op-lengthless-default`](https://beekeeper.api2r.org/dev/reference/op-lengthless-default.md),
[`op-null-continuation`](https://beekeeper.api2r.org/dev/reference/op-null-continuation.md),
[`op-null-default`](https://beekeeper.api2r.org/dev/reference/op-null-default.md)
