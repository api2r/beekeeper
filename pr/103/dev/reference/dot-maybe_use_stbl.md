# Add stbl to dependencies if needed

Add stbl to dependencies if needed

## Usage

``` r
.maybe_use_stbl(pkg_dir, paths, security_arg_names)
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- paths:

  ([`rapid::class_paths`](https://rdrr.io/pkg/rapid/man/class_paths.html))
  API path definitions.

- security_arg_names:

  (`character`) Security argument names to exclude from generated
  operation signatures (because they are defined once, separately).

## Value

(`character(1)` or `NULL`, invisibly) "stbl" if stbl is used, `NULL`
otherwise.
