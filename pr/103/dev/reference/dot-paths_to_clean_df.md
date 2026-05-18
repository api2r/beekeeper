# Convert API paths to an operations data frame

Convert API paths to an operations data frame

## Usage

``` r
.paths_to_clean_df(paths)
```

## Arguments

- paths:

  ([`rapid::class_paths`](https://rdrr.io/pkg/rapid/man/class_paths.html))
  API path definitions.

## Value

(`tibble`) A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with one row per non-deprecated operation.
