#' Use a template in this package
#'
#' @inheritParams .shared-params
#' @inheritParams rlang::args_dots_empty
#' @returns (`character(1)`, invisibly) The path to the generated or updated
#'   file.
#' @keywords internal
.bk_use_template <- function(
  template,
  data,
  ...,
  target = template,
  dir = c("R", "tests/testthat"),
  pkg_dir = "."
) {
  rlang::check_dots_empty()
  dir <- match.arg(dir)
  target <- .bk_use_template_impl(template, data, target, dir, pkg_dir)
  return(invisible(target))
}

#' Write a rendered template to disk
#'
#' @inheritParams .shared-params
#' @returns (`character(1)`) The generated file path.
#' @keywords internal
.bk_use_template_impl <- function(template, data, target, dir, pkg_dir = ".") {
  usethis::with_project(
    pkg_dir,
    {
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
    }
  )
  return(target)
}
