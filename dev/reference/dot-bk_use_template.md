# Use a template in this package

Use a template in this package

## Usage

``` r
.bk_use_template(
  template,
  data,
  ...,
  target = template,
  dir = c("R", "tests/testthat"),
  pkg_dir = "."
)
```

## Arguments

- template:

  (`character(1)`) The template file name to render.

- data:

  (`list`) Data passed to a template.

- ...:

  These dots are for future extensions and must be empty.

- target:

  (`character(1)`) The name of the generated file.

- dir:

  (`character(1)`) The directory where a generated file should be
  written.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`, invisibly) The path to the generated or updated file.
