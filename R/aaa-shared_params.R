#' Shared parameters
#'
#' These parameters are used in multiple functions. They are defined here to
#' make them easier to import and to find.
#'
#' @param allow_empty (`logical`) Whether empty parameter values may be
#'   represented as `NULL`.
#' @param api_abbr (`character(1)`) A short (about 2-5 letter) abbreviation for
#'   the API, for use in function names and environment variables.
#' @param api_definition (`rapid::class_rapid`) The API definition to generate
#'   package code from.
#' @param api_title (`character(1)`) The API title used in generated package
#'   files.
#' @param call (`environment`) The caller environment for error messages.
#' @param config (`list`) Package-generation configuration data.
#' @param config_file (`character(1)` or `fs_path`) The path to a beekeeper yaml
#'   config file.
#' @param data (`list`) Data passed to a template.
#' @param dir (`character(1)`) The directory where a generated file should be
#'   written.
#' @param endpoints (`character`) Endpoint paths paired with operations.
#' @param methods (`character`) HTTP methods paired with endpoints.
#' @param operation_id (`character(1)`) The operation identifier used in
#'   generated file names.
#' @param operation_summaries (`character`) Operation summaries from the API
#'   definition.
#' @param pagination_data (`list`) Pagination metadata used while generating
#'   path files.
#' @param params (`list`) Parameter metadata for a single operation.
#' @param params_df (`data.frame`) Parameter metadata in tabular form.
#' @param params_schema (`data.frame`) Schema metadata for operation
#'   parameters.
#' @param paths (`rapid::class_paths`) API path definitions.
#' @param pkg_dir (`character(1)` or `fs_path`) The directory containing package
#'   files.
#' @param rapid_file (`character(1)` or `fs_path`) The path to the R API
#'   definition (rapid) file.
#' @param required (`logical`) Whether each parameter is required.
#' @param security_arg_names (`character`) Security argument names to exclude
#'   from generated operation signatures.
#' @param security_args (`character`) Security argument names to remove from
#'   operation parameters.
#' @param security_data (`list`) Generated security metadata.
#' @param security_scheme_collection (`list`) Collected security scheme
#'   metadata.
#' @param security_scheme_description (`character(1)`) A security scheme
#'   description from the API definition.
#' @param security_schemes (`rapid::class_security_schemes`) Security schemes
#'   from the API definition.
#' @param target (`character(1)`) The name of the generated file.
#' @param template (`character(1)`) The template file name to render.
#' @param to_collapse (`character`) The character vector to collapse.
#'
#' @name .shared-params
#' @keywords internal
NULL
