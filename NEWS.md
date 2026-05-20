# beekeeper 0.5.0

* New generation functions `generate_pkg_auth()`, `generate_pkg_paths()`, `generate_pkg_req_prepare()`, and `generate_pkg_shared_params()` allow for more modular API-wrapping package generation (#101).
* New read functions `read_api_abbr()`, `read_api_definition()`, `read_api_title()`, `read_config()`, `read_rapid_filename()`, `read_security_data()`, `read_security_data_filename()`, and `read_security_schemes()` extract pieces needed for building an API-wrapping package (#82, #99).
* `generate_pkg_paths()` now generates a separate R file for each endpoint, rather than a single file per tag (#65).
* `generate_pkg_paths()` also includes parameter documentation, and parameter validation to prevent users from creating API calls that will fail due to passing the wrong parameter type (#69, #85).
* Header and cookie parameters are handled properly by `generate_pkg_paths()` (#84).
* All functions now have examples, and example configuration data is available in `fs::path_package("beekeeper", "guru")` and `fs::path_package("beekeeper", "trello")` (#99).

# beekeeper 0.4.0

* Added basic scaffolding of endpoint functions ("paths" objects in the OpenAPI specification).

# beekeeper 0.3.0

* Added `vignette("pagination")` for guidance on how to configure pagination in `beekeeper`-generated packages.

# beekeeper 0.2.0

* Spun off a [separate project for API discovery](https://anyapi.api2r.org).

# beekeeper 0.1.0

* Basic functionality for creating an api-wrapping R package (#15, #16, #17, #26, #35).
