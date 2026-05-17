#' Generate shared parameter docs
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated file path.
#' @export
generate_pkg_shared_params <- function(
  security_data = .read_security_data(pkg_dir, config_filename),
  config_filename = "_beekeeper.yml",
  pkg_dir = "."
) {
  .assert_is_pkg(pkg_dir)
  .use_r_directory(pkg_dir)
  .use_nectar(pkg_dir)
  .use_pkg_beekeeper(pkg_dir)
  .generate_shared_params(security_data)
}

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
