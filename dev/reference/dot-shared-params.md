# Shared parameters

These parameters are used in multiple functions. They are defined here
to make them easier to import and to find.

## Arguments

- addition:

  (`character`) Text to append when `test` is `TRUE`.

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

- base_path:

  The root URL of the current project.

- base_url:

  (`character(1)`) The base URL used in generated test helpers.

- call:

  (`environment`) The caller environment for error messages.

- config:

  (`list`) Package-generation configuration data.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- data:

  (`list`) Data passed to a template.

- dir:

  (`character(1)`) The directory where a generated file should be
  written.

- endpoint:

  (`character(1)`) The operation endpoint.

- endpoints:

  (`character`) Endpoint paths paired with operations.

- filter_in:

  (`character(1)`) The parameter location to keep.

- methods:

  (`character`) HTTP methods paired with endpoints.

- operation:

  (`character(1)`) The HTTP method.

- operation_description:

  (`character(1)`) The operation description.

- operation_descriptions:

  (`character`) Operation descriptions from the API definition.

- operation_id:

  (`character(1)`) The operation identifier used in generated file
  names.

- operation_ids:

  (`character`) Operation identifiers from the API definition.

- operation_summaries:

  (`character`) Operation summaries from the API definition.

- operation_summary:

  (`character(1)`) The operation summary.

- original:

  (`character`) The original text.

- pagination_data:

  (`list`) Pagination metadata used while generating path files.

- parameters:

  (`data.frame`) Operation parameters.

- params:

  (`list`) Parameter metadata for a single operation.

- params_df:

  (`data.frame`) Parameter metadata in tabular form.

- params_schema:

  (`data.frame`) Schema metadata for operation parameters.

- path:

  (`character(1)`) The path template.

- path_operation:

  (`list`) Template data for one operation.

- paths:

  ([`rapid::class_paths`](https://rapid.api2r.org/reference/class_paths.html))
  API path definitions.

- paths_by_operation:

  (`list`) Template-ready operations keyed by operation identifier.

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- rapid_filename:

  (`character(1)` or `fs_path`) The path to the R API definition (rapid)
  file (relative to the package root).

- required:

  (`logical`) Whether each parameter is required.

- security_arg_description:

  (`character(1)`) The argument description.

- security_arg_name:

  (`character(1)`) The argument name.

- security_arg_names:

  (`character`) Security argument names to exclude from generated
  operation signatures (because they are defined once, separately).

- security_args:

  (`character`) Security argument names to remove from operation
  parameters (because they are defined once, separately).

- security_data:

  (`list`) Generated security metadata.

- security_scheme_collection:

  (`list`) Collected security scheme metadata.

- security_scheme_description:

  (`character(1)`) A security scheme description from the API
  definition.

- security_scheme_details:

  ([`rapid::class_security_scheme_details`](https://rapid.api2r.org/reference/class_security_scheme_details.html))
  The security scheme details.

- security_scheme_name:

  (`character(1)`) The security scheme name.

- security_scheme_type:

  (`character(1)`) The security scheme type.

- security_schemes:

  ([`rapid::class_security_schemes`](https://rapid.api2r.org/reference/class_security_schemes.html))
  Security schemes from the API definition.

- tag_operations:

  (`list`) Operations grouped under one tag.

- tag_name:

  (`character(1)`) The tag name.

- tags:

  (`character` or `list`) Tags for all operations.

- target:

  (`character(1)`) The name of the generated file.

- template:

  (`character(1)`) The template file name to render.

- test:

  (`logical`) A condition for each element of `original`.

- to_collapse:

  (`character`) The character vector to collapse.

- type:

  (`data.frame`) Joined parameter type metadata.

- x:

  (`any`) The object to check or coerce.

- y:

  (`any`) The default value.
