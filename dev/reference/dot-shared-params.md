# Shared parameters

These parameters are used in multiple functions. They are defined here
to make them easier to import and to find.

## Arguments

- api_abbr:

  (`character(1)`) A short (about 2-5 letter) abbreviation for the API,
  for use in function names and environment variables.

- api_definition:

  ([`rapid::class_rapid`](https://rapid.api2r.org/reference/class_rapid.html))
  The API definition to generate package code from.

- api_title:

  (`character(1)`) The API title used in generated package files.

- call:

  (`environment`) The caller environment for error messages.

- config_file:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config
  file.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- rapid_file:

  (`character(1)` or `fs_path`) The path to the R API definition (rapid)
  file.

- to_collapse:

  (`character`) The character vector to collapse.
