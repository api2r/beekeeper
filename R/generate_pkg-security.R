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

.generate_security_signature <- function(security_arg_names, api_abbr) {
  env_vars <- toupper(glue::glue("{api_abbr}_{security_arg_names}"))
  return(
    .collapse_comma_newline(glue::glue(
      "{security_arg_names} = Sys.getenv(\"{env_vars}\")"
    ))
  )
}

S7::method(as_bk_data, class_security_schemes) <- function(x) {
  if (!length(x)) {
    return(list())
  }
  security_schemes <- .security_schemes_collect(x)
  return(.security_scheme_collection_finalize(security_schemes))
}

.security_schemes_collect <- function(x) {
  purrr::pmap(
    list(
      x@name,
      x@details,
      x@description %|0|% rep(NA_character_, length(x@name))
    ),
    .security_scheme_rotate
  )
}

.security_scheme_rotate <- function(name, details, description) {
  security_scheme <- c(
    list(
      name = .to_snake(name),
      description = description
    ),
    as_bk_data(details)
  )
  security_scheme$description <- .security_scheme_description_fill(
    description,
    security_scheme$type
  )
  return(security_scheme)
}

.security_scheme_description_fill <- function(description, type) {
  if (is.na(description)) {
    return(
      switch(
        type,
        api_key = .security_scheme_description_api_key,
        NA_character_
      )
    )
  }
  return(description) # nocov
}

.security_scheme_description_api_key <- paste(
  "An API key provided by the API provider.",
  "This key is not clearly documented in the API description.",
  "Check the API documentation for details."
)

.security_scheme_collection_finalize <- function(security_schemes) {
  security_scheme_data <- c(
    list(
      has_security = TRUE,
      security_schemes = security_schemes
    ),
    .security_args_compile(security_schemes)
  )
  return(security_scheme_data)
}

.security_args_compile <- function(security_schemes) {
  security_args <- sort(unique(purrr::map_chr(security_schemes, "arg_name")))
  return(list(
    security_arg_names = security_args,
    security_arg_list = .collapse_comma(glue::glue(
      "{security_args} = {security_args}"
    )),
    security_arg_helps = .generate_security_arg_help(
      security_schemes,
      security_args
    ),
    security_arg_nulls = .collapse_comma(glue::glue("{security_args} = NULL"))
  ))
}

.generate_security_arg_help <- function(security_schemes, security_args) {
  security_arg_description <- rlang::set_names(
    purrr::map_chr(security_schemes, "description"),
    purrr::map_chr(security_schemes, "arg_name")
  )
  security_arg_description <- unname(security_arg_description[security_args])
  return(
    purrr::map2(
      security_arg_description,
      security_args,
      .security_arg_description_clean
    )
  )
}

.security_arg_description_clean <- function(arg_description, arg_name) {
  list(name = arg_name, description = arg_description)
}

S7::method(as_bk_data, class_security_scheme_details) <- function(x) {
  purrr::map(x, as_bk_data)
}

S7::method(as_bk_data, class_api_key_security_scheme) <- function(x) {
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
