# Determine whether generated paths need `stbl`

Determine whether generated paths need `stbl`

## Usage

``` r
.paths_need_stbl(paths, security_arg_names = character())
```

## Arguments

- paths:

  ([`rapid::class_paths`](https://rdrr.io/pkg/rapid/man/class_paths.html))
  API path definitions.

- security_arg_names:

  (`character`) Security argument names to exclude from generated
  operation signatures (because they are defined once, separately).

## Value

(`logical(1)`) `TRUE` if any path needs `stbl`.
