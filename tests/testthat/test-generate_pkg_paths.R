test_that(".generate_paths() returns empty character for empty paths (#65)", {
  skip_on_cran()
  result <- .generate_paths(
    paths = rapid::class_paths(),
    api_abbr = "test",
    security_data = list(),
    base_url = "https://example.com"
  )
  expect_identical(result, character())
})

test_that(".generate_paths() calls correct templates for guru (#65, #112)", {
  # 1 tag, no security
  skip_on_cran()
  config <- guru_config
  api_definition <- guru_api_definition
  spy <- make_spy_impl()
  local_mocked_bindings(.bk_use_template_impl = spy$mock)

  result <- .generate_paths(
    paths = api_definition@paths,
    api_abbr = config$api_abbr,
    security_data = list(),
    base_url = api_definition@servers@url
  )

  calls <- spy$calls()

  expect_identical(
    basename(result),
    c(
      "paths-apis-list_apis.R",
      "paths-apis-get_metrics.R",
      "paths-apis-get_providers.R",
      "paths-apis-get_api.R",
      "paths-apis-get_service_api.R",
      "paths-apis-get_provider.R",
      "paths-apis-get_services.R",
      "test-paths-apis.R",
      "setup.R"
    )
  )

  # 7 paths.R calls + 1 test-paths.R call + 1 setup.R call
  expect_length(calls, 9L)
  expect_identical(
    purrr::map_chr(calls, "template"),
    c(rep("paths.R", 7L), "test-paths.R", "setup.R")
  )

  # Spot-check data for the first (simplest) path call
  first <- calls[[1]]$data
  expect_identical(first$operation_id, "list_apis")
  expect_identical(first$tag, "apis")
  expect_identical(first$method, "get")
  expect_false(first$has_security)

  # Spot-check a path call that has path parameters
  get_api <- calls[[4]]$data
  expect_identical(get_api$operation_id, "get_api")
  expect_length(get_api$params, 2L)

  # Check test-paths.R data
  test_call <- calls[[8]]
  expect_identical(test_call$dir, "tests/testthat")
  expect_identical(test_call$target, "test-paths-apis.R")
  expect_length(test_call$data$paths, 7L)

  # Check setup.R data
  setup_call <- calls[[9]]
  expect_identical(setup_call$dir, "tests/testthat")
  expect_identical(setup_call$data$base_url, api_definition@servers@url)
})

test_that(".generate_paths() writes correct templates for guru (#65, #112)", {
  # Visual confirmation that paths.R, test-paths.R, and setup.R render correctly
  skip_on_cran()
  config <- guru_config
  api_definition <- guru_api_definition
  expected_path_contents <- load_expected_files("guru", "/paths-.+\\.R$")
  expected_test_contents <- load_expected_files("guru", "/test-paths-.+\\.R$")
  expected_setup_content <- readLines(test_path(
    "_fixtures",
    "guru",
    "testthat",
    "setup.R"
  ))

  tmp <- withr::local_tempdir()
  local_mocked_bindings(.bk_use_template_impl = make_writing_impl(tmp))

  .generate_paths(
    paths = api_definition@paths,
    api_abbr = config$api_abbr,
    security_data = list(),
    base_url = api_definition@servers@url
  )

  purrr::iwalk(expected_path_contents, \(expected, name) {
    expect_identical(readLines(fs::path(tmp, "R", name)), expected)
  })
  purrr::iwalk(expected_test_contents, \(expected, name) {
    expect_identical(
      readLines(fs::path(tmp, "tests", "testthat", name)),
      expected
    )
  })
  expect_identical(
    readLines(fs::path(tmp, "tests", "testthat", "setup.R")),
    expected_setup_content
  )
})

test_that(".generate_paths() calls correct templates for fec (#65, #112)", {
  # 3 tags (audit, debts, legal), more complicated security
  skip_on_cran()
  config <- fec_config
  api_definition <- fec_api_definition
  spy <- make_spy_impl()
  local_mocked_bindings(.bk_use_template_impl = spy$mock)

  security_data <- .generate_security(
    config$api_abbr,
    api_definition@components@security_schemes
  )
  result <- .generate_paths(
    paths = api_definition@paths,
    api_abbr = config$api_abbr,
    security_data = security_data,
    base_url = api_definition@servers@url
  )

  calls <- spy$calls()

  expect_identical(
    basename(result),
    c(
      "paths-audit-get_audit_case.R",
      "paths-audit-get_audit_category.R",
      "paths-audit-get_audit_primary_category.R",
      "paths-legal-get_legal_search.R",
      "paths-audit-get_names_audit_candidates.R",
      "paths-audit-get_names_audit_committees.R",
      "paths-debts-get_schedules_schedule_d.R",
      "paths-debts-get_schedules_schedule_d_sub_id.R",
      "test-paths-audit.R",
      "test-paths-legal.R",
      "test-paths-debts.R",
      "setup.R"
    )
  )

  # 1 auth + 8 path R files + 3 test files + 1 setup = 13 calls
  expect_length(calls, 13L)

  # Security data should be threaded through to paths (.generate_security()
  # wrote the auth file as calls[[1]], so paths start at calls[[2]])
  first_path <- calls[[2]]$data
  expect_true(first_path$has_security)
  expect_identical(first_path$api_abbr, "fec")
})

test_that(".generate_paths() writes correct paths.R for fec (#65, #112)", {
  # Visual confirmation: 3 tags, complicated security
  skip_on_cran()
  config <- fec_config
  api_definition <- fec_api_definition
  expected_file_content <- readLines(
    test_path(
      "_fixtures",
      "fec",
      "R",
      "paths-audit-get_names_audit_candidates.R"
    )
  )

  tmp <- withr::local_tempdir()
  local_mocked_bindings(.bk_use_template_impl = make_writing_impl(tmp))

  security_data <- .generate_security(
    config$api_abbr,
    api_definition@components@security_schemes
  )
  .generate_paths(
    paths = api_definition@paths,
    api_abbr = config$api_abbr,
    security_data = security_data,
    base_url = api_definition@servers@url
  )

  expect_identical(
    readLines(fs::path(tmp, "R", "paths-audit-get_names_audit_candidates.R")),
    expected_file_content
  )
})

test_that(".generate_paths() writes correct paths.R for trello (#65, #112)", {
  # Visual confirmation: more complicated security
  skip_on_cran()
  config <- trello_config
  api_definition <- trello_api_definition
  expected_file_content <- readLines(
    test_path("_fixtures", "trello", "R", "paths-board-add_boards.R")
  )

  tmp <- withr::local_tempdir()
  local_mocked_bindings(.bk_use_template_impl = make_writing_impl(tmp))

  security_data <- .generate_security(
    config$api_abbr,
    api_definition@components@security_schemes
  )
  .generate_paths(
    paths = api_definition@paths,
    api_abbr = config$api_abbr,
    security_data = security_data,
    base_url = api_definition@servers@url
  )

  expect_identical(
    readLines(fs::path(tmp, "R", "paths-board-add_boards.R")),
    expected_file_content
  )
})

test_that(".compile_param_class_descriptions() uses class names (#85)", {
  type <- tibble::tibble(r_class_name = c("character", "Date"))
  result <- .compile_param_class_descriptions(
    type = type,
    allow_empty = c(FALSE, TRUE),
    required = c(TRUE, FALSE)
  )

  expect_identical(
    as.character(result),
    c(
      "length-1 `character`",
      "length-1 `Date` or `NULL`, optional"
    )
  )
})

test_that(".params_to_validations() only includes supported checks (#69)", {
  params <- list(
    list(name = "q", to_r = "to_chr_scalar"),
    list(name = "from", to_r = "todo_to_date_scalar"),
    list(name = "x", to_r = NA_character_)
  )

  expect_identical(
    .params_to_validations(params),
    list(list(name = "q", to_r = "to_chr_scalar"))
  )
})

test_that(".paths_need_stbl() flags actionable validations (#69)", {
  api_definition_true <- guru_api_definition

  expect_true(
    .paths_need_stbl(
      api_definition_true@paths,
      character()
    )
  )
})

test_that(".paths_need_stbl() returns FALSE for empty paths (#69)", {
  expect_false(.paths_need_stbl(rapid::class_paths(), character()))
})

test_that("generate_pkg_paths() reads saved inputs from config (#101)", {
  skip_on_cran()
  config_text <- readLines(test_path("_fixtures", "guru", "_beekeeper.yml"))
  path_expected <- readLines(test_path(
    "_fixtures",
    "guru",
    "R",
    "paths-apis-list_apis.R"
  ))

  create_local_package()
  writeLines(config_text, "_beekeeper.yml")
  saveRDS(guru_api_definition, "_beekeeper_rapid.rds")
  generate_pkg_auth()

  test_result <- generate_pkg_paths()

  expect_contains(basename(test_result), "setup.R")
  expect_identical(
    scrub_testpkg(readLines("R/paths-apis-list_apis.R")),
    path_expected
  )
})

test_that(".generate_paths_file() renders header and cookie params correctly (#84, #69)", {
  skip_on_cran()
  expected_content <- readLines(
    test_path("_fixtures", "header_cookie", "paths-things-search_things.R")
  )

  tmp <- withr::local_tempdir()
  local_mocked_bindings(.bk_use_template_impl = make_writing_impl(tmp))

  op <- list(
    operation_id = "search_things",
    tag = "things",
    path = '"/things"',
    method = "get",
    operation_summary = "Search things",
    operation_description = "Search for things.",
    params = list(
      list(
        name = "x_auth_token",
        class = "length-1 `character`",
        description = "Authentication token",
        to_r = "to_chr_scalar"
      ),
      list(
        name = "session_id",
        class = "length-1 `character`",
        description = "Session identifier",
        to_r = "to_chr_scalar"
      ),
      list(
        name = "q",
        class = "length-1 `character`",
        description = "Search query",
        to_r = "to_chr_scalar"
      )
    ),
    params_query = "q = q",
    params_header = "x_auth_token = x_auth_token",
    params_cookie = "session_id = session_id",
    args = "x_auth_token, session_id, q",
    args_named = "x_auth_token = x_auth_token, session_id = session_id, q = q",
    validations = list(
      list(name = "x_auth_token", to_r = "to_chr_scalar"),
      list(name = "session_id", to_r = "to_chr_scalar"),
      list(name = "q", to_r = "to_chr_scalar")
    ),
    test_args = "x_auth_token, session_id, q",
    pagination = FALSE,
    pagination_fn = "",
    tidy_policy_body = "nectar::tidy_policy_body_auto()"
  )
  .generate_paths_file(op, "search_things", "test", list())

  expect_identical(
    readLines(fs::path(tmp, "R", "paths-things-search_things.R")),
    expected_content
  )
})

test_that(".extract_response_info() returns body_auto for NULL responses (#115)", {
  result <- .extract_response_info(NULL)
  expect_identical(result$tidy_policy_body, "nectar::tidy_policy_body_auto()")
  expect_identical(result$description, "")
})

test_that(".extract_response_info() returns body_auto for empty responses (#115)", {
  result <- .extract_response_info(
    tibble::tibble(status_code = character())
  )
  expect_identical(result$tidy_policy_body, "nectar::tidy_policy_body_auto()")
})

test_that(".extract_response_info() returns body_auto when no 200 or default status (#115)", {
  responses <- tibble::tibble(
    status_code = "404",
    description = "Not found",
    headers = list(NULL),
    content = list(tibble::tibble(
      media_type = "application/json",
      spec = list(tibblify::tspec_row(tibblify::tib_chr("msg")))
    )),
    links = list(NULL)
  )
  result <- .extract_response_info(responses)
  expect_identical(result$tidy_policy_body, "nectar::tidy_policy_body_auto()")
})

test_that(".extract_response_info() returns body_auto when 200 has no JSON content (#115)", {
  responses <- tibble::tibble(
    status_code = "200",
    description = "XML only",
    headers = list(NULL),
    content = list(tibble::tibble(
      media_type = "application/xml",
      spec = list(NULL)
    )),
    links = list(NULL)
  )
  result <- .extract_response_info(responses)
  expect_identical(result$tidy_policy_body, "nectar::tidy_policy_body_auto()")
})

test_that(".extract_response_info() returns body_auto when JSON spec is NULL (#115)", {
  responses <- tibble::tibble(
    status_code = "200",
    description = "No schema",
    headers = list(NULL),
    content = list(tibble::tibble(
      media_type = "application/json",
      spec = list(NULL)
    )),
    links = list(NULL)
  )
  result <- .extract_response_info(responses)
  expect_identical(result$tidy_policy_body, "nectar::tidy_policy_body_auto()")
})

test_that(".extract_response_info() builds spec-based tidy_policy for 200 JSON response (#115)", {
  spec <- tibblify::tspec_row(tibblify::tib_chr("id", .required = FALSE))
  responses <- tibble::tibble(
    status_code = "200",
    description = "Success",
    headers = list(NULL),
    content = list(tibble::tibble(
      media_type = "application/json",
      spec = list(spec)
    )),
    links = list(NULL)
  )
  result <- .extract_response_info(responses)
  expect_identical(result$description, "Success")
  expect_match(result$tidy_policy_body, "tibblify::tspec_row")
  expect_match(result$tidy_policy_body, "nectar::tidy_policy_json")
  expect_match(result$tidy_policy_body, "tib_chr")
})

test_that(".extract_response_info() falls back to default when no 200 status (#115)", {
  spec <- tibblify::tspec_row(tibblify::tib_chr("fallback", .required = FALSE))
  responses <- tibble::tibble(
    status_code = "default",
    description = "Default response",
    headers = list(NULL),
    content = list(tibble::tibble(
      media_type = "application/json",
      spec = list(spec)
    )),
    links = list(NULL)
  )
  result <- .extract_response_info(responses)
  expect_identical(result$description, "Default response")
  expect_match(result$tidy_policy_body, "fallback")
})

test_that(".extract_response_info() prefers 200 over default (#115)", {
  spec_200 <- tibblify::tspec_row(tibblify::tib_chr(
    "from_200",
    .required = FALSE
  ))
  spec_default <- tibblify::tspec_row(tibblify::tib_chr(
    "from_default",
    .required = FALSE
  ))
  responses <- tibble::tibble(
    status_code = c("default", "200"),
    description = c("Default", "OK"),
    headers = list(NULL, NULL),
    content = list(
      tibble::tibble(
        media_type = "application/json",
        spec = list(spec_default)
      ),
      tibble::tibble(media_type = "application/json", spec = list(spec_200))
    ),
    links = list(NULL, NULL)
  )
  result <- .extract_response_info(responses)
  expect_identical(result$description, "OK")
  expect_match(result$tidy_policy_body, "from_200")
  expect_no_match(result$tidy_policy_body, "from_default")
})

test_that(".paths_need_tibblify() returns TRUE when paths have JSON specs (#115)", {
  expect_true(.paths_need_tibblify(fec_api_definition@paths))
})

test_that(".paths_need_tibblify() returns TRUE for empty tspec_row specs (#115)", {
  expect_true(.paths_need_tibblify(guru_api_definition@paths))
})

test_that(".paths_need_tibblify() returns FALSE when no paths have JSON specs (#115)", {
  expect_false(.paths_need_tibblify(trello_api_definition@paths))
})

test_that(".paths_need_tibblify() returns FALSE for empty paths (#115)", {
  expect_false(.paths_need_tibblify(rapid::class_paths()))
})
