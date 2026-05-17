# Generate one tag-level test file

Generate one tag-level test file

## Usage

``` r
.generate_paths_test_file(tag_operations, tag_name, api_abbr)
```

## Arguments

- tag_operations:

  (`list`) Operations grouped under one tag.

- tag_name:

  (`character(1)`) The tag name.

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

## Value

(`character(1)`) The generated test file path.
