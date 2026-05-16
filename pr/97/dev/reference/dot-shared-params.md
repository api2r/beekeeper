# Shared parameters

These parameters are used in multiple functions. They are defined here
to make them easier to import and to find.

## Arguments

- allow_empty:

  (`logical`) Whether empty parameter values may be represented as
  `NULL`.

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

- config:

  (`list`) Package-generation configuration data.

- config_file:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config
  file.

- data:

  (`list`) Data passed to a template.

- dir:

  (`character(1)`) The directory where a generated file should be
  written.

- endpoints:

  (`character`) Endpoint paths paired with operations.

- methods:

  (`character`) HTTP methods paired with endpoints.

- operation_id:

  (`character(1)`) The operation identifier used in generated file
  names.

- operation_summaries:

  (`character`) Operation summaries from the API definition.

- pagination_data:

  (`list`) Pagination metadata used while generating path files.

- params:

  (`list`) Parameter metadata for a single operation.

- params_df:

  (`data.frame`) Parameter metadata in tabular form.

- params_schema:

  (`data.frame`) Schema metadata for operation parameters.

- paths:

  ([`rapid::class_paths`](https://rapid.api2r.org/reference/class_paths.html))
  API path definitions.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- rapid_file:

  (`character(1)` or `fs_path`) The path to the R API definition (rapid)
  file.

- required:

  (`logical`) Whether each parameter is required.

- security_arg_names:

  (`character`) Security argument names to exclude from generated
  operation signatures.

- security_args:

  (`character`) Security argument names to remove from operation
  parameters.

- security_data:

  (`list`) Generated security metadata.

- security_scheme_collection:

  (`list`) Collected security scheme metadata.

- security_scheme_description:

  (`character(1)`) A security scheme description from the API
  definition.

- security_schemes:

  ([`rapid::class_security_schemes`](https://rapid.api2r.org/reference/class_security_schemes.html))
  Security schemes from the API definition.

- target:

  (`character(1)`) The name of the generated file.

- template:

  (`character(1)`) The template file name to render.

- to_collapse:

  (`character`) The character vector to collapse.
