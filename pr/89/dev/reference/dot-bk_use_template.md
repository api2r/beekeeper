# Use a template in this package

Use a template in this package

## Usage

``` r
.bk_use_template(
  template,
  data,
  ...,
  target = template,
  dir = c("R", "tests/testthat")
)
```

## Arguments

- template:

  The name of the template.

- data:

  A list of variables to apply to the template.

- ...:

  These dots are for future extensions and must be empty.

- target:

  The name of the file to create.

- dir:

  The directory where the file should be created.

## Value

The path to the generated or updated file, invisibly.
