# Generate prepare tests

Generate prepare tests

## Usage

``` r
.generate_prepare_test(api_abbr, pkg_dir = ".")
```

## Arguments

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`) The generated test file path.
