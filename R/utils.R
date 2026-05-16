`%||%` <- function(x, y) if (is.null(x)) y else x

`%|0|%` <- function(x, y) if (!length(x)) y else x

`%|"|%` <- function(x, y) if (!nzchar(x)) y else x

.coalesce <- function(x, y) ifelse(is.na(x), y, x)

.collapse_comma <- function(x) glue::glue_collapse(x, sep = ", ")

.collapse_comma_newline <- function(x) glue::glue_collapse(x, sep = ",\n")

.collapse_quote_comma <- function(x) {
  stringr::str_flatten_comma(paste0('"', x, '"'))
}

.paste0_if <- function(original, test, addition) {
  ifelse(test, paste0(original, addition), original)
}

.glue_pipe_brace <- function(..., .envir = rlang::caller_env()) {
  glue::glue(..., .open = "|{", .close = "}|", .envir = .envir)
}

.to_snake <- function(x) snakecase::to_snake_case(x, parsing_option = 3)

.flatten_df <- S7::new_generic(".flatten_df", dispatch_args = "x")

S7::method(.flatten_df, class_data.frame) <- function(x) x

S7::method(.flatten_df, class_list) <- function(x) purrr::list_rbind(x)

S7::method(.flatten_df, NULL) <- function(x) data.frame()
