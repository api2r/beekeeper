# Add a package dependency to the DESCRIPTION file

Add a package dependency to the DESCRIPTION file

## Usage

``` r
.use_package(pkg, type = "Imports", pkg_dir = ".")
```

## Arguments

- pkg:

  (`character(1)`) The package name.

- type:

  (`character(1)`) The dependency type, one of "Imports", "Suggests", or
  "Depends".

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

## Value

(`character(1)`, invisibly) The package name.
