# Generate shared parameter docs

Generate the shared roxygen parameter definitions used across scaffolded
functions. This supports incremental package scaffolding when you want
to review or customize the shared parameter topic independently while
iterating on the rest of the generated package files.

## Usage

``` r
generate_pkg_shared_params(
  security_data = read_security_data(pkg_dir, "_beekeeper.yml"),
  pkg_dir = "."
)
```

## Arguments

- security_data:

  (`list`) Generated security metadata.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`) The generated file path. As a side effect,
`R/000-shared.R` is generated.

## See also

Other package generation functions:
[`generate_pkg()`](https://beekeeper.api2r.org/dev/reference/generate_pkg.md),
[`generate_pkg_auth()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_auth.md),
[`generate_pkg_paths()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_paths.md),
[`generate_pkg_req_prepare()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_req_prepare.md)
