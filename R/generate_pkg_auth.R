#' Generate authentication helpers
#'
#' Generate the authentication helper file for a package under development from
#' the API security schemes stored in the OpenAPI definition. This supports
#' incremental package scaffolding when you want to review or customize auth
#' handling before generating the rest of the package files.
#'
#' @inheritParams .shared-params
#' @returns (`list`) Generated security metadata. `R/020-auth.R` is generated as
#'   a side effect. When `save_security_data` is `TRUE` (strongly recommended
#'   when calling this function as a stand-alone), the file designated by
#'   `security_data_filename`, and the `security_data_filename` field in the
#'   file designated by `config_filename` are generated as side effects.
#' @export
#' @family package generation functions
#' @examplesIf rlang::is_installed("withr")
#' # Set up an empty package.
#' pkg_dir <- unclass(fs::path_norm(withr::local_tempdir()))
#' usethis::create_package(pkg_dir, open = FALSE, check_name = FALSE)
#' bk_files <- c("_beekeeper.yml", "_beekeeper_rapid.rds")
#' fs::file_copy(
#'   fs::path_package("beekeeper", "trello", bk_files),
#'   fs::path(pkg_dir, bk_files)
#' )
#' usethis::local_project(pkg_dir)
#'
#' # Generate package authentication functions.
#' generate_pkg_auth()
#' fs::dir_ls("R")
#'
#' # Clean up.
#' withr::deferred_run()
generate_pkg_auth <- function(
  api_abbr = read_api_abbr(pkg_dir, config_filename),
  security_schemes = read_security_schemes(
    pkg_dir,
    read_rapid_filename(pkg_dir, config_filename)
  ),
  save_security_data = TRUE,
  security_data_filename = "_beekeeper_security.yml",
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
) {
  .assert_is_pkg(pkg_dir)
  api_abbr <- stbl::stabilize_chr_scalar(api_abbr)
  save_security_data <- stbl::to_lgl_scalar(save_security_data)
  security_data_filename <- stbl::stabilize_chr_scalar(security_data_filename)
  .use_r_directory(pkg_dir)
  .use_nectar(pkg_dir)
  .use_pkg_beekeeper(pkg_dir)
  security_data <- .generate_security(api_abbr, security_schemes)
  if (save_security_data) {
    .write_security_data(
      .without_security_file_path(security_data),
      security_data_filename,
      config_filename,
      pkg_dir
    )
  }
  return(security_data)
}

#' Generate security files and metadata
#'
#' @inheritParams .shared-params
#' @returns (`list`) Generated security metadata.
#' @keywords internal
.generate_security <- function(api_abbr, security_schemes) {
  security_data <- as_bk_data(security_schemes)
  if (length(security_data)) {
    security_data$security_file_path <- .bk_use_template(
      template = "020-auth.R",
      data = c(security_data, api_abbr = api_abbr)
    )
    security_data$security_signature <- .generate_security_signature(
      security_data$security_arg_names,
      api_abbr
    )
  }
  return(security_data)
}

#' Write saved security metadata and update the config
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The saved security metadata filename.
#' @keywords internal
.write_security_data <- function(
  security_data,
  security_data_filename,
  config_filename,
  pkg_dir
) {
  yaml::write_yaml(
    security_data,
    file = fs::path(pkg_dir, security_data_filename)
  )
  usethis::with_project(
    pkg_dir,
    usethis::use_build_ignore(security_data_filename)
  )
  .write_config_field(
    field = "security_data_filename",
    value = security_data_filename,
    config_filename = config_filename,
    pkg_dir = pkg_dir
  )
  return(security_data_filename)
}

#' Remove generated file paths from saved security metadata
#'
#' @inheritParams .shared-params
#' @returns (`list`) Security metadata suitable for serialization.
#' @keywords internal
.without_security_file_path <- function(security_data) {
  security_data[names(security_data) != "security_file_path"]
}

#' Generate a security argument signature
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) A function-signature fragment.
#' @keywords internal
.generate_security_signature <- function(security_arg_names, api_abbr) {
  env_vars <- toupper(glue::glue("{api_abbr}_{security_arg_names}"))
  return(
    .collapse_comma_newline(glue::glue(
      "{security_arg_names} = Sys.getenv(\"{env_vars}\")"
    ))
  )
}

S7::method(as_bk_data, class_security_schemes) <- function(x, ...) {
  if (!length(x)) {
    return(list())
  }
  security_scheme_collection <- .security_schemes_collect(x)
  return(.security_scheme_collection_finalize(security_scheme_collection))
}

#' Collect security scheme metadata
#'
#' @inheritParams .shared-params
#' @returns (`list`) Security scheme metadata.
#' @keywords internal
.security_schemes_collect <- function(security_schemes) {
  purrr::pmap(
    list(
      security_schemes@name,
      security_schemes@details,
      security_schemes@description %|0|%
        rep(NA_character_, length(security_schemes@name))
    ),
    .security_scheme_rotate
  )
}

#' Convert one security scheme to a list
#'
#' @inheritParams .shared-params
#' @returns (`list`) One security scheme description.
#' @keywords internal
.security_scheme_rotate <- function(
  security_scheme_name,
  security_scheme_details,
  security_scheme_description
) {
  security_scheme_list <- c(
    list(
      name = .to_snake(security_scheme_name),
      description = security_scheme_description
    ),
    as_bk_data(security_scheme_details)
  )
  security_scheme_list$description <- .security_scheme_description_fill(
    security_scheme_description,
    security_scheme_list$type
  )
  return(security_scheme_list)
}

#' Fill a missing security scheme description
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) A security scheme description.
#' @keywords internal
.security_scheme_description_fill <- function(
  security_scheme_description,
  security_scheme_type
) {
  if (is.na(security_scheme_description)) {
    return(
      switch(
        security_scheme_type,
        api_key = .security_scheme_description_api_key,
        NA_character_
      )
    )
  }
  return(security_scheme_description) # nocov
}

.security_scheme_description_api_key <- paste(
  "(length-1 `character`)",
  "An API key provided by the API provider.",
  "This key is not clearly documented in the API description.",
  "Check the API documentation for details."
)

#' Finalize collected security scheme data
#'
#' @inheritParams .shared-params
#' @returns (`list`) Finalized security metadata.
#' @keywords internal
.security_scheme_collection_finalize <- function(security_scheme_collection) {
  security_scheme_data <- c(
    list(
      has_security = TRUE,
      security_schemes = security_scheme_collection
    ),
    .security_args_compile(security_scheme_collection)
  )
  return(security_scheme_data)
}

#' Compile security argument metadata
#'
#' @inheritParams .shared-params
#' @returns (`list`) Compiled security argument values.
#' @keywords internal
.security_args_compile <- function(security_scheme_collection) {
  security_args <- sort(unique(purrr::map_chr(
    security_scheme_collection,
    "arg_name"
  )))
  return(list(
    security_arg_names = security_args,
    security_arg_list = .collapse_comma(glue::glue(
      "{security_args} = {security_args}"
    )),
    security_arg_helps = .generate_security_arg_help(
      security_scheme_collection,
      security_args
    ),
    security_arg_nulls = .collapse_comma(glue::glue("{security_args} = NULL"))
  ))
}

#' Build security argument help entries
#'
#' @inheritParams .shared-params
#' @returns (`list`) Template-ready parameter help entries.
#' @keywords internal
.generate_security_arg_help <- function(
  security_scheme_collection,
  security_args
) {
  security_arg_descriptions <- rlang::set_names(
    purrr::map_chr(security_scheme_collection, "description"),
    purrr::map_chr(security_scheme_collection, "arg_name")
  )
  security_arg_descriptions <- unname(security_arg_descriptions[security_args])
  return(
    purrr::map2(
      security_arg_descriptions,
      security_args,
      .security_arg_description_clean
    )
  )
}

#' Format one security argument help entry
#'
#' @inheritParams .shared-params
#' @returns (`list`) A named list with `name` and `description`.
#' @keywords internal
.security_arg_description_clean <- function(
  security_arg_description,
  security_arg_name
) {
  list(name = security_arg_name, description = security_arg_description)
}

S7::method(as_bk_data, class_security_scheme_details) <- function(x, ...) {
  purrr::map(x, as_bk_data)
}

S7::method(as_bk_data, class_api_key_security_scheme) <- function(x, ...) {
  if (length(x)) {
    return(
      list(
        parameter_name = x@parameter_name,
        arg_name = stringr::str_remove(.to_snake(x@parameter_name), "^x_"),
        location = x@location,
        type = "api_key",
        api_key = TRUE
      )
    )
  }
  return(list())
}

# S7::method(
#   as_bk_data,
#   rapid::class_oauth2_authorization_code_flow
# ) <- function(x) {
#   if (!length(x)) {
#     return(list())
#   }
#   return(
#     list(
#       refresh_url = x@refresh_url,
#       scopes = as_bk_data(x@scopes),
#       authorization_url = x@authorization_url,
#       token_url = x@token_url
#     )
#   )
# }

# S7::method(as_bk_data, rapid::class_oauth2_implicit_flow) <- function(x) {
#   if (!length(x)) {
#     return(list())
#   }
#   return(
#     list(
#       refresh_url = x@refresh_url,
#       scopes = as_bk_data(x@scopes),
#       authorization_url = x@authorization_url
#     )
#   )
# }

# S7::method(as_bk_data, rapid::class_scopes) <- function(x) {
#   if (!length(x)) {
#     return(list())
#   }
#   return(
#     list(
#       name = x@name,
#       description = x@description
#     )
#   )
# }

# S7::method(as_bk_data, rapid::class_oauth2_token_flow) <- function(x) {
#   if (!length(x)) {
#     return(list())
#   }
#   return(
#     list(
#       refresh_url = x@refresh_url,
#       scopes = as_bk_data(x@scopes),
#       token_url = x@token_url
#     )
#   )
# }

# S7::method(as_bk_data, rapid::class_oauth2_security_scheme) <- function(x) {
#   if (!length(x)) {
#     return(list())
#   }
#   return(
#     list(
#       implicit_flow = as_bk_data(x@implicit_flow),
#       password_flow = as_bk_data(x@password_flow),
#       client_credentials_flow = as_bk_data(x@client_credentials_flow),
#       authorization_code_flow = as_bk_data(x@authorization_code_flow),
#       type = "oauth2"
#     )
#   )
# }
