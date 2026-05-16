#' Use a template in this package
#'
#' @inheritParams rlang::args_dots_empty
#' @param template The name of the template.
#' @param data A list of variables to apply to the template.
#' @param target The name of the file to create.
#' @param dir The directory where the file should be created.
#'
#' @returns The path to the generated or updated file, invisibly.
#' @keywords internal
.bk_use_template <- function(
  template,
  data,
  ...,
  target = template,
  dir = c("R", "tests/testthat")
) {
  rlang::check_dots_empty()
  dir <- match.arg(dir)
  target <- .bk_use_template_impl(template, data, target, dir)
  return(invisible(target))
}

.bk_use_template_impl <- function(template, data, target, dir) {
  target <- usethis::proj_path(dir, target)
  save_as <- fs::path_rel(target, usethis::proj_path())
  if (fs::file_exists(target)) {
    # TODO: Intelligently prompt about this.
    fs::file_delete(target)
  }
  usethis::use_template(
    template = template,
    save_as = save_as,
    data = data,
    package = "beekeeper"
  )
  return(target)
}
