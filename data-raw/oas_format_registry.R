oas_format_registry_raw <- rvest::read_html(
  "https://spec.openapis.org/registry/format/"
)

oas_format_registry <-
  oas_format_registry_raw |>
  rvest::html_table() |>
  _[[1]] |>
  janitor::clean_names() |>
  dplyr::mutate(
    json_data_type = stringr::str_split(.data$json_data_type, ", "),
    source = dplyr::na_if(.data$source, ""),
    deprecated = .data$deprecated == "Yes"
  ) |>
  tidyr::unnest_longer("json_data_type") |>
  dplyr::select(
    type = "json_data_type",
    format = "value" #, UNCOMMENT THESE TO DIG INTO FORMATS
    # "description",
    # "source",
    # "deprecated"
  ) |>
  dplyr::arrange(.data$type, .data$format) |>
  dplyr::bind_rows(
    data.frame(
      type = c(
        "boolean",
        "integer",
        "null",
        "number",
        "string"
      )
    )
  ) |>
  dplyr::mutate(
    # TODO: Sort out exactly how this works. tibblify will process things. Can
    # I make it give these things a class, and then stabilize back and forth
    # via that?
    #
    # nectar re-exports from stbl, and adds HTTP-specific wrappers
    to_r = dplyr::case_when(
      ## Null
      .data$type == "null" ~ "todo_to_null",
      ## Numbers
      .data$format == "int64" ~ "todo_to_int64_scalar",
      stringr::str_detect(.data$format, "int") ~ "to_int_scalar",
      stringr::str_detect(.data$type, "int") ~ "to_int_scalar",
      .data$type == "number" ~ "to_dbl_scalar",
      stringr::str_detect(.data$format, "decimal") ~ "to_dbl_scalar",
      ## Dates and times
      .data$format %in% c("date", "http-date") ~ "todo_to_date_scalar",
      .data$format == "date-time" ~ "todo_to_datetime_scalar",
      .data$format == "duration" ~ "todo_to_duration_scalar",
      .data$format == "time" ~ "todo_to_time_scalar",
      ## Binary
      .data$format %in%
        c("byte", "sf-binary") ~ "todo_stabilize_base64_to_chr_scalar",
      .data$format == "binary" ~ "todo_stabilize_binary_to_raw",
      .data$format == "base64url" ~ "todo_stabilize_base64url_to_chr_scalar",
      ## Logical
      .data$format == "sf-boolean" ~ "todo_to_structured_lgl_scalar",
      .data$type == "boolean" ~ "to_lgl_scalar",
      ## Specific Strings
      .data$format == "uuid" ~ "todo_to_uuid_scalar",
      # TODO: Add more specific string formats.
      .default = "to_chr_scalar"
    ),
    r_class_name = dplyr::replace_values(
      .data$to_r,
      "todo_stabilize_base64_to_chr_scalar" ~ "character",
      "todo_stabilize_base64url_to_chr_scalar" ~ "character",
      "todo_stabilize_binary_to_raw" ~ "raw",
      "to_chr_scalar" ~ "character",
      "todo_to_date_scalar" ~ "Date",
      "todo_to_datetime_scalar" ~ "POSIXct",
      "to_dbl_scalar" ~ "double",
      "todo_to_duration_scalar" ~ "Duration",
      "to_int_scalar" ~ "integer",
      "todo_to_int64_scalar" ~ "integer64",
      "to_lgl_scalar" ~ "logical",
      "todo_to_null" ~ "NULL",
      "todo_to_structured_lgl_scalar" ~ "logical",
      "todo_to_time_scalar" ~ "hms",
      "todo_to_uuid_scalar" ~ "UUID"
    ),
    r_class_package = dplyr::recode_values(
      .data$r_class_name,
      "Duration" ~ "lubridate",
      "integer64" ~ "bit64",
      "hms" ~ "hms",
      "UUID" ~ "uuid",
      default = "base"
    ),
    r_class_link = dplyr::recode_values(
      .data$r_class_name,
      "Duration" ~ "Duration-class",
      default = .data$r_class_name
    )
  )

usethis::use_data(oas_format_registry, overwrite = TRUE, internal = TRUE)
rm(oas_format_registry_raw, oas_format_registry)
