.onLoad <- function(libname, pkgname) {
  S7::methods_register() # nocov
  read_config <<- memoise::memoise(read_config) # nocov
}

# enable usage of <S7_object>@name in package code
#' @rawNamespace if (getRversion() < "4.3.0") importFrom("S7", "@")
NULL
