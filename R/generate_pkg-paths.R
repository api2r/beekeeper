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

S7::method(as_bk_data, class_paths) <- function(x) {
  if (!length(x)) {
    return(list())
  }
  paths_df <- .paths_to_clean_df(x)
  result <- purrr::pmap(paths_df, .path_row_to_list)
  names(result) <- paths_df$operation_id
  result
}

.paths_to_clean_df <- function(x) {
  x <- tibble::as_tibble(x) |>
    tidyr::unnest("operations")
  if (length(x$deprecated)) {
    x <- x[!x$deprecated, ]
  }
  x$deprecated <- NULL
  x$tags <- .paths_fill_tags(x$tags)
  x$operation_id <- .paths_fill_operation_id(
    x$operation_id,
    x$endpoint,
    x$operation
  )
  x$summary <- .paths_fill_summary(
    x$summary,
    x$endpoint,
    x$operation
  )
  x$description <- .paths_fill_descriptions(x$description, x$summary)
  # TODO: Deal with x$global_parameters if present
  x$parameters <- purrr::map(x$parameters, .prepare_params_df)
  return(x)
}

### fill data ------------------------------------------------------------------

.paths_fill_tags <- function(tags) {
  tags[lengths(tags) == 0] <- "general"
  tags <- purrr::map_chr(tags, 1)
  return(.to_snake(tags))
}

.paths_fill_operation_id <- function(operation_id, endpoint, method) {
  .coalesce(.to_snake(operation_id), glue("{method}_{.to_snake(endpoint)}"))
}

.paths_fill_summary <- function(summary, endpoint, method) {
  endpoint_spaced <- stringr::str_replace_all(.to_snake(endpoint), "_", " ")
  .coalesce(
    stringr::str_squish(summary),
    stringr::str_to_sentence(glue("{method} {endpoint_spaced}"))
  )
}

.paths_fill_descriptions <- function(descriptions, summaries) {
  descriptions[is.na(descriptions)] <- summaries[is.na(descriptions)]
  descriptions[is.na(descriptions)] <- ""
  return(stringr::str_squish(descriptions))
}

### create template data -------------------------------------------------------

.path_row_to_list <- function(
  operation_id,
  endpoint,
  operation,
  summary,
  description,
  tags,
  parameters,
  ...
) {
  list(
    operation_id = operation_id,
    tag = tags,
    path = .path_as_arg(endpoint, parameters),
    method = operation,
    summary = summary,
    description = description,
    params = .params_to_list(parameters),
    params_query_raw = .extract_params_by_location(parameters, "query"),
    params_header_raw = .extract_params_by_location(parameters, "header"),
    params_cookie_raw = .extract_params_by_location(parameters, "cookie")
  )
}

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

.flatten_params_df <- function(params_df) {
  params_df <- .flatten_df(params_df)
  if (nrow(params_df)) {
    params_df <- params_df[!params_df$deprecated, ]
  }
  return(params_df)
}

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

.extract_params_by_location <- function(params_df, filter_in) {
  if (!nrow(params_df)) {
    return(character())
  }
  return(params_df$name[params_df$`in` == filter_in])
}

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

.param_schema_to_r <- function(params_schema) {
  type <- dplyr::left_join(
    dplyr::select(params_schema, "type", "format"),
    dplyr::select(oas_format_registry, "type", "format", "to_r"),
    by = c("type", "format")
  )
  type$to_r
}

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

.path_as_arg <- function(path, params_df) {
  if (!nrow(params_df) || !any(params_df$`in` == "path")) {
    return(glue('"{path}"'))
  }
  params_path <- params_df$name[params_df$`in` == "path"]
  params <- .collapse_comma_self_equal(params_path)
  return(glue('c("{path}", {params})'))
}

.collapse_comma_self_equal <- function(x) {
  .collapse_comma(glue("{x} = {x}"))
}

# generate files ---------------------------------------------------------------

.generate_paths_files <- function(
  paths_by_operation,
  api_abbr,
  security_data,
  pagination_data
) {
  security_arg_names <- security_data$security_arg_names %|0|% character()

  # Prep each operation: remove security args, compile args strings
  prepped <- imap(paths_by_operation, function(op, op_id) {
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
  r_files <- unname(unlist(imap(prepped, function(op, op_id) {
    .generate_paths_file(op, op_id, api_abbr, security_data)
  })))

  # One test file per tag (operations grouped by tag, preserving encounter
  # order)
  tags <- map_chr(prepped, "tag")
  unique_tags <- unique(tags)
  test_files <- unname(unlist(lapply(unique_tags, function(tag_name) {
    tag_ops <- prepped[tags == tag_name]
    .generate_paths_test_file(tag_ops, tag_name, api_abbr)
  })))

  return(c(r_files, test_files))
}

.params_to_args <- function(params) {
  .collapse_comma(map_chr(params, "name")) %|"|% character()
}

.params_to_named_args <- function(params) {
  .collapse_comma_self_equal(map_chr(params, "name")) %|"|% character()
}

.remove_security_args <- function(params, security_args) {
  discard(
    params,
    function(param) {
      param$name %in% security_args
    }
  )
}

.prep_param_args <- function(params, security_args) {
  .collapse_comma_self_equal(setdiff(params, security_args)) %|"|% character()
}

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
    target = glue("paths-{path_operation$tag}-{operation_id}.R")
  )
}

.generate_paths_test_file <- function(tag_operations, tag_name, api_abbr) {
  paths_list <- unname(imap(tag_operations, function(op, op_id) {
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
    target = glue("test-paths-{tag_name}.R")
  )
}
