.generate_paths <- function(
  paths,
  api_abbr,
  security_data,
  pagination_data,
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
  return(tibble::deframe(paths_df))
}

.paths_to_clean_df <- function(x) {
  x <- tibble::as_tibble(x) |>
    tidyr::unnest("operations")
  x <- x[!x$deprecated, ]
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
  x$description = .paths_fill_descriptions(x$description, x$summary)
  # TODO: Deal with x$global_parameters if present
  x$parameters <- purrr::map(x$parameters, .prepare_params_df)
  # TODO: add breakdown by location
  return(tidyr::nest(x, .by = "operation_id"))
}

## to list ---------------------------------------------------------------------
.paths_endpoints_to_lists <- function(endpoints) {
  pmap(
    list(
      operation_id = .paths_fill_operation_id(
        endpoints$operation_id,
        endpoints$endpoint,
        endpoints$operation
      ),
      path = endpoints$endpoint,
      summary = .paths_fill_summary(
        endpoints$summary,
        endpoints$endpoint,
        endpoints$operation
      ),
      description = .paths_fill_descriptions(endpoints$description),
      params_df = endpoints$parameters,
      method = endpoints$operation
    ),
    .paths_endpoint_to_list
  )
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
  endpoint_spaced <- str_replace_all(.to_snake(endpoint), "_", " ")
  .coalesce(
    str_squish(summary),
    str_to_sentence(glue("{method} {endpoint_spaced}"))
  )
}

### create whisker data --------------------------------------------------------

.paths_endpoint_to_list <- function(
  operation_id,
  path,
  summary,
  description,
  params_df,
  method
) {
  params_df <- .prepare_params_df(params_df)
  return(
    list(
      operation_id = operation_id,
      path = .path_as_arg(path, params_df),
      method = method,
      summary = summary,
      description = description,
      params = .params_to_list(params_df),
      params_query = .extract_params_by_location(params_df, "query"),
      params_header = .extract_params_by_location(params_df, "header"),
      params_cookie = .extract_params_by_location(params_df, "cookie")
    )
  )
}

.prepare_params_df <- function(params_df) {
  params_df <- .flatten_params_df(params_df)
  if (nrow(params_df)) {
    params_df$description <- .paths_complete_param_descriptions(
      descriptions = params_df$description,
      params_schema = params_df$schema,
      required = params_df$required,
      allow_empty = params_df$allowEmptyValue
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
  # TODO: Deal with all the available data.
  params <- pmap(
    list(
      name = params_df$name,
      description = params_df$description
    ),
    .paths_param_to_list
  )
  return(params)
}

.extract_params_by_location <- function(params_df, filter_in) {
  if (!nrow(params_df)) {
    return(character())
  }
  return(params_df$name[params_df$`in` == filter_in])
}

.paths_fill_descriptions <- function(descriptions, summaries) {
  descriptions[is.na(descriptions)] <- summaries[is.na(descriptions)]
  descriptions[is.na(descriptions)] <- ""
  return(str_squish(descriptions))
}

.describe_param_classes <- function(params_schema, allow_empty, required) {
  # TODO: Use enum and/or description when available.
  #
  # TODO: What should we do for `object` and `array`?
  type <- dplyr::left_join(
    dplyr::select(params_schema, "type", "format"),
    oas_format_registry,
    by = c("type", "format")
  )
  type$r_class_name_display <- stringr::str_remove(
    glue::glue("{type$r_class_package}::{type$r_class_name}"),
    "^base::"
  )
  return(.compile_param_class_descriptions(type, allow_empty, required))
}

.compile_param_class_descriptions <- function(type, allow_empty, required) {
  r_class_descriptions <- .glue_pipe_brace(
    "length-1 \\code{\\link[|{type$r_class_package}|:|{type$r_class_link}|]{|{type$r_class_name_display}|}}"
  ) |>
    .paste0_if(
      allow_empty,
      " or \\code{\\link[base:NULL]{NULL}}"
    ) |>
    .paste0_if(
      !required,
      ", optional"
    )

  return(r_class_descriptions)
}

.paths_complete_param_descriptions <- function(
  descriptions,
  params_schema,
  allow_empty,
  required
) {
  r_class_descriptions <- .describe_param_classes(
    params_schema,
    allow_empty,
    required
  )

  descriptions <- .paths_fill_descriptions(
    descriptions,
    params_schema$description
  )

  return(
    stringr::str_trim(
      .glue_pipe_brace("(|{r_class_descriptions}|) |{descriptions}|")
    )
  )
}

.paths_param_to_list <- function(name, description) {
  list(
    name = name,
    description = description
  )
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

# generate files ----------------------------------------------------------

.generate_paths_files <- function(
  paths_by_operation,
  api_abbr,
  security_data,
  pagination_data
) {
  unlist(imap(
    paths_by_operation,
    function(path_operation, path_operation_id) {
      .generate_paths_operation_files(
        path_operation,
        path_operation_id,
        api_abbr,
        security_data,
        pagination_data
      )
    }
  ))
}

.generate_paths_operation_files <- function(
  path_operation,
  path_operation_id,
  api_abbr,
  security_data,
  pagination_data
) {
  stop("Everything should be prepped before this, I think.")
  path_operation <- .prepare_path_operation(
    path_operation,
    security_data$security_arg_names
  )
  file_path <- .generate_paths_file(
    path_operation,
    path_operation_id,
    api_abbr,
    security_data,
    pagination_data
  )
  test_path <- .generate_paths_test_file(
    path_operation,
    path_operation_id,
    pagination_data,
    api_abbr
  )
  return(c(unname(file_path), unname(test_path)))
}

.prepare_path_operation <- function(path_operation, security_args) {
  stop(
    "Do this all in initial parsing? Everything is by operation now, which means 1 path per file; no need to map."
  )
  path_operation <- map(
    path_operation,
    function(path) {
      path$params <- .remove_security_args(path$params, security_args)
      path$params_cookie <- .prep_param_args(path$params_cookie, security_args)
      path$params_header <- .prep_param_args(path$params_header, security_args)
      path$params_query <- .prep_param_args(path$params_query, security_args)
      path$args <- .params_to_args(path$params)
      path$test_args <- path$args
      return(path)
    }
  )
}

.params_to_args <- function(params) {
  .collapse_comma(map_chr(params, "name")) %|"|% character()
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

.generate_paths_file <- function(path, path_tag_name, api_abbr, security_data) {
  .bk_use_template(
    template = "paths.R",
    data = c(
      path,
      api_abbr = api_abbr,
      has_security = security_data$has_security,
      security_signature = security_data$security_signature,
      security_arg_list = security_data$security_arg_list
    ),
    target = glue("paths-{path_tag_name}-{path$operation_id}.R")
  )
}

.generate_paths_test_file <- function(path_tag, path_tag_name, api_abbr) {
  .bk_use_template(
    template = "test-paths.R",
    data = list(
      paths = path_tag,
      tag = path_tag_name,
      api_abbr = api_abbr
    ),
    dir = "tests/testthat",
    target = glue("test-paths-{path_tag_name}.R")
  )
}
