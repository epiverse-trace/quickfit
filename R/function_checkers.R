#' @title Check functions passed to exported functions
#'
#' @name function_checkers
#' @rdname function_checkers
#'
#' @description Internal helper function that check whether a function passed as
#' an argument meets the requirements of package methods.
#'
#' `test_fn_req_args()` checks whether the function has only the expected number
#' of required arguments, i.e., arguments without default values. Defaults to
#' checking for a single required argument.
#'
#' `test_fn_num_out()` checks whether a function accepting a numeric vector
#' input returns a numeric vector output of the same length as the input, with
#' finite non-missing values \eqn{\geq} 0.0.
#'
#' @param func A function. This is expected to be a function evaluating the
#' density of a distribution at numeric values.
#' @param n_req_args The number of required arguments, i.e., arguments without
#' default values.
#' @param n The number of elements over which to evaluate the function `func`.
#' Defaults to 10, and `func` is evaluated over `seq(n)`.
#'
#' @return A logical for whether the function `func` fulfils conditions
#' specified in the respective checks.
#' @keywords internal
test_func_req_args <- function(func, n_req_args = 1) {
  # check for a non-negative integerish value
  stopifnot(
    "`n_req_args` must be a single number" = (is.numeric(n_req_args)) &&
      (length(n_req_args) == 1),
    "`n_req_args` must be finite and non-missing" = (is.finite(n_req_args)) &&
      (!is.na(n_req_args)),
    "`n_req_args` must be a natural number > 0" = (n_req_args > 0) &&
      (n_req_args %% 1 == 0)
  )
  # NOTE: using formals(args(func)) to allow checking args of builtin primitives
  # for which formals(func) would return NULL and cause the check to error
  # NOTE: errors non-informatively for specials such as `if`
  is.function(func) &&
    Reduce(
      x = Map(
        function(x, y) {
          is.name(x) && y != "..."
        },
        formals(args(func)), names(formals(args(func)))
      ),
      f = `+`
    ) == n_req_args
}

#' @name function_checkers
test_func_num_out <- function(func, n = 10) {
  # check for a non-negative integerish value
  stopifnot(
    "`n` must be a single number" = (is.numeric(n)) && (length(n) == 1),
    "`n` must be finite and non-missing" = (is.finite(n)) && (!is.na(n)),
    "`n` must be a natural number > 0" = (n > 0) && (n %% 1 == 0),
    "`func` must be a function" = is.function(func)
  )
  out <- func(seq(n))

  # return logical output of conditions
  is.numeric(out) && (length(out) == n) && (!anyNA(out)) &&
    (all(is.finite(out))) && (all(out > 0.0))
}
