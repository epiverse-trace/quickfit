#' Estimate profile likelihood and 95% CI
#'
#' @description This function estimate the profile likelihood and 95% CI for a
#' one or two parameter model
#'
#' @param log_likelihood Log-likelihood function in form `function(x,a)`
#' (one parameter model) or `function(x,a,b)` (two parameter model)
#' @param data_in Vector of observations to be evaluated in log_likelihood,
#' with overall likelihood given by sum(log_likelihood)
#' @param n_param Number of parameters in `log_likelihood` model
#' @param a_initial Initial guess for parameter `a`
#' @param b_initial Initial guess for parameter `b` (if a two parameter
#' model, otherwise default is NULL)
#' @param precision Parameter defining how fine-scale the grid search is for
#' the profile likelihood
#'
#' @author Adam Kucharski, Joshua W. Lambert
#'
#' @export
#' @examples
#' # example of a one parameter model
#' data_in <- rnorm(n = 100, mean = 1, sd = 2)
#' log_likelihood <- function(x,a) dnorm(x, a, 2, log = TRUE)
#' n_param <- 1
#' a_initial <- 0.5
#'
#' calculate_profile(
#'   log_likelihood = log_likelihood,
#'   data_in = data_in,
#'   n_param = 1,
#'   a_initial = 4,
#'   precision = 0.1
#' )
#'
#' # examle of a two parameter model
#' data_in <- rnorm(n = 100, mean = 1, sd = 1)
#' log_likelihood <- function(x,a,b) dnorm(x, a, b, log = TRUE)
#' n_param <- 2
#' a_initial <- 0.5
#' b_initial <- 1
#'
#' calculate_profile(
#'   log_likelihood = log_likelihood,
#'   data_in = data_in,
#'   n_param = 2,
#'   a_initial = 4,
#'   b_initial = 2,
#'   precision = 0.1
#' )
calculate_profile <- function(log_likelihood,
                              data_in,
                              n_param,
                              a_initial,
                              b_initial = NULL,
                              precision = 0.01) {

  # Chi-squared value corresponding to 95% CI
  chi_1 <- stats::qchisq(0.95, 1) / 2

  # One parameter model
  if (n_param == 1) {

    # Calculate MLE
    mle_estimate <- estimate_mle(
      log_likelihood,
      data_in,
      n_param = 1,
      a_initial
    )

    # Format for optimisation
    optim_profile <- function(theta) {
      abs(
        sum(log_likelihood(data_in, as.numeric(theta[1]))) -
          mle_estimate$log_likelihood + chi_1
      )
    }

    # Run optimisation and return
    # XX CHECK LOWER BOUND
    profile_out_1 <- stats::optim(
      c(a = mle_estimate$estimate),
      optim_profile,
      method = "Brent",
      lower = mle_estimate$estimate - 1e2,
      upper = mle_estimate$estimate
    )
    profile_out_2 <- stats::optim(
      c(a = mle_estimate$estimate),
      optim_profile,
      method = "Brent",
      lower = mle_estimate$estimate,
      upper = mle_estimate$estimate + 1e2
    )

    profile_out <- c(profile_out_1$par, profile_out_2$par)
    output <- list(
      estimate = mle_estimate$estimate,
      profile_out = c(a = profile_out)
    )
  }

  # Two parameter model
  if (n_param == 2) {
    # Calculate MLE
    mle_estimate <- estimate_mle(
      log_likelihood,
      data_in,
      n_param = 2,
      a_initial,
      b_initial
    )

    # Format for optimisation profile likelihood for each of the two parameters
    # Parameter a
    optim_profile_a <- function(theta) {
      # Maximise likelihood over all values of b at point a=theta
      maximise_a_over_b <- function(theta_2) {
        -sum(
          log_likelihood(data_in, as.numeric(theta[1]), as.numeric(theta_2[1]))
        )
      }
      # Calculate maximum at point theta=a
      # XX TEST BOUNDS XX
      mle_theta <- stats::optim(
        c(b = mle_estimate$estimate[["b"]]),
        maximise_a_over_b,
        method = "Brent",
        lower = 0.5 * mle_estimate$estimate[["b"]],
        upper = 2 * mle_estimate$estimate[["b"]]
      )
      return(-mle_theta$value)
    }

    # Parameter b
    optim_profile_b <- function(theta) {
      # Maximise likelihood over all values of b at point a=theta
      maximise_b_over_a <- function(theta_2) {
        -sum(
          log_likelihood(data_in, as.numeric(theta_2[1]), as.numeric(theta[1]))
        )
      }
      # Calculate maximum at point theta=a
      # XX TEST BOUNDS XX
      mle_theta <- stats::optim(
        c(b = mle_estimate$estimate[["a"]]),
        maximise_b_over_a,
        method = "Brent",
        lower = 0.5 * mle_estimate$estimate[["a"]],
        upper = 2 * mle_estimate$estimate[["a"]]
      )
      return(-mle_theta$value)
    }

    # Run optimisation and return 95% CI
    # Run for parameter a
    bound_a <- 0.1 # set bound on initial guess
    error_a <- 1 # set bound on error
    # Define bounds that are sufficiently large to contain the 95% interval
    while (error_a < chi_1) {
      value_range_a <- mle_estimate$estimate[["a"]] *
        c(1 - bound_a, 1 + bound_a)
      error_a <- min(
        mle_estimate$log_likelihood -
          c(optim_profile_a(value_range_a[1]),
            optim_profile_a(value_range_a[2]))
      )
      if (bound_a == (1 - 1e-5)) break
      bound_a <- min(1 - 1e-5, bound_a * 1.5)
    }

    # Set up precision and find 95% CI
    v_precision <- (value_range_a[2] - value_range_a[1]) * precision
    xx <- seq(value_range_a[1], value_range_a[2], precision)
    profile_out_a <- sapply(xx, optim_profile_a)
    locate_min <- abs(profile_out_a - max(profile_out_a) + chi_1)
    half_xx <- round(length(xx) / 2)
    a_lower <- xx[which.min(locate_min[1:half_xx])]
    a_upper <- xx[half_xx + which.min(locate_min[(half_xx + 1):length(xx)])]

    # Run for parameter b
    bound_b <- 0.1 # set bound on initial guess
    error_b <- 1 # set bound on error
    # Define bounds that are sufficiently large to contain the 95% interval
    while (error_b < chi_1) {
      value_range_b <- mle_estimate$estimate[["b"]] *
        c(1 - bound_b, 1 + bound_b)
      error_b <- min(
        mle_estimate$log_likelihood -
          c(optim_profile_b(value_range_b[1]),
            optim_profile_b(value_range_b[2]))
      )
      if (bound_b == (1 - 1e-5)) break
      bound_b <- min(1 - 1e-5, bound_b * 1.5)
    }

    # Set up precision and find 95% CI
    v_precision <- (value_range_b[2] - value_range_b[1]) * precision
    xx <- seq(value_range_b[1], value_range_b[2], v_precision)
    profile_out_b <- sapply(xx, optim_profile_b)
    locate_min <- abs(profile_out_b - max(profile_out_b) + chi_1)
    half_xx <- round(length(xx) / 2)
    b_lower <- xx[which.min(locate_min[1:half_xx])]
    b_upper <- xx[half_xx + which.min(locate_min[(half_xx + 1):length(xx)])]

    profile_out_a <- c(a_lower, a_upper)
    profile_out_b <- c(b_lower, b_upper)

    output <- list(
      estimate = mle_estimate$estimate,
      profile_out = c(a = profile_out_a, b = profile_out_b)
    )
  }

  # Output estimates and likelihood
  output
}
