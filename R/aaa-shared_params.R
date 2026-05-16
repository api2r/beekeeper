#' Shared parameters
#'
#' These parameters are used in multiple functions. They are defined here to
#' make them easier to import and to find.
#'
#' @param api_abbr (`character(1)`) A short (about 2-5 letter) abbreviation for
#'   the API, for use in function names and environment variables.
#' @param api_definition (`rapid::class_rapid`) The API definition to generate
#'   package code from.
#' @param api_title (`character(1)`) The API title used in generated package
#'   files.
#' @param call (`environment`) The caller environment for error messages.
#' @param config_file (`character(1)` or `fs_path`) The path to a beekeeper yaml
#'   config file.
#' @param pkg_dir (`character(1)` or `fs_path`) The directory containing package
#'   files.
#' @param rapid_file (`character(1)` or `fs_path`) The path to the R API
#'   definition (rapid) file.
#' @param to_collapse (`character`) The character vector to collapse.
#' @param x_arg (`character(1)`) The name of the `x` argument for error
#'   messages.
#'
#' @name .shared-params
#' @keywords internal
NULL
