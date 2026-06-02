# Generate one tag-level test file

Generate one tag-level test file

## Usage

``` r
.generate_paths_test_file(
  tag_operations,
  tag_name,
  api_abbr,
  use_prefix = FALSE
)
```

## Arguments

- tag_operations:

  (`list`) Operations grouped under one tag.

- tag_name:

  (`character(1)`) The tag name.

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- use_prefix:

  (`logical(1)`) Whether to include `api_abbr` as a prefix in generated
  path function names. When `FALSE` (the default), functions are named
  `{operation_id}` and `req_{operation_id}`. When `TRUE`, functions are
  named `{api_abbr}_{operation_id}` and `req_{api_abbr}_{operation_id}`.

## Value

(`character(1)`) The generated test file path.
