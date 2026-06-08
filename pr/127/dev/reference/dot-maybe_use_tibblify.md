# Add tibblify to dependencies if needed

Add tibblify to dependencies if needed

## Usage

``` r
.maybe_use_tibblify(pkg_dir, paths)
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- paths:

  ([`rapid::class_paths`](https://rapid.api2r.org/reference/class_paths.html))
  API path definitions.

## Value

(`character(1)` or `NULL`, invisibly) "tibblify" if tibblify is used,
`NULL` otherwise.
