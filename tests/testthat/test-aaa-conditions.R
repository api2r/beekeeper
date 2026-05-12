test_that(".pkg_abort works", {
  stbl::expect_pkg_error_snapshot(
    .pkg_abort("This is a test error", c("subclass", "test_error")),
    "beekeeper",
    "subclass",
    "test_error"
  )
})
