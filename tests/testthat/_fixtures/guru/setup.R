library(httptest2)

# Don't repeat the base url in httptest2 recording paths. This helps avoid
# issues with long paths on Windows.
set_redactor(function(x) {
  gsub_response(
    x,
    nectar::url_path_append("https://api.apis.guru/v2", "/"),
    "",
    fixed = TRUE
  )
})
