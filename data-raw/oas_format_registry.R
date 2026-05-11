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
      .data$type == "null" ~ "stabilize_null",
      ## Numbers
      .data$format == "int64" ~ "stabilize_int64",
      stringr::str_detect(.data$format, "int") ~ "stabilize_int",
      stringr::str_detect(.data$type, "int") ~ "stabilize_int",
      .data$type == "number" ~ "stabilize_dbl",
      stringr::str_detect(.data$format, "decimal") ~ "stabilize_dbl",
      ## Dates and times
      .data$format %in% c("date", "http-date") ~ "stabilize_date",
      .data$format == "date-time" ~ "stabilize_datetime",
      .data$format == "duration" ~ "stabilize_duration",
      .data$format == "time" ~ "stabilize_time",
      ## Binary
      .data$format %in% c("byte", "sf-binary") ~ "stabilize_base64_to_chr",
      .data$format == "binary" ~ "stabilize_binary_to_raw",
      .data$format == "base64url" ~ "stabilize_base64url_to_chr",
      ## Logical
      .data$format == "sf-boolean" ~ "stabilize_structured_lgl",
      .data$type == "boolean" ~ "stabilize_lgl",
      ## Specific Strings
      .data$format == "uuid" ~ "stabilize_uuid",
      # TODO: Add more specific string formats.
      .default = "stabilize_chr"
    ),
    r_class_name = dplyr::case_match(
      .data$to_r,
      "stabilize_base64_to_chr" ~ "character",
      "stabilize_base64url_to_chr" ~ "character",
      "stabilize_binary_to_raw" ~ "raw",
      "stabilize_chr" ~ "character",
      "stabilize_date" ~ "Date",
      "stabilize_datetime" ~ "POSIXct",
      "stabilize_dbl" ~ "double",
      "stabilize_duration" ~ "Duration",
      "stabilize_int" ~ "integer",
      "stabilize_int64" ~ "integer64",
      "stabilize_lgl" ~ "logical",
      "stabilize_null" ~ "NULL",
      "stabilize_structured_lgl" ~ "logical",
      "stabilize_time" ~ "hms",
      "stabilize_uuid" ~ "UUID"
    ),
    r_class_package = dplyr::case_match(
      .data$r_class_name,
      "Duration" ~ "lubridate",
      "integer64" ~ "bit64",
      "hms" ~ "hms",
      "UUID" ~ "uuid",
      .default = "base"
    ),
    r_class_link = dplyr::case_match(
      .data$r_class_name,
      "Duration" ~ "Duration-class",
      .default = .data$r_class_name
    )
  )

usethis::use_data(oas_format_registry, overwrite = TRUE)
rm(oas_format_registry_raw, oas_format_registry)
