# Flatten a data frame or list of data frames

Flatten a data frame or list of data frames

## Usage

``` r
.flatten_df(x, ...)

## S7 method for class <data.frame>
.flatten_df(x)

## S7 method for class <list>
.flatten_df(x)
```

## Arguments

- x:

  (`data.frame`, `list`, or `NULL`) The object to flatten.

- ...:

  Not used.

## Value

A single `data.frame`. Lists of data frames are flattened with
[`purrr::list_rbind()`](https://purrr.tidyverse.org/reference/list_c.html),
and `NULL` values are converted to empty data frames.
