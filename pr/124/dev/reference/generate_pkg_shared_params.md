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

## Examples

``` r
# Set up an empty package.
pkg_dir <- unclass(fs::path_norm(withr::local_tempdir()))
usethis::create_package(pkg_dir, open = FALSE, check_name = FALSE)
#> ✔ Creating /tmp/RtmpdnXRFu/file5066aa154e/.
#> ✔ Setting active project to "/tmp/RtmpdnXRFu/file5066aa154e".
#> ✔ Creating R/.
#> ✔ Writing DESCRIPTION.
#> Package: file5066aa154e
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
  fs::path_package("beekeeper", "trello", bk_files),
  fs::path(pkg_dir, bk_files)
)
usethis::local_project(pkg_dir)
#> ✔ Setting active project to "/tmp/RtmpdnXRFu/file5066aa154e".
#> ✔ Setting active project to "<no active project>".

# Generate shared parameters.
generate_pkg_shared_params()
#> ✔ Setting active project to "/__w/beekeeper/beekeeper".
#> Warning: cannot open file '/__w/beekeeper/beekeeper/docs/dev/reference/_beekeeper.yml': No such file or directory
#> Error in file(file, "rt", encoding = fileEncoding): cannot open the connection
fs::dir_ls("R")
#> Error: [ENOENT] Failed to search directory 'R': no such file or directory

# Clean up.
withr::deferred_run()
#> No deferred expressions to run
```
