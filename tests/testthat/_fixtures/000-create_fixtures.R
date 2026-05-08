apid_url <- "https://api.apis.guru/v2/specs/apis.guru/2.2.0/openapi.yaml"
api_abbr <- "guru"
rapid_write_path <- test_path(glue::glue("_fixtures/{api_abbr}_rapid.rds"))
config_path <- test_path(glue::glue("_fixtures/{api_abbr}_beekeeper.yml"))
apid_url |>
  url() |>
  use_beekeeper(
    api_abbr = api_abbr,
    config_file = config_path,
    rapid_file = rapid_write_path
  )

apid_url <- "https://api.apis.guru/v2/specs/fec.gov/1.0/openapi.yaml"
api_abbr <- "fec"
rapid_write_path <- test_path(glue::glue("_fixtures/{api_abbr}_rapid.rds"))
config_path <- test_path(glue::glue("_fixtures/{api_abbr}_beekeeper.yml"))
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
cli::cli_warn("FEC APID manually cleaned to remove duplicate security scheme.")
fec_rapid <- rapid::as_rapid(fec_apid)
fec_rapid |>
  use_beekeeper(
    api_abbr = api_abbr,
    config_file = config_path,
    rapid_file = rapid_write_path
  )
fec_rapid@paths <- rapid::as_paths({
  x <- fec_rapid@paths |>
    tibble::as_tibble() |>
    tidyr::hoist(operations, tags = "tags", .remove = FALSE)
  x <- x[x$tags %in% c("audit", "debts", "legal"), ]
  x$tags <- NULL
  x
})
rapid_write_path <- test_path(glue::glue(
  "_fixtures/{api_abbr}_subset_rapid.rds"
))
config_path <- test_path(glue::glue(
  "_fixtures/{api_abbr}_subset_beekeeper.yml"
))
fec_rapid |>
  use_beekeeper(
    api_abbr = api_abbr,
    config_file = config_path,
    rapid_file = rapid_write_path
  )

apid_url <- "https://api.apis.guru/v2/specs/trello.com/1.0/openapi.yaml"
api_abbr <- "trello"
rapid_write_path <- test_path(glue::glue("_fixtures/{api_abbr}_rapid.rds"))
config_path <- test_path(glue::glue("_fixtures/{api_abbr}_beekeeper.yml"))
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
    config_file = config_path,
    rapid_file = rapid_write_path
  )

cli::cli_warn("Revert .Rbuildignore")
