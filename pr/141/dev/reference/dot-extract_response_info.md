# Extract response information for template use

Finds the JSON response (preferring `status_code == "200"`, falling back
to `"default"`) and extracts the tibblify spec and description.

## Usage

``` r
.extract_response_info(responses, exclude_from_response = character())
```

## Arguments

- exclude_from_response:

  (`character`) Field names to remove from response specs before
  generating parsers. Fields matching these names will be dropped from
  the response spec. If only one field remains after exclusion and it is
  of type `"df"`, `"row"`, or `"recursive"`, the spec is simplified so
  that the response parser targets that field directly.

## Value

(`list`) A list with `tidy_policy_body` (character) and `description`
(character).
