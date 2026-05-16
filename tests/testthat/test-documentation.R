test_that("internal helpers have roxygen docs (#noissue)", {
  function_definition_pattern <- "^(`[^`]+`|[A-Za-z0-9._]+)\\s*<-\\s*function\\("
  standalone_pattern <- "import-standalone-"
  r_dir <- test_path("..", "..", "R")
  skip_if_not(fs::dir_exists(r_dir), "R source files are not available.")

  r_files <- fs::dir_ls(
    r_dir,
    glob = "*.R",
    recurse = FALSE
  )
  r_files <- r_files[!grepl(standalone_pattern, r_files)]
  missing_docs <- character()

  has_roxygen_block <- function(lines, line_number) {
    previous <- line_number - 1L
    while (previous > 0L && !nzchar(trimws(lines[[previous]]))) {
      previous <- previous - 1L
    }
    previous > 0L && startsWith(trimws(lines[[previous]]), "#'")
  }

  for (path in r_files) {
    lines <- readLines(path)

    for (line_number in seq_along(lines)) {
      line <- lines[[line_number]]
      regular_match <- regexec(function_definition_pattern, line)[[1]]
      method_match <- FALSE
      if (grepl("^S7::method\\(", line)) {
        lookahead <- paste(
          lines[line_number:min(line_number + 5L, length(lines))],
          collapse = " "
        )
        method_match <- grepl(
          "S7::method\\(.*\\)\\s*<-\\s*function\\(",
          lookahead
        )
      }

      if (regular_match[1] != -1L) {
        object_name <- regmatches(line, regexec(
          function_definition_pattern,
          line
        ))[[1]][2]
      } else {
        object_name <- NULL
      }

      if (
        (is.null(object_name) && !method_match) ||
          has_roxygen_block(lines, line_number)
      ) {
        next
      }

      if (method_match) {
        missing_docs <- c(
          missing_docs,
          paste0(basename(path), "::S7_method@", line_number)
        )
      } else {
        missing_docs <- c(
          missing_docs,
          paste0(basename(path), "::", object_name)
        )
      }
    }
  }

  expect_identical(missing_docs, character())
})
