# Read saved security metadata

Read prepared security metadata from a YAML file (default name
`_beekeeper_security.yml`) generated via
[`generate_pkg_auth()`](https://beekeeper.api2r.org/reference/generate_pkg_auth.md).

## Usage

``` r
read_security_data(
  pkg_dir = ".",
  config_filename = "_beekeeper.yml",
  security_data_filename = read_security_data_filename(pkg_dir, config_filename)
)
```

## Arguments

- pkg_dir:

  (`character(1)` or `fs_path`) The directory containing package files.

- config_filename:

  (`character(1)` or `fs_path`) The path to a beekeeper yaml config file
  (relative to the package root).

- security_data_filename:

  (`character(1)` or `fs_path`) The path to the saved security metadata
  file (relative to the package root).

## Value

(`list`) Saved security metadata.

## See also

Other config readers:
[`read_api_abbr()`](https://beekeeper.api2r.org/reference/read_api_abbr.md),
[`read_api_definition()`](https://beekeeper.api2r.org/reference/read_api_definition.md),
[`read_api_title()`](https://beekeeper.api2r.org/reference/read_api_title.md),
[`read_config()`](https://beekeeper.api2r.org/reference/read_config.md),
[`read_rapid_filename()`](https://beekeeper.api2r.org/reference/read_rapid_filename.md),
[`read_security_data_filename()`](https://beekeeper.api2r.org/reference/read_security_data_filename.md),
[`read_security_schemes()`](https://beekeeper.api2r.org/reference/read_security_schemes.md)

## Examples

``` r
read_security_data(pkg_dir = fs::path_package("beekeeper", "trello"))
#> $has_security
#> [1] TRUE
#> 
#> $security_schemes
#> $security_schemes[[1]]
#> $security_schemes[[1]]$name
#> [1] "api_key"
#> 
#> $security_schemes[[1]]$description
#> [1] "Example API authentication key used to authorize requests."
#> 
#> $security_schemes[[1]]$parameter_name
#> [1] "key"
#> 
#> $security_schemes[[1]]$arg_name
#> [1] "key"
#> 
#> $security_schemes[[1]]$location
#> [1] "query"
#> 
#> $security_schemes[[1]]$type
#> [1] "api_key"
#> 
#> $security_schemes[[1]]$api_key
#> [1] TRUE
#> 
#> 
#> $security_schemes[[2]]
#> $security_schemes[[2]]$name
#> [1] "api_token"
#> 
#> $security_schemes[[2]]$description
#> [1] "Example API token used to authorize requests."
#> 
#> $security_schemes[[2]]$parameter_name
#> [1] "token"
#> 
#> $security_schemes[[2]]$arg_name
#> [1] "token"
#> 
#> $security_schemes[[2]]$location
#> [1] "query"
#> 
#> $security_schemes[[2]]$type
#> [1] "api_key"
#> 
#> $security_schemes[[2]]$api_key
#> [1] TRUE
#> 
#> 
#> 
#> $security_arg_names
#> [1] "key"   "token"
#> 
#> $security_arg_list
#> [1] "key = key, token = token"
#> 
#> $security_arg_helps
#> $security_arg_helps[[1]]
#> $security_arg_helps[[1]]$name
#> [1] "key"
#> 
#> $security_arg_helps[[1]]$description
#> [1] "Example API authentication key used to authorize requests."
#> 
#> 
#> $security_arg_helps[[2]]
#> $security_arg_helps[[2]]$name
#> [1] "token"
#> 
#> $security_arg_helps[[2]]$description
#> [1] "Example API token used to authorize requests."
#> 
#> 
#> 
#> $security_arg_nulls
#> [1] "key = NULL, token = NULL"
#> 
#> $security_signature
#> [1] "key = Sys.getenv(\"TRELLO_KEY\"),\ntoken = Sys.getenv(\"TRELLO_TOKEN\")"
#> 
```
