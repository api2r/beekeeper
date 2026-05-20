# Default value for NA elements in vectors

Default value for NA elements in vectors

## Usage

``` r
x %|% y
```

## Arguments

- x:

  (`any`) The object to check or coerce.

- y:

  (`any`, coercible to the same class as `x`) A value or vector to
  replace `NA` elements in `x`. Will be recycled to the same length as
  `x`.

## Value

(`vector`) A vector of the same length as `x`, where each `NA` element
in `x` is replaced by the corresponding element in `y`.

## See also

Other empty operators:
[`op-lengthless-default`](https://beekeeper.api2r.org/reference/op-lengthless-default.md),
[`op-no-char-default`](https://beekeeper.api2r.org/reference/op-no-char-default.md),
[`op-null-continuation`](https://beekeeper.api2r.org/reference/op-null-continuation.md),
[`op-null-default`](https://beekeeper.api2r.org/reference/op-null-default.md)
