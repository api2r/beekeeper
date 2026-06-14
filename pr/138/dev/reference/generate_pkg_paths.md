# Generate files for API paths

Generate operation functions and their tests from the API paths stored
in the OpenAPI definition. This supports incremental package scaffolding
when you want to review or customize endpoint wrappers separately from
other package components.

## Usage

``` r
generate_pkg_paths(
  api_abbr = read_api_abbr(pkg_dir, config_filename),
  api_definition = read_api_definition(pkg_dir, read_rapid_filename(pkg_dir,
    config_filename)),
  security_data = read_security_data(pkg_dir, config_filename),
  use_prefix = FALSE,
  exclude_from_response = character(),
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
)
```

## Arguments

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- api_definition:

  ([`rapid::class_rapid`](https://rapid.api2r.org/reference/class_rapid.html))
  The API definition to generate package code from.

- security_data:

  (`list`) Generated security metadata.

- use_prefix:

  (`logical(1)`) Whether to include `api_abbr` as a prefix in generated
  path function names. When `FALSE` (the default), functions are named
  `{operation_id}` and `req_{operation_id}`. When `TRUE`, functions are
  named `{api_abbr}_{operation_id}` and `req_{api_abbr}_{operation_id}`.

- exclude_from_response:

  (`character`) Field names to remove from response specs before
  generating parsers. Fields matching these names will be dropped from
  the response spec. If only one field remains after exclusion and it is
  of type `"df"`, `"row"`, or `"recursive"`, the spec is simplified so
  that the response parser targets that field directly.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character`) Generated file paths. As a side effect, zero or more
`R/paths-*.R` files are generated from the paths in the
`api_definition`, as well as the associated test files as
`tests/testthat/test-paths-*.R`.

## See also

Other package generation functions:
[`generate_pkg()`](https://beekeeper.api2r.org/dev/reference/generate_pkg.md),
[`generate_pkg_auth()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_auth.md),
[`generate_pkg_req_prepare()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_req_prepare.md),
[`generate_pkg_shared_params()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_shared_params.md)

## Examples

``` r
# Set up an empty package.
pkg_dir <- unclass(fs::path_norm(withr::local_tempdir()))
usethis::create_package(pkg_dir, open = FALSE, check_name = FALSE)
#> ✔ Creating /tmp/Rtmpn6Dnyp/file5791f984346/.
#> ✔ Setting active project to "/tmp/Rtmpn6Dnyp/file5791f984346".
#> ✔ Creating R/.
#> ✔ Writing DESCRIPTION.
#> Package: file5791f984346
#> Title: What the Package Does (One Line, Title Case)
#> Version: 0.0.0.9000
#> Authors@R (parsed):
#>     * First Last <first.last@example.com> [aut, cre]
#> Description: What the package does (one paragraph).
#> License: `use_mit_license()`, `use_gpl3_license()` or friends to
#>     pick a license
#> Encoding: UTF-8
#> Roxygen: list(markdown = TRUE)
#> RoxygenNote: 8.0.0
#> ✔ Writing NAMESPACE.
#> ✔ Setting active project to "<no active project>".
bk_files <- c("_beekeeper.yml", "_beekeeper_rapid.rds")
fs::file_copy(
  fs::path_package("beekeeper", "guru", bk_files),
  fs::path(pkg_dir, bk_files)
)
usethis::local_project(pkg_dir)
#> ✔ Setting active project to "/tmp/Rtmpn6Dnyp/file5791f984346".
#> ✔ Setting active project to "<no active project>".

# Generate functions and tests for API paths.
generate_pkg_paths()
#> Warning: cannot open file '/__w/beekeeper/beekeeper/docs/dev/reference/_beekeeper.yml': No such file or directory
#> Error in file(file, "rt", encoding = fileEncoding): cannot open the connection
fs::dir_ls("R")
#> Error: [ENOENT] Failed to search directory 'R': no such file or directory
fs::dir_ls("tests/testthat")
#> Error: [ENOENT] Failed to search directory 'tests/testthat': no such file or directory

# Clean up.
withr::deferred_run()
#> No deferred expressions to run
```
