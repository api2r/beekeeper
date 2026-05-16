#' Generate files for API paths
#'
#' @param base_url (`character(1)`) The base URL used in generated test
#'   helpers.
#' @inheritParams .shared-params
#' @returns A `character` vector of generated file paths.
#' @keywords internal
.generate_paths <- function(
  paths,
  api_abbr,
  security_data,
  pagination_data = list(),
  base_url
) {
  paths_by_operation <- as_bk_data(paths)
  paths_file_paths <- character()
  if (length(paths_by_operation)) {
    paths_file_paths <- .generate_paths_files(
      paths_by_operation,
      api_abbr,
      security_data,
      pagination_data
    )
    setup_file <- .bk_use_template(
      template = "setup.R",
      data = list(base_url = base_url),
      dir = "tests/testthat"
    )
    paths_file_paths <- c(paths_file_paths, setup_file)
  }
  return(paths_file_paths)
}

# reshape data -----------------------------------------------------------------

#' @rdname as_bk_data
#' @keywords internal
S7::method(as_bk_data, class_paths) <- function(x) {
  if (!length(x)) {
    return(list())
  }
  operations_df <- .paths_to_clean_df(x)
  result <- purrr::pmap(operations_df, .path_row_to_list)
  names(result) <- operations_df$operation_id
  result
}

#' Convert API paths to an operations data frame
#'
#' @inheritParams .shared-params
#' @returns A [tibble::tibble()] with one row per non-deprecated operation.
#' @keywords internal
.paths_to_clean_df <- function(paths) {
  operations_df <- tibble::as_tibble(paths) |>
    tidyr::unnest("operations")
  if (length(operations_df$deprecated)) {
    operations_df <- operations_df[!operations_df$deprecated, ]
  }
  operations_df$deprecated <- NULL
  operations_df$tags <- .paths_fill_tags(operations_df$tags)
  operations_df$operation_id <- .paths_fill_operation_id(
    operations_df$operation_id,
    operations_df$endpoint,
    operations_df$operation
  )
  operations_df$operation_summary <- .paths_fill_summary(
    operations_df$summary,
    operations_df$endpoint,
    operations_df$operation
  )
  operations_df$summary <- NULL
  operations_df$operation_description <- .paths_fill_descriptions(
    operations_df$description,
    operations_df$operation_summary
  )
  operations_df$description <- NULL
  # TODO: Deal with x$global_parameters if present
  operations_df$parameters <- purrr::map(
    operations_df$parameters,
    .prepare_params_df
  )
  return(operations_df)
}

### fill data ------------------------------------------------------------------

#' Fill missing operation tags
#'
#' @param tags (`list`) Operation tags from the API definition.
#' @returns (`character`) Snake-case tag names.
#' @keywords internal
.paths_fill_tags <- function(tags) {
  tags[lengths(tags) == 0] <- "general"
  tags <- purrr::map_chr(tags, 1)
  return(.to_snake(tags))
}

#' Fill missing operation identifiers
#'
#' @param operation_ids (`character`) Operation identifiers from the API
#'   definition.
#' @inheritParams .shared-params
#' @returns (`character`) Operation identifiers.
#' @keywords internal
.paths_fill_operation_id <- function(operation_ids, endpoints, methods) {
  .to_snake(operation_ids) %|% glue::glue("{methods}_{.to_snake(endpoints)}")
}

#' Fill missing operation summaries
#'
#' @inheritParams .shared-params
#' @returns (`character`) Human-readable operation summaries.
#' @keywords internal
.paths_fill_summary <- function(operation_summaries, endpoints, methods) {
  endpoints_spaced <- stringr::str_replace_all(.to_snake(endpoints), "_", " ")
  stringr::str_squish(operation_summaries) %|%
    stringr::str_to_sentence(glue::glue("{methods} {endpoints_spaced}"))
}

#' Fill missing operation descriptions
#'
#' @param operation_descriptions (`character`) Operation descriptions from the
#'   API definition.
#' @inheritParams .shared-params
#' @returns (`character`) Operation descriptions.
#' @keywords internal
.paths_fill_descriptions <- function(
  operation_descriptions,
  operation_summaries
) {
  operation_descriptions[is.na(
    operation_descriptions
  )] <- operation_summaries[is.na(
    operation_descriptions
  )]
  operation_descriptions[is.na(operation_descriptions)] <- ""
  return(stringr::str_squish(operation_descriptions))
}

### create template data -------------------------------------------------------

#' Convert one operation row to template data
#'
#' @param endpoint (`character(1)`) The operation endpoint.
#' @param operation (`character(1)`) The HTTP method.
#' @param operation_summary (`character(1)`) The operation summary.
#' @param operation_description (`character(1)`) The operation description.
#' @param tags (`character(1)`) The operation tag.
#' @param parameters (`data.frame`) Operation parameters.
#' @param ... Additional columns, ignored.
#' @inheritParams .shared-params
#' @returns A `list` describing one operation.
#' @keywords internal
.path_row_to_list <- function(
  operation_id,
  endpoint,
  operation,
  operation_summary,
  operation_description,
  tags,
  parameters,
  ...
) {
  list(
    operation_id = operation_id,
    tag = tags,
    path = .path_as_arg(endpoint, parameters),
    method = operation,
    operation_summary = operation_summary,
    operation_description = operation_description,
    params = .params_to_list(parameters),
    params_query_raw = .extract_params_by_location(parameters, "query"),
    params_header_raw = .extract_params_by_location(parameters, "header"),
    params_cookie_raw = .extract_params_by_location(parameters, "cookie")
  )
}

#' Prepare parameter metadata
#'
#' @inheritParams .shared-params
#' @returns A `data.frame` of prepared parameter metadata.
#' @keywords internal
.prepare_params_df <- function(params_df) {
  params_df <- .flatten_params_df(params_df)
  if (nrow(params_df)) {
    params_df$class <- .describe_param_classes(
      params_df$schema,
      params_df$allowEmptyValue,
      params_df$required
    )
    params_df$to_r <- .param_schema_to_r(params_df$schema)
    params_df$description <- .paths_fill_descriptions(
      params_df$description,
      params_df$schema$description
    )
  }
  params_df$schema <- NULL
  params_df$style <- NULL
  return(params_df)
}

#' Flatten parameter metadata
#'
#' @inheritParams .shared-params
#' @returns A `data.frame` of flattened parameter metadata.
#' @keywords internal
.flatten_params_df <- function(params_df) {
  params_df <- .flatten_df(params_df)
  if (nrow(params_df)) {
    params_df <- params_df[!params_df$deprecated, ]
  }
  return(params_df)
}

#' Convert parameter rows to a list
#'
#' @inheritParams .shared-params
#' @returns A `list` of parameter metadata entries.
#' @keywords internal
.params_to_list <- function(params_df) {
  if (!nrow(params_df)) {
    return(list())
  }
  purrr::pmap(
    list(
      name = params_df$name,
      class = params_df$class,
      description = params_df$description,
      to_r = params_df$to_r
    ),
    function(name, class, description, to_r) {
      list(name = name, class = class, description = description, to_r = to_r)
    }
  )
}

#' Extract parameter names by location
#'
#' @param filter_in (`character(1)`) The parameter location to keep.
#' @inheritParams .shared-params
#' @returns (`character`) Parameter names for the requested location.
#' @keywords internal
.extract_params_by_location <- function(params_df, filter_in) {
  if (!nrow(params_df)) {
    return(character())
  }
  return(params_df$name[params_df$`in` == filter_in])
}

#' Describe parameter classes
#'
#' @inheritParams .shared-params
#' @returns (`character`) Display strings for parameter classes.
#' @keywords internal
.describe_param_classes <- function(params_schema, allow_empty, required) {
  # TODO: Use enum and/or description when available.
  #
  # TODO: What should we do for `object`? Currently falls back to list, same as
  # array.
  type <- dplyr::left_join(
    dplyr::select(params_schema, "type", "format"),
    oas_format_registry,
    by = c("type", "format")
  )
  # Fall back to list for unknown types (array, object, etc.)
  type$r_class_name <- dplyr::coalesce(type$r_class_name, "list")
  type$r_class_package <- dplyr::coalesce(type$r_class_package, "base")
  type$r_class_link <- dplyr::coalesce(type$r_class_link, "list")
  type$r_class_name_display <- stringr::str_remove(
    glue::glue("{type$r_class_package}::{type$r_class_name}"),
    "^base::"
  )
  return(.compile_param_class_descriptions(type, allow_empty, required))
}

#' Map parameter schemas to `stbl` helpers
#'
#' @inheritParams .shared-params
#' @returns (`character`) Coercion helper names.
#' @keywords internal
.param_schema_to_r <- function(params_schema) {
  type <- dplyr::left_join(
    dplyr::select(params_schema, "type", "format"),
    dplyr::select(oas_format_registry, "type", "format", "to_r"),
    by = c("type", "format")
  )
  type$to_r
}

#' Compile parameter class descriptions
#'
#' @param type (`data.frame`) Joined parameter type metadata.
#' @inheritParams .shared-params
#' @returns (`character`) Parameter class descriptions.
#' @keywords internal
.compile_param_class_descriptions <- function(type, allow_empty, required) {
  r_class_descriptions <- glue::glue("length-1 `{type$r_class_name}`") |>
    .paste0_if(
      allow_empty,
      " or `NULL`"
    ) |>
    .paste0_if(
      !required,
      ", optional"
    )

  return(r_class_descriptions)
}

#' Convert a path to a request argument
#'
#' @param path (`character(1)`) The path template.
#' @inheritParams .shared-params
#' @returns (`character(1)`) Code for the request path argument.
#' @keywords internal
.path_as_arg <- function(path, params_df) {
  if (!nrow(params_df) || !any(params_df$`in` == "path")) {
    return(glue::glue('"{path}"'))
  }
  params_path <- params_df$name[params_df$`in` == "path"]
  params <- .collapse_comma_self_equal(params_path)
  return(glue::glue('c("{path}", {params})'))
}

# generate files ---------------------------------------------------------------

#' Generate files for all operations
#'
#' @param paths_by_operation (`list`) Template-ready operations keyed by
#'   operation identifier.
#' @inheritParams .shared-params
#' @returns A `character` vector of generated file paths.
#' @keywords internal
.generate_paths_files <- function(
  paths_by_operation,
  api_abbr,
  security_data,
  pagination_data
) {
  security_arg_names <- security_data$security_arg_names %|0|% character()

  # Prep each operation: remove security args, compile args strings
  prepped <- purrr::imap(paths_by_operation, function(op, op_id) {
    params <- .remove_security_args(op$params, security_arg_names)
    params_query <- .prep_param_args(op$params_query_raw, security_arg_names)
    params_header <- .prep_param_args(op$params_header_raw, security_arg_names)
    params_cookie <- .prep_param_args(op$params_cookie_raw, security_arg_names)
    args <- .params_to_args(params)
    args_named <- .params_to_named_args(params)
    validations <- .params_to_validations(params)
    c(
      op,
      list(
        params = params,
        params_query = params_query,
        params_header = params_header,
        params_cookie = params_cookie,
        args = args,
        args_named = args_named,
        test_args = args,
        validations = validations
      )
    )
  })

  # One R file per operation
  r_files <- unname(unlist(purrr::imap(prepped, function(op, op_id) {
    .generate_paths_file(op, op_id, api_abbr, security_data)
  })))

  # One test file per tag (operations grouped by tag, preserving encounter
  # order)
  tags <- purrr::map_chr(prepped, "tag")
  unique_tags <- unique(tags)
  test_files <- unname(unlist(lapply(unique_tags, function(tag_name) {
    tag_ops <- prepped[tags == tag_name]
    .generate_paths_test_file(tag_ops, tag_name, api_abbr)
  })))

  return(c(r_files, test_files))
}

#' Convert parameters to a signature string
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) A comma-separated parameter string.
#' @keywords internal
.params_to_args <- function(params) {
  .collapse_comma(purrr::map_chr(params, "name")) %|a|% character()
}

#' Convert parameters to named arguments
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) A comma-separated named-argument string.
#' @keywords internal
.params_to_named_args <- function(params) {
  .collapse_comma_self_equal(purrr::map_chr(params, "name")) %|a|% character()
}

#' Remove security parameters
#'
#' @inheritParams .shared-params
#' @returns A `list` of non-security parameters.
#' @keywords internal
.remove_security_args <- function(params, security_args) {
  purrr::discard(
    params,
    function(param) {
      param$name %in% security_args
    }
  )
}

#' Prepare parameter arguments
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) A comma-separated named-argument string.
#' @keywords internal
.prep_param_args <- function(params, security_args) {
  .collapse_comma_self_equal(setdiff(params, security_args)) %|a|% character()
}

#' Convert parameters to validation metadata
#'
#' @inheritParams .shared-params
#' @returns A `list` of validation metadata.
#' @keywords internal
.params_to_validations <- function(params) {
  checks <- purrr::keep(
    params,
    function(param) {
      !is.null(param$to_r) &&
        !is.na(param$to_r) &&
        !startsWith(param$to_r, "todo_")
    }
  )
  purrr::map(
    checks,
    function(param) {
      list(name = param$name, to_r = param$to_r)
    }
  )
}

#' Determine whether generated paths need `stbl`
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if any path needs `stbl`.
#' @keywords internal
.paths_need_stbl <- function(paths, security_arg_names = character()) {
  ops <- as_bk_data(paths)
  if (!length(ops)) {
    return(FALSE)
  }
  any(purrr::map_lgl(ops, function(op) {
    params <- .remove_security_args(op$params, security_arg_names)
    length(.params_to_validations(params)) > 0
  }))
}

#' Generate one operation file
#'
#' @param path_operation (`list`) Template data for one operation.
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated file path.
#' @keywords internal
.generate_paths_file <- function(
  path_operation,
  operation_id,
  api_abbr,
  security_data
) {
  .bk_use_template(
    template = "paths.R",
    data = c(
      path_operation,
      list(
        api_abbr = api_abbr,
        has_security = security_data$has_security %|0|% FALSE,
        security_signature = security_data$security_signature %|0|% "",
        security_arg_list = security_data$security_arg_list %|0|% "",
        pagination = FALSE,
        pagination_fn = ""
      )
    ),
    target = glue::glue("paths-{path_operation$tag}-{operation_id}.R")
  )
}

#' Generate one tag-level test file
#'
#' @param tag_operations (`list`) Operations grouped under one tag.
#' @param tag_name (`character(1)`) The tag name.
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated test file path.
#' @keywords internal
.generate_paths_test_file <- function(tag_operations, tag_name, api_abbr) {
  paths_list <- unname(purrr::imap(tag_operations, function(op, op_id) {
    list(
      operation_id = op_id,
      test_args = op$test_args %|0|% ""
    )
  }))
  .bk_use_template(
    template = "test-paths.R",
    data = list(
      paths = paths_list,
      tag = tag_name,
      api_abbr = api_abbr
    ),
    dir = "tests/testthat",
    target = glue::glue("test-paths-{tag_name}.R")
  )
}
