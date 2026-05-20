# Changelog

## beekeeper 0.5.0

- New generation functions
  [`generate_pkg_auth()`](https://beekeeper.api2r.org/reference/generate_pkg_auth.md),
  [`generate_pkg_paths()`](https://beekeeper.api2r.org/reference/generate_pkg_paths.md),
  [`generate_pkg_req_prepare()`](https://beekeeper.api2r.org/reference/generate_pkg_req_prepare.md),
  and
  [`generate_pkg_shared_params()`](https://beekeeper.api2r.org/reference/generate_pkg_shared_params.md)
  allow for more modular API-wrapping package generation
  ([\#101](https://github.com/api2r/beekeeper/issues/101)).
- New read functions
  [`read_api_abbr()`](https://beekeeper.api2r.org/reference/read_api_abbr.md),
  [`read_api_definition()`](https://beekeeper.api2r.org/reference/read_api_definition.md),
  [`read_api_title()`](https://beekeeper.api2r.org/reference/read_api_title.md),
  [`read_config()`](https://beekeeper.api2r.org/reference/read_config.md),
  [`read_rapid_filename()`](https://beekeeper.api2r.org/reference/read_rapid_filename.md),
  [`read_security_data()`](https://beekeeper.api2r.org/reference/read_security_data.md),
  [`read_security_data_filename()`](https://beekeeper.api2r.org/reference/read_security_data_filename.md),
  and
  [`read_security_schemes()`](https://beekeeper.api2r.org/reference/read_security_schemes.md)
  extract pieces needed for building an API-wrapping package
  ([\#82](https://github.com/api2r/beekeeper/issues/82),
  [\#99](https://github.com/api2r/beekeeper/issues/99)).
- [`generate_pkg_paths()`](https://beekeeper.api2r.org/reference/generate_pkg_paths.md)
  now generates a separate R file for each endpoint, rather than a
  single file per tag
  ([\#65](https://github.com/api2r/beekeeper/issues/65)).
- [`generate_pkg_paths()`](https://beekeeper.api2r.org/reference/generate_pkg_paths.md)
  also includes parameter documentation, and parameter validation to
  prevent users from creating API calls that will fail due to passing
  the wrong parameter type
  ([\#69](https://github.com/api2r/beekeeper/issues/69),
  [\#85](https://github.com/api2r/beekeeper/issues/85)).
- Header and cookie parameters are handled properly by
  [`generate_pkg_paths()`](https://beekeeper.api2r.org/reference/generate_pkg_paths.md)
  ([\#84](https://github.com/api2r/beekeeper/issues/84)).
- All functions now have examples, and example configuration data is
  available in `fs::path_package("beekeeper", "guru")` and
  `fs::path_package("beekeeper", "trello")`
  ([\#99](https://github.com/api2r/beekeeper/issues/99)).

## beekeeper 0.4.0

- Added basic scaffolding of endpoint functions (“paths” objects in the
  OpenAPI specification).

## beekeeper 0.3.0

- Added
  [`vignette("pagination")`](https://beekeeper.api2r.org/articles/pagination.md)
  for guidance on how to configure pagination in `beekeeper`-generated
  packages.

## beekeeper 0.2.0

- Spun off a [separate project for API
  discovery](https://anyapi.api2r.org).

## beekeeper 0.1.0

- Basic functionality for creating an api-wrapping R package
  ([\#15](https://github.com/api2r/beekeeper/issues/15),
  [\#16](https://github.com/api2r/beekeeper/issues/16),
  [\#17](https://github.com/api2r/beekeeper/issues/17),
  [\#26](https://github.com/api2r/beekeeper/issues/26),
  [\#35](https://github.com/api2r/beekeeper/issues/35)).
