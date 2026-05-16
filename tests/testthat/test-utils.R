test_that("%||% works (#noissue)", {
  expect_identical(NULL %||% "foo", "foo")
  expect_identical("foo" %||% "bar", "foo")
})

test_that("%&&% works (#noissue)", {
  expect_null(NULL %&&% "foo")
  expect_identical("foo" %&&% "bar", "bar")
})

test_that("%|0|% works (#noissue)", {
  expect_identical(character() %|0|% "foo", "foo")
  expect_identical("foo" %|0|% "bar", "foo")
})

test_that("%|\"|% works (#noissue)", {
  expect_identical("" %|a|% "foo", "foo")
  expect_identical("foo" %|a|% "bar", "foo")
})

test_that("%|% works (#52)", {
  expect_identical((c("a", NA) %|% "y"), c("a", "y"))
  expect_identical((c(NA, NA) %|% "y"), c("y", "y"))
  expect_identical((c(NA, NA) %|% c("x", "y")), c("x", "y"))
})

test_that(".collapse_comma() works (#noissue)", {
  expect_identical(.collapse_comma(c("a", "b", "c")), "a, b, c")
})

test_that(".collapse_comma_newline() works (#noissue)", {
  expect_identical(.collapse_comma_newline(c("a", "b")), "a,\nb")
})

test_that(".collapse_quote_comma() works (#noissue)", {
  expect_identical(.collapse_quote_comma(c("a", "b")), '"a", "b"')
})

test_that(".collapse_comma_self_equal() works (#noissue)", {
  expect_identical(.collapse_comma_self_equal(c("a", "b")), "a = a, b = b")
})

test_that(".paste0_if() works (#noissue)", {
  expect_identical(.paste0_if("x", TRUE, "!"), "x!")
  expect_identical(.paste0_if("x", FALSE, "!"), "x")
})

test_that(".glue_pipe_brace() works (#noissue)", {
  x <- "world"
  expect_identical(.glue_pipe_brace("hello |{x}|"), "hello world")
})

test_that(".to_snake() works (#noissue)", {
  expect_identical(.to_snake("camelCase"), "camel_case")
})

test_that(".flatten_df() returns data frame unchanged (#noissue)", {
  df <- data.frame(x = 1:2)
  expect_identical(.flatten_df(df), df)
})

test_that(".flatten_df() row-binds a list of data frames (#noissue)", {
  result <- .flatten_df(list(data.frame(x = 1), data.frame(x = 2)))
  expect_equal(result, data.frame(x = c(1, 2)))
})

test_that(".flatten_df() returns empty data frame for NULL (#noissue)", {
  expect_equal(.flatten_df(NULL), data.frame())
})
