.generate_call <- function(config, api_definition, security_data) {
  touched_files <- c(
    .generate_call_r(config, api_definition, security_data),
    .generate_call_test(config$api_abbr)
  )
  return(touched_files)
}

.generate_call_r <- function(config, api_definition, security_data) {
  .bk_use_template(
    template = "010-call.R",
    data = list(
      api_title = config$api_title,
      api_abbr = config$api_abbr,
      base_url = api_definition@servers@url,
      has_security = security_data$has_security,
      security_arg_helps = security_data$security_arg_helps,
      security_signature = security_data$security_signature,
      security_arg_list = security_data$security_arg_list
    )
  )
}

.generate_call_test <- function(api_abbr) {
  .bk_use_template(
    template = "test-010-call.R",
    dir = "tests/testthat",
    data = list(api_abbr = api_abbr)
  )
}
