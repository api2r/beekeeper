# Convert one operation row to template data

Convert one operation row to template data

## Usage

``` r
.path_row_to_list(
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
)
```

## Arguments

- operation_id:

  (`character(1)`) The operation identifier used in generated file
  names.

- endpoint:

  (`character(1)`) The operation endpoint.

- operation:

  (`character(1)`) The HTTP method.

- operation_summary:

  (`character(1)`) The operation summary.

- operation_description:

  (`character(1)`) The operation description.

- tags:

  (`character` or `list`) Tags for all operations.

- parameters:

  (`data.frame`) Operation parameters.

- exclude_from_response:

  (`character`) Field names to remove from response specs before
  generating parsers. Fields matching these names will be dropped from
  the response spec. If only one field remains after exclusion and it is
  of type `"df"`, `"row"`, or `"recursive"`, the spec is simplified so
  that the response parser targets that field directly.

- ...:

  Additional columns, ignored.

## Value

(`list`) One operation description.
