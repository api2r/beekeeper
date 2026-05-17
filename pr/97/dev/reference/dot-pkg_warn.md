# Signal a package-scoped warning

Signal a package-scoped warning

## Usage

``` r
.pkg_warn(
  message,
  subclass,
  parent = NULL,
  call = rlang::caller_env(),
  message_env = rlang::caller_env(),
  ...
)
```

## Arguments

- message:

  (`character`) The message for the new warning. Messages will be
  formatted with
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html).

- subclass:

  (`character`) Class(es) to assign to the warning. Will be prefixed by
  "{package}-warning-".

- parent:

  A parent condition, as you might create during a
  [`rlang::try_fetch()`](https://rlang.r-lib.org/reference/try_fetch.html).
  See [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html)
  for additional information.

- call:

  (`environment`) The caller environment for error messages.

- message_env:

  (`environment`) The execution environment to use to evaluate variables
  in error messages.

- ...:

  Additional parameters passed to
  [`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html)
  and on to
  [`rlang::warn()`](https://rlang.r-lib.org/reference/abort.html).

## Value

(`NULL`, invisibly) Called for warning side effect.
