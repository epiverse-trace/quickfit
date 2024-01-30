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
#' @param fn A function. This is expected to be a function evaluating the
#' density of a distribution at numeric values.
#' @param n_req_args The number of required arguments, i.e., arguments without
#' default values.
#' @param n The number of elements over which to evaluate the function `fn`.
#' Defaults to 10, and `fn` is evaluated over `seq(n)`.
#'
#' @return A logical for whether the function `fn` fulfils conditions specified
#' in the respective checks.
#' @keywords internal
test_fn_req_args <- function(fn, n_req_args = 1) {
  # NOTE: replacing checkmate::assert_count()
  stopifnot(
    "`n_req_args` must be a single number" = (is.numeric(n_req_args)) &&
      (length(n_req_args) == 1),
    "`n_req_args` must be finite and non-missing" = (is.finite(n_req_args)) &&
      (!is.na(n_req_args)),
    "`n_req_args` must be a natural number > 0" = (n_req_args > 0) &&
      (n_req_args %% 1 == 0)
  )
  # NOTE: using formals(args(fn)) to allow checking args of builtin primitives
  # for which formals(fn) would return NULL and cause the check to error
  # NOTE: errors non-informatively for specials such as `if`
  is.function(fn) &&
    Reduce(
      x = Map(
        function(x, y) {
          is.name(x) && y != "..."
        },
        formals(args(fn)), names(formals(args(fn)))
      ),
      f = `+`
    ) == n_req_args
}

#' @name function_checkers
test_fn_num_out <- function(fn, n = 10) {
  # NOTE: replacing checkmate::assert_count()
  stopifnot(
    "`n` must be a single number" = (is.numeric(n)) && (length(n) == 1),
    "`n` must be finite and non-missing" = (is.finite(n)) && (!is.na(n)),
    "`n` must be a natural number > 0" = (n > 0) && (n %% 1 == 0),
    "`fn` must be a function" = is.function(fn)
  )
  out <- fn(seq(n))

  # return logical output of conditions
  is.numeric(out) && (length(out) == n) && (!anyNA(out)) &&
    (all(is.finite(out))) && (all(out > 0.0))
}
