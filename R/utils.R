#' Optimise a function using either numerical optimisation or grid search
#'
#' @details
#' Arguments passed through [dots] depend on whether `fit_method` is set to
#' `"optim"` or `"grid"`. For `"optim"`, arguments are passed to [optim()],
#' for `"grid"`, the variable arguments are `lower`, `upper` (lower and
#' upper bounds on the grid search for the parameter being optimised, defaults
#' are `lower = 0.001` and `upper = 0.999`), and `"res"` (the resolution of
#' grid, default is `res = 0.001`).
#'
#' @param func A `function`.
#' @param fit_method A `character` string, either `"optim"` or `"grid"`.
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Named elements to replace
#' default optimisation settings for either [optim()] or grid search. See
#' details.
#'
#' @return A single `numeric`.
#' @keywords internal
.fit <- function(func,
                 fit_method = c("optim", "grid"),
                 ...) {
  if (!is.function(func)) {
    stop("func must be a function", call. = FALSE)
  }
  fit_method <- match.arg(fit_method)

  # capture dynamic dots
  dots <- rlang::dots_list(..., .ignore_empty = "none", .homonyms = "error")
  dots_names <- names(dots)

  args <- list(
    lower = 0.001,
    upper = 0.999
  )

  func_args <- names(formals(func))
  if (fit_method == "optim") {
    optim_args <- names(formals("optim"))
    args <- c(args, method = "Brent")
    chk_args <- unique(c(names(args), func_args, optim_args))
  } else {
    args <- c(args, res = 0.001)
    chk_args <- unique(c(names(args), func_args))
  }
  # replace default args if in dots
  args <- utils::modifyList(args, dots)

  # check arguments in dots match arg list
  stopifnot(
    "Arguments supplied in `...` not valid" =
      all(dots_names %in% chk_args)
  )

  if (fit_method == "optim") {
    optim_dots <- args[!names(args) %in% c("lower", "upper", "method")]
    prob_est <- do.call(
      stats::optim,
      args = c(
        par = 0.5,
        fn = func,
        gr = NULL,
        optim_dots,
        method = args$method,
        lower = args$lower,
        upper = args$upper
      )
    )
    prob_est <- prob_est$par
  } else {
    # set up grid search
    ss <- seq(args$lower, args$upper, args$res)
    args <- c(ss = list(ss), args)
    args <- args[!names(args) %in% c("lower", "upper", "res")]
    prob_est <- do.call(func, args = args)
    prob_est <- ss[which.min(prob_est)]
  }

  # return estimate
  prob_est
}
