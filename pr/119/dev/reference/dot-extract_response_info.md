# Extract response information for template use

Finds the JSON response (preferring `status_code == "200"`, falling back
to `"default"`) and extracts the tibblify spec and description.

## Usage

``` r
.extract_response_info(responses)
```

## Value

(`list`) A list with `tidy_policy_body` (character) and `description`
(character).
