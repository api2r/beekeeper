# Interpolate glue with pipe braces

Interpolate glue with pipe braces

## Usage

``` r
.glue_pipe_brace(..., .envir = rlang::caller_env())
```

## Arguments

- ...:

  Expressions passed to
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html).

- .envir:

  (`environment`) The environment in which to evaluate `...`.

## Value

(`glue`) A glue object.
