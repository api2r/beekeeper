pkgload::load_all()
apid_url <- "https://api.apis.guru/v2/specs/apis.guru/2.2.0/openapi.yaml"
api_abbr <- "guru"
pkg_dir <- test_path("_fixtures", api_abbr)
# Clean slate.
fs::dir_delete(fs::path(pkg_dir, "R"))
fs::dir_delete(fs::path(pkg_dir, "testthat"))
apid_url |>
  url() |>
  use_beekeeper(
    api_abbr = api_abbr,
    pkg_dir = pkg_dir,
    config_filename = "_beekeeper.yml",
    rapid_filename = "_beekeeper_rapid.rds"
  )
generate_pkg(pkg_dir = pkg_dir)
# testthat paths are too long for tarballs, so move them up a level.
fs::file_move(
  fs::path(pkg_dir, "tests", "testthat"), 
  fs::path(pkg_dir, "testthat")
)
fs::dir_delete(fs::path(pkg_dir, "tests"))
# R CMD check doesn't like the .Rbuildignore files, and we don't use them.
fs::file_delete(fs::path(pkg_dir, ".Rbuildignore"))

apid_url <- "https://api.apis.guru/v2/specs/fec.gov/1.0/openapi.yaml"
api_abbr <- "fec"
pkg_dir <- test_path("_fixtures", api_abbr)
# Clean slate.
fs::dir_delete(fs::path(pkg_dir, "R"))
fs::dir_delete(fs::path(pkg_dir, "testthat"))
fec_apid <- apid_url |>
  url() |>
  yaml::read_yaml()
fec_apid$security <- list(
  list(ApiKeyHeaderAuth = list(), ApiKeyQueryAuth = list())
)
fec_apid$components$securitySchemes <- list(
  ApiKeyHeaderAuth = list(`in` = "header", name = "X-Api-Key", type = "apiKey"),
  ApiKeyQueryAuth = list(`in` = "query", name = "api_key", type = "apiKey")
)
warning("FEC APID manually cleaned to remove duplicate security scheme.")
fec_rapid <- rapid::as_rapid(fec_apid)
fec_rapid |>
  use_beekeeper(
    api_abbr = api_abbr,
    pkg_dir = pkg_dir,
    config_filename = "_beekeeper.yml",
    rapid_filename = "_beekeeper_rapid.rds"
  )
fec_rapid@paths <- rapid::as_paths({
  x <- fec_rapid@paths |>
    tibble::as_tibble() |>
    tidyr::hoist(operations, tags = "tags", .remove = FALSE)
  x$tags <- unlist(x$tags)
  x <- x[x$tags %in% c("audit", "debts", "legal"), ]
  x$tags <- NULL
  x
})
fec_rapid |>
  use_beekeeper(
    api_abbr = api_abbr,
    pkg_dir = pkg_dir,
    config_filename = "fec_subset_beekeeper.yml",
    rapid_filename = "fec_subset_rapid.rds"
  )
generate_pkg(config_filename = "fec_subset_beekeeper.yml", pkg_dir = pkg_dir)
# testthat paths are too long for tarballs, so move them up a level.
fs::file_move(
  fs::path(pkg_dir, "tests", "testthat"), 
  fs::path(pkg_dir, "testthat")
)
fs::dir_delete(fs::path(pkg_dir, "tests"))
# R CMD check doesn't like the .Rbuildignore files, and we don't use them.
fs::file_delete(fs::path(pkg_dir, ".Rbuildignore"))

apid_url <- "https://api.apis.guru/v2/specs/trello.com/1.0/openapi.yaml"
api_abbr <- "trello"
pkg_dir <- test_path("_fixtures", api_abbr)
# Clean slate.
fs::dir_delete(fs::path(pkg_dir, "R"))
fs::dir_delete(fs::path(pkg_dir, "testthat"))
trello_rapid <- apid_url |>
  url() |>
  rapid::as_rapid()
trello_rapid@paths <- rapid::as_paths({
  x <- trello_rapid@paths |>
    tibble::as_tibble() |>
    tidyr::unnest(operations)
  x[x$tags == "board", ] |>
    head(1) |>
    tidyr::nest(.by = "endpoint", .key = "operations")
})
trello_rapid |>
  use_beekeeper(
    api_abbr = api_abbr,
    pkg_dir = pkg_dir,
    config_filename = "_beekeeper.yml",
    rapid_filename = "_beekeeper_rapid.rds"
  )
generate_pkg(pkg_dir = pkg_dir)
# testthat paths are too long for tarballs, so move them up a level.
fs::file_move(
  fs::path(pkg_dir, "tests", "testthat"), 
  fs::path(pkg_dir, "testthat")
)
fs::dir_delete(fs::path(pkg_dir, "tests"))
# R CMD check doesn't like the .Rbuildignore files, and we don't use them.
fs::file_delete(fs::path(pkg_dir, ".Rbuildignore"))
