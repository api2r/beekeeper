test_that("internal helpers have roxygen docs (#noissue)", {
  r_files <- fs::dir_ls(
    test_path("..", "..", "R"),
    glob = "*.R",
    recurse = FALSE
  )
  r_files <- r_files[!grepl("import-standalone-", r_files)]
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
      regular_match <- regexec(
        "^(`[^`]+`|[A-Za-z0-9._]+)\\s*<-\\s*function\\(",
        line
      )[[1]]
      method_match <- grepl(
        "^S7::method\\([^\\n]+\\)\\s*<-\\s*function\\(",
        line
      )

      if (regular_match[1] != -1L) {
        object_name <- regmatches(
          line,
          regexec(
            "^(`[^`]+`|[A-Za-z0-9._]+)\\s*<-\\s*function\\(",
            line
          )
        )[[1]][2]
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
