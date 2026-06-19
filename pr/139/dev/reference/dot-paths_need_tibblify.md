# Determine whether generated paths need `tibblify`

Determine whether generated paths need `tibblify`

## Usage

``` r
.paths_need_tibblify(paths)
```

## Arguments

- paths:

  ([`rapid::class_paths`](https://rapid.api2r.org/reference/class_paths.html))
  API path definitions.

## Value

(`logical(1)`) `TRUE` if any path has a JSON response spec.
