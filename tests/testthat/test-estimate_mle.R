test_that("estimate_mle works as expected for a one parameter model", {
  # set seed to control for optimisation stochasticity
  set.seed(1)

  # set up input
  sim_data <- rnorm(100, 5, 2)
  log_likelihood <- function(x, a) dnorm(x, a, 2, log = TRUE)
  a_initial <- 4

  # calc mle
  res <- estimate_mle(
    log_likelihood = log_likelihood,
    data_in = sim_data,
    n_param = 1,
    a_initial = 1
  )

  expect_type(res, "list")
  expect_equal(res$estimate, 5.217775, tolerance = 1e-5)
  expect_equal(res$log_likelihood, -201.1433, tolerance = 1e-5)
})


test_that("estimate_mle works as expected for a two parameter model", {
  # set seed to control for optimisation stochasticity
  set.seed(1)

  # set up input
  sim_data <- rnorm(100, 5, 2)
  log_likelihood <- function(x, a, b) dnorm(x, a, b, log = TRUE)
  a_initial <- 4
  b_initial <- 1

  # calc mle
  res <- estimate_mle(
    log_likelihood = log_likelihood,
    data_in = sim_data,
    n_param = 2,
    a_initial = 1,
    b_initial = 1
  )

  expect_type(res, "list")
  expect_equal(res$estimate, c(a = 5.219351, b = 1.788305), tolerance = 1e-5)
  expect_equal(res$log_likelihood, -199.9698, tolerance = 1e-5)
})
