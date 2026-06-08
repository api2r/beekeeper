#' Generate files for API paths
#'
#' Generate operation functions and their tests from the API paths stored in the
#' OpenAPI definition. This supports incremental package scaffolding when you
#' want to review or customize endpoint wrappers separately from other package
#' components.
#'
#' @inheritParams .shared-params
#' @returns (`character`) Generated file paths. As a side effect, zero or more
#'   `R/paths-*.R` files are generated from the paths in the `api_definition`,
#'   as well as the associated test files as `tests/testthat/test-paths-*.R`.
#' @export
#' @family package generation functions
#' @examplesIf rlang::is_installed("withr")
#' # Set up an empty package.
#' pkg_dir <- unclass(fs::path_norm(withr::local_tempdir()))
#' usethis::create_package(pkg_dir, open = FALSE, check_name = FALSE)
#' bk_files <- c("_beekeeper.yml", "_beekeeper_rapid.rds")
#' fs::file_copy(
#'   fs::path_package("beekeeper", "guru", bk_files),
#'   fs::path(pkg_dir, bk_files)
#' )
#' usethis::local_project(pkg_dir)
#'
#' # Generate functions and tests for API paths.
#' generate_pkg_paths()
#' fs::dir_ls("R")
#' fs::dir_ls("tests/testthat")
#'
#' # Clean up.
#' withr::deferred_run()
generate_pkg_paths <- function(
  api_abbr = read_api_abbr(pkg_dir, config_filename),
  api_definition = read_api_definition(
    pkg_dir,
    read_rapid_filename(pkg_dir, config_filename)
  ),
  security_data = read_security_data(pkg_dir, config_filename),
  use_prefix = FALSE,
  exclude_from_response = character(),
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
) {
  .assert_is_pkg(pkg_dir)
  api_abbr <- stbl::stabilize_chr_scalar(api_abbr)
  .use_r_directory(pkg_dir)
  .use_testthat(pkg_dir)
  .use_httptest2(pkg_dir)
  .use_nectar(pkg_dir)
  .use_pkg_beekeeper(pkg_dir)
  security_arg_names <- security_data$security_arg_names %|0|% character()
  .maybe_use_stbl(pkg_dir, api_definition@paths, security_arg_names)
  .maybe_use_tibblify(pkg_dir, api_definition@paths)
  .generate_paths(
    paths = api_definition@paths,
    api_abbr = api_abbr,
    security_data = security_data,
    pagination_data = .generate_pagination(),
    base_url = api_definition@servers@url,
    use_prefix = use_prefix,
    exclude_from_response = exclude_from_response
  )
}

#' Generate files for API paths
#'
#' @inheritParams .shared-params
#' @returns (`character`) Generated file paths.
#' @keywords internal
.generate_paths <- function(
  paths,
  api_abbr,
  security_data,
  pagination_data = list(),
  base_url,
  use_prefix = FALSE,
  exclude_from_response = character()
) {
  paths_by_operation <- as_bk_data(
    paths,
    exclude_from_response = exclude_from_response
  )
  paths_file_paths <- character()
  if (length(paths_by_operation)) {
    paths_file_paths <- .generate_paths_files(
      paths_by_operation,
      api_abbr,
      security_data,
      pagination_data,
      use_prefix = use_prefix
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

# constants ------------------------------------------------------------------

meaningless_response_descriptions <- c("ok", "success")

# reshape data -----------------------------------------------------------------

S7::method(as_bk_data, class_paths) <- function(
  x,
  ...,
  exclude_from_response = character()
) {
  if (!length(x)) {
    return(list())
  }
  operations_df <- .paths_to_clean_df(x)
  result <- purrr::pmap(
    operations_df,
    .path_row_to_list,
    exclude_from_response = exclude_from_response
  )
  names(result) <- operations_df$operation_id
  result
}

#' Convert API paths to an operations data frame
#'
#' @inheritParams .shared-params
#' @returns (`tibble`) A [tibble::tibble()] with one row per non-deprecated
#'   operation.
#' @keywords internal
.paths_to_clean_df <- function(paths) {
  operations_df <- tibble::as_tibble(paths) |>
    tidyr::unnest("operations")
  if (length(operations_df[["deprecated"]])) {
    operations_df <- operations_df[!operations_df$deprecated, ]
  }
  operations_df$deprecated <- NULL
  operations_df[["tags"]] <- .paths_fill_tags(operations_df[["tags"]])
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
#' @inheritParams .shared-params
#' @returns (`character`) Snake-case tag names.
#' @keywords internal
.paths_fill_tags <- function(tags) {
  tags[lengths(tags) == 0] <- "general"
  tags <- purrr::map_chr(tags, 1)
  return(.to_snake(tags))
}

#' Fill missing operation identifiers
#'
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
#' @param ... Additional columns, ignored.
#' @inheritParams .shared-params
#' @returns (`list`) One operation description.
#' @keywords internal
.path_row_to_list <- function(
  operation_id,
  endpoint,
  operation,
  operation_summary,
  operation_description,
  tags,
  parameters,
  responses,
  exclude_from_response = character(),
  ...
) {
  response_info <- .extract_response_info(responses, exclude_from_response)
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
    params_cookie_raw = .extract_params_by_location(parameters, "cookie"),
    tidy_policy_body = response_info$tidy_policy_body,
    response_description = response_info$description[
      !tolower(response_info$description) %in% meaningless_response_descriptions
    ] %|a|%
      "The API response."
  )
}

#' Extract response information for template use
#'
#' Finds the JSON response (preferring `status_code == "200"`, falling back to
#' `"default"`) and extracts the tibblify spec and description.
#'
#' @inheritParams .shared-params
#' @returns (`list`) A list with `tidy_policy_body` (character) and
#'   `description` (character).
#' @importFrom tibblify tspec_row
#' @keywords internal
.extract_response_info <- function(
  responses,
  exclude_from_response = character()
) {
  description <- ""
  tidy_policy_body <- "nectar::tidy_policy_body_auto()"

  if (is.null(responses) || !nrow(responses)) {
    return(list(tidy_policy_body = tidy_policy_body, description = description))
  }

  idx_200 <- which(responses$status_code == "200")
  idx_default <- which(responses$status_code == "default")

  if (length(idx_200) > 0) {
    response_row <- responses[idx_200[[1]], ]
  } else if (length(idx_default) > 0) {
    response_row <- responses[idx_default[[1]], ]
  } else {
    return(list(tidy_policy_body = tidy_policy_body, description = description))
  }

  description <- response_row$description[[1]] %|% ""

  content <- response_row$content[[1]]
  if (is.null(content) || !nrow(content)) {
    return(list(tidy_policy_body = tidy_policy_body, description = description))
  }

  json_row <- content[content$media_type == "application/json", ]
  if (!nrow(json_row)) {
    return(list(tidy_policy_body = tidy_policy_body, description = description))
  }

  spec <- json_row$spec[[1]]
  if (is.null(spec)) {
    return(list(tidy_policy_body = tidy_policy_body, description = description))
  }

  spec[["fields"]][exclude_from_response] <- NULL

  subset_path <- character()
  while (
    length(names(spec$fields)) == 1 &&
      spec$fields[[1]]$type %in% c("df", "row", "recursive")
  ) {
    field_name <- names(spec$fields)
    subset_path <- c(subset_path, field_name)
    spec <- tibblify::field_to_tspec(spec, field_name)
  }

  use_simple_json <- length(names(spec$fields)) == 0 ||
    (length(names(spec$fields)) == 1 &&
      !spec$fields[[1]]$type %in% c("df", "row", "recursive"))

  if (use_simple_json) {
    if (length(names(spec$fields)) == 1) {
      subset_path <- c(subset_path, names(spec$fields))
    }
    tidy_policy_body <- if (length(subset_path) > 0) {
      subset_path_str <- .format_subset_path_str(subset_path)
      glue::glue(
        "nectar::tidy_policy_json(subset_path = {subset_path_str}, simplifyVector = TRUE)"
      )
    } else {
      "nectar::tidy_policy_json(simplifyVector = TRUE)"
    }
  } else {
    indented_spec <- cli::ansi_strip(format(
      spec,
      width = 78,
      fully_qualify = TRUE,
      nchar_indent = 2
    ))
    tidy_policy_body <- if (length(subset_path) > 0) {
      subset_path_str <- .format_subset_path_str(subset_path)
      paste0(
        "spec <- ",
        indented_spec,
        "\n  nectar::tidy_policy_json_tibblify(spec = spec, subset_path = ",
        subset_path_str,
        ")"
      )
    } else {
      paste0(
        "spec <- ",
        indented_spec,
        "\n  nectar::tidy_policy_json_tibblify(spec = spec)"
      )
    }
  }

  list(tidy_policy_body = tidy_policy_body, description = description)
}

#' Format a subset_path vector as an R string literal
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) Either `'"name"'` or `'c("a", "b")'`.
#' @keywords internal
.format_subset_path_str <- function(subset_path) {
  if (length(subset_path) == 1) {
    paste0('"', subset_path, '"')
  } else {
    paste0('c(', paste0('"', subset_path, '"', collapse = ", "), ')')
  }
}

#' Prepare parameter metadata
#'
#' @inheritParams .shared-params
#' @returns (`data.frame`) Prepared parameter metadata.
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
#' @returns (`data.frame`) Flattened parameter metadata.
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
#' @returns (`list`) Parameter metadata entries.
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
#' @inheritParams .shared-params
#' @returns (`character`) Generated file paths.
#' @keywords internal
.generate_paths_files <- function(
  paths_by_operation,
  api_abbr,
  security_data,
  pagination_data,
  use_prefix = FALSE
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
    .generate_paths_file(
      op,
      op_id,
      api_abbr,
      security_data,
      use_prefix = use_prefix
    )
  })))

  # One test file per operation
  test_files <- unname(unlist(purrr::imap(prepped, function(op, op_id) {
    .generate_paths_test_file(
      op,
      op_id,
      api_abbr,
      use_prefix = use_prefix
    )
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
#' @returns (`list`) Non-security parameters.
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
#' @returns (`list`) Validation metadata.
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

#' Determine whether generated paths need `tibblify`
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if any path has a JSON response spec.
#' @keywords internal
.paths_need_tibblify <- function(paths) {
  ops <- as_bk_data(paths)
  if (!length(ops)) {
    return(FALSE)
  }
  any(purrr::map_lgl(ops, function(op) {
    op$tidy_policy_body != "nectar::tidy_policy_body_auto()"
  }))
}

#' Generate one operation file
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated file path.
#' @keywords internal
.generate_paths_file <- function(
  path_operation,
  operation_id,
  api_abbr,
  security_data,
  use_prefix = FALSE
) {
  fn_prefix <- if (use_prefix) paste0(api_abbr, "_") else ""
  tidy_policy_body <-
    path_operation$tidy_policy_body %||% "nectar::tidy_policy_body_auto()"
  .bk_use_template(
    template = "paths.R",
    data = c(
      path_operation,
      list(
        api_abbr = api_abbr,
        fn_prefix = fn_prefix,
        tidy_policy_body = tidy_policy_body,
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

#' Generate one operation-level test file
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated test file path.
#' @keywords internal
.generate_paths_test_file <- function(
  path_operation,
  operation_id,
  api_abbr,
  use_prefix = FALSE
) {
  fn_prefix <- if (use_prefix) paste0(api_abbr, "_") else ""
  .bk_use_template(
    template = "test-paths.R",
    data = list(
      tag = path_operation$tag,
      api_abbr = api_abbr,
      fn_prefix = fn_prefix,
      operation_id = operation_id,
      test_args = path_operation$test_args %|0|% ""
    ),
    dir = "tests/testthat",
    target = glue::glue("test-paths-{path_operation$tag}-{operation_id}.R")
  )
}
