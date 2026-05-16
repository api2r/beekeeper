# Inspired by https://github.com/r-lib/usethis tests/testthat/helper.R

create_local_package <- function(pkgname = "testpkg", env = parent.frame()) {
  withr::local_options(usethis.quiet = TRUE, .local_envir = env)

  dir <- withr::local_tempdir(pattern = pkgname, .local_envir = env)
  dir <- unclass(fs::path_norm(dir))

  usethis::create_package(
    dir,
    fields = list(
      "Config/testthat/edition" = "3"
    ),
    rstudio = TRUE,
    open = FALSE,
    check_name = FALSE
  )

  usethis::local_project(dir, quiet = TRUE, .local_envir = env)

  invisible(dir)
}

scrub_testpkg <- function(text) {
  gsub("testpkg[a-zA-Z0-9]+", "TESTPKG", text, perl = TRUE)
}

scrub_updated <- function(input) {
  sub(
    "updated_on:.*$",
    "updated_on: DATETIME",
    input
  )
}

scrub_rapid_file_location <- function(input) {
  sub(
    "rapid_file: .*$",
    "rapid_file: RAPID_FILE_PATH",
    input
  )
}

scrub_config <- function(input) {
  stringr::str_trim(scrub_updated(scrub_rapid_file_location(input)))
}

scrub_tempdir <- function(input) {
  sub("^.*Rtmp\\S+", "TMPDIR", input)
}

scrub_path <- function(input, keep_dirs = c("R", "tests")) {
  dirs_string <- paste0(keep_dirs, collapse = "|")
  search <- glue::glue("^.*(/({dirs_string})/)")
  stringr::str_replace(input, search, "\\1")
}

# Find all fixture files matching a regexp and read their contents.
# Returns a named list of character vectors, where names are the fixture
# filenames.
load_expected_files <- function(api_abbr, regexp) {
  test_dir <- test_path("_fixtures", api_abbr)
  files <- fs::dir_ls(test_dir, regexp = regexp)
  names(files) <- fs::path_file(files)
  purrr::map(files, readLines)
}

# A mock for .bk_use_template_impl() that records calls and returns a
# predictable path, without writing any files or needing a usethis project.
make_spy_impl <- function() {
  calls <- list()
  list(
    mock = function(template, data, target, dir) {
      calls[[length(calls) + 1]] <<- list(
        template = template,
        data = data,
        target = target,
        dir = dir
      )
      fs::path(dir, target)
    },
    calls = function() calls
  )
}

# A mock that renders templates to a temp dir using whisker directly, so the
# output can be visually confirmed against fixture files.
make_writing_impl <- function(tmp) {
  function(template, data, target, dir) {
    template_path <- system.file("templates", template, package = "beekeeper")
    rendered <- whisker::whisker.render(
      readLines(template_path, warn = FALSE),
      data
    )
    out_dir <- fs::path(tmp, dir)
    fs::dir_create(out_dir)
    out_path <- fs::path(out_dir, target)
    writeLines(strsplit(rendered, "\n", fixed = TRUE)[[1]], out_path)
    out_path
  }
}

guru_config <- read_config(pkg_dir = test_path("_fixtures", "guru"))
guru_api_definition <- read_api_definition(
  pkg_dir = test_path("_fixtures", "guru")
)
trello_config <- read_config(pkg_dir = test_path("_fixtures", "trello"))
trello_api_definition <- read_api_definition(
  pkg_dir = test_path("_fixtures", "trello")
)
fec_config <- read_config(
  pkg_dir = test_path("_fixtures", "fec"),
  config_file = "fec_subset_beekeeper.yml"
)
fec_api_definition <- read_api_definition(
  pkg_dir = test_path("_fixtures", "fec"),
  rapid_file = "fec_subset_rapid.rds"
)
