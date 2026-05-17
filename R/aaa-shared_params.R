#' Shared parameters
#'
#' These parameters are used in multiple functions. They are defined here to
#' make them easier to import and to find.
#'
#' @param addition (`character`) Text to append when `test` is `TRUE`.
#' @param allow_empty (`logical`) Whether empty parameter values may be
#'   represented as `NULL`.
#' @param api_abbr (`character(1)`) A short (about 2-5 letter) abbreviation for
#'   the API, for use in function names and environment variables.
#' @param api_definition (`rapid::class_rapid`) The API definition to generate
#'   package code from.
#' @param api_title (`character(1)`) The API title used in generated package
#'   files.
#' @param base_path The root URL of the current project.
#' @param base_url (`character(1)`) The base URL used in generated test helpers.
#' @param call (`environment`) The caller environment for error messages.
#' @param config (`list`) Package-generation configuration data.
#' @param config_filename (`character(1)` or `fs_path`) The path to a beekeeper
#'   yaml config file (relative to the package root).
#' @param data (`list`) Data passed to a template.
#' @param dir (`character(1)`) The directory where a generated file should be
#'   written.
#' @param endpoint (`character(1)`) The operation endpoint.
#' @param endpoints (`character`) Endpoint paths paired with operations.
#' @param filter_in (`character(1)`) The parameter location to keep.
#' @param methods (`character`) HTTP methods paired with endpoints.
#' @param operation (`character(1)`) The HTTP method.
#' @param operation_description (`character(1)`) The operation description.
#' @param operation_descriptions (`character`) Operation descriptions from the
#'   API definition.
#' @param operation_id (`character(1)`) The operation identifier used in
#'   generated file names.
#' @param operation_ids (`character`) Operation identifiers from the API
#'   definition.
#' @param operation_summaries (`character`) Operation summaries from the API
#'   definition.
#' @param operation_summary (`character(1)`) The operation summary.
#' @param original (`character`) The original text.
#' @param pagination_data (`list`) Pagination metadata used while generating
#'   path files.
#' @param parameters (`data.frame`) Operation parameters.
#' @param params (`list`) Parameter metadata for a single operation.
#' @param params_df (`data.frame`) Parameter metadata in tabular form.
#' @param params_schema (`data.frame`) Schema metadata for operation parameters.
#' @param path (`character(1)`) The path template.
#' @param path_operation (`list`) Template data for one operation.
#' @param paths (`rapid::class_paths`) API path definitions.
#' @param paths_by_operation (`list`) Template-ready operations keyed by
#'   operation identifier.
#' @param pkg_dir (`character(1)` or `fs_path`) The directory containing package
#'   files.
#' @param rapid_filename (`character(1)` or `fs_path`) The path to the R API
#'   definition (rapid) file (relative to the package root).
#' @param required (`logical`) Whether each parameter is required.
#' @param security_arg_description (`character(1)`) The argument description.
#' @param security_arg_name (`character(1)`) The argument name.
#' @param security_arg_names (`character`) Security argument names to exclude
#'   from generated operation signatures (because they are defined once,
#'   separately).
#' @param security_args (`character`) Security argument names to remove from
#'   operation parameters (because they are defined once, separately).
#' @param security_data (`list`) Generated security metadata.
#' @param security_scheme_collection (`list`) Collected security scheme
#'   metadata.
#' @param security_scheme_description (`character(1)`) A security scheme
#'   description from the API definition.
#' @param security_scheme_details (`rapid::class_security_scheme_details`) The
#'   security scheme details.
#' @param security_scheme_name (`character(1)`) The security scheme name.
#' @param security_scheme_type (`character(1)`) The security scheme type.
#' @param security_schemes (`rapid::class_security_schemes`) Security schemes
#'   from the API definition.
#' @param tag_operations (`list`) Operations grouped under one tag.
#' @param tag_name (`character(1)`) The tag name.
#' @param tags (`character` or `list`) Tags for all operations.
#' @param target (`character(1)`) The name of the generated file.
#' @param template (`character(1)`) The template file name to render.
#' @param test (`logical`) A condition for each element of `original`.
#' @param to_collapse (`character`) The character vector to collapse.
#' @param type (`data.frame`) Joined parameter type metadata.
#' @param x (`any`) The object to check or coerce.
#' @param y (`any`) The default value.
#'
#' @name .shared-params
#' @keywords internal
NULL
