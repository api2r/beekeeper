# Write a rendered template to disk

Write a rendered template to disk

## Usage

``` r
.bk_use_template_impl(template, data, target, dir, pkg_dir = ".")
```

## Arguments

- template:

  (`character(1)`) The template file name to render.

- data:

  (`list`) Data passed to a template.

- target:

  (`character(1)`) The name of the generated file.

- dir:

  (`character(1)`) The directory where a generated file should be
  written.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`) The generated file path.
