test_that("Can prepare a request without errors", {
  test_result <- expect_no_error(guru_req_prepare("testing"))
  expect_s3_class(test_result, c("nectar_request", "httr2_request"))
  expect_contains(names(test_result), "policies")
  expect_contains(names(test_result$policies), "resp_tidy")
})
