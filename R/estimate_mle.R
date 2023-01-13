#' Calculates the maximum-likelihood estimate for a given likelihood function
#'
#' @description  This function calculates the maximum-likelihood estimate for a
#' one or two parameter model
#'
#' @param log_likelihood Log-likelihood function in form `function(x, a)`
#' (one parameter model) or `function(x, a, b)` (two parameter model)
#' @param data_in Vector of observations to be evaluated in log_likelihood,
#' with overall likelihood given by sum(log_likelihood)
#' @param n_param Number of parameters in `log_likelihood` model
#' @param a_initial Initial guess for parameter `a`
#' @param b_initial Initial guess for parameter `b` (if a two parameter
#' model, otherwise default is NULL)
#'
#' @author Adam Kucharski, Joshua W. Lambert
#'
#' @export
#' @examples
#' # example for a one parameter model
#' sim_data <- rnorm(100, 5, 2)
#' log_likelihood <- function(x, a) dnorm(x, a, 2, log = TRUE)
#' a_initial <- 4
#'
#' estimate_mle(
#'   log_likelihood = log_likelihood,
#'   data_in = sim_data,
#'   n_param = 1,
#'   a_initial = 1
#' )
#'
#' # example for a two parameter model
#' sim_data <- rnorm(100, 5, 2)
#' log_likelihood <- function(x, a, b) dnorm(x, a, b, log = TRUE)
#' a_initial <- 4
#' b_initial <- 1
#'
#' estimate_mle(
#'   log_likelihood = log_likelihood,
#'   data_in = sim_data,
#'   n_param = 2,
#'   a_initial = 1,
#'   b_initial = 1
#' )
estimate_mle <- function(log_likelihood,
                         data_in,
                         n_param,
                         a_initial,
                         b_initial = NULL) {
  # One parameter model
  if (n_param == 1) {
    # Format for optimisation
    optim_likelihood <- function(theta) {
      -sum(log_likelihood(data_in, as.numeric(theta[1])))
    }

    # Run optimisation and return
    # XX ADD tests for upper and lower bound
    mle <- stats::optim(
      c(a = a_initial),
      optim_likelihood,
      method = "Brent",
      lower = -abs(a_initial) * 10,
      upper = abs(a_initial) * 10
    )
  }

  # Two parameter model
  if (n_param == 2) {
    # Format for optimisation
    optim_likelihood <- function(theta) {
      -sum(log_likelihood(data_in, as.numeric(theta[1]), as.numeric(theta[2])))
    }

    # Run optimisation and return
    mle <- stats::optim(c(a = a_initial, b = b_initial), optim_likelihood)
  }

  # Output estimates and likelihood
  output <- list(estimate = mle$par, log_likelihood = -mle$value)
  return(output)
}
