#' Generate shared parameter docs
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated file path.
#' @keywords internal
.generate_shared_params <- function(security_data) {
  shared_file_path <- .bk_use_template(
    template = "000-shared.R",
    data = list(
      shared_arg_helps = list(),
      security_arg_helps = security_data$security_arg_helps
    )
  )
  return(shared_file_path)
}
