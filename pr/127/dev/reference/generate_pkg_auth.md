# Generate authentication helpers

Generate the authentication helper file for a package under development
from the API security schemes stored in the OpenAPI definition. This
supports incremental package scaffolding when you want to review or
customize auth handling before generating the rest of the package files.

## Usage

``` r
generate_pkg_auth(
  api_abbr = read_api_abbr(pkg_dir, config_filename),
  security_schemes = read_security_schemes(pkg_dir, read_rapid_filename(pkg_dir,
    config_filename)),
  save_security_data = TRUE,
  security_data_filename = "_beekeeper_security.yml",
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
)
```

## Arguments

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- security_schemes:

  ([`rapid::class_security_schemes`](https://rapid.api2r.org/reference/class_security_schemes.html))
  Security schemes from the API definition.

- save_security_data:

  (`logical(1)`) Whether to save generated security metadata to a file
  and record that file in the beekeeper config.

- security_data_filename:

  (`character(1)` or `fs_path`) The path to the saved security metadata
  file (relative to the package root).

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`list`) Generated security metadata. `R/020-auth.R` is generated as a
side effect. When `save_security_data` is `TRUE` (strongly recommended
when calling this function as a stand-alone), the file designated by
`security_data_filename`, and the `security_data_filename` field in the
file designated by `config_filename` are generated as side effects.

## See also

Other package generation functions:
[`generate_pkg()`](https://beekeeper.api2r.org/dev/reference/generate_pkg.md),
[`generate_pkg_paths()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_paths.md),
[`generate_pkg_req_prepare()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_req_prepare.md),
[`generate_pkg_shared_params()`](https://beekeeper.api2r.org/dev/reference/generate_pkg_shared_params.md)

## Examples

``` r
# Set up an empty package.
pkg_dir <- unclass(fs::path_norm(withr::local_tempdir()))
usethis::create_package(pkg_dir, open = FALSE, check_name = FALSE)
#> ✔ Creating /tmp/RtmpBFY3xj/file50176a56a1c/.
#> ✔ Setting active project to "/tmp/RtmpBFY3xj/file50176a56a1c".
#> ✔ Creating R/.
#> ✔ Writing DESCRIPTION.
#> Package: file50176a56a1c
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
#> ✔ Setting active project to "/tmp/RtmpBFY3xj/file50176a56a1c".
#> ✔ Setting active project to "<no active project>".

# Generate package authentication functions.
generate_pkg_auth()
#> Warning: cannot open file '/__w/beekeeper/beekeeper/docs/dev/reference/_beekeeper.yml': No such file or directory
#> Error in file(file, "rt", encoding = fileEncoding): cannot open the connection
fs::dir_ls("R")
#> Error: [ENOENT] Failed to search directory 'R': no such file or directory

# Clean up.
withr::deferred_run()
#> No deferred expressions to run
```
