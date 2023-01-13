test_that("calculate_profile works as expected for one parameter model", {
  # set seed to control for optimisation stochasticity
  set.seed(1)

  # set up input
  data_in <- rnorm(n = 100, mean = 1, sd = 2)
  log_likelihood <- function(x, a) dnorm(x, a, 2, log = TRUE)
  n_param <- 1
  a_initial <- 0.5

  # calc profile
  prof <- calculate_profile(
    log_likelihood = log_likelihood,
    data_in = data_in,
    n_param = 1,
    a_initial = 4,
    precision = 0.1
  )
  expect_type(prof, "list")
  expect_equal(prof$estimate, 1.217775, tolerance = 1e-5)
  expect_equal(
    prof$profile_out,
    c(a1 = 0.8257819, a2 = 1.6097675),
    tolerance = 1e-5
  )
})

test_that("calculate_profile works as expected for two parameter model", {
  # set seed to control for optimisation stochasticity
  set.seed(1)

  # set up input
  data_in <- rnorm(n = 100, mean = 1, sd = 1)
  log_likelihood <- function(x, a, b) dnorm(x, a, b, log = TRUE)
  n_param <- 2
  a_initial <- 0.5
  b_initial <- 1

  # calc profile
  prof <- calculate_profile(
    log_likelihood = log_likelihood,
    data_in = data_in,
    n_param = 2,
    a_initial = 4,
    b_initial = 2,
    precision = 0.1
  )

  expect_type(prof, "list")
  expect_equal(prof$estimate, c(a = 1.1090513, b = 0.8936486), tolerance = 1e-5)
  expect_equal(
    prof$profile_out,
    c(a1 = 0.9595147, a2 = 1.2595147, b1 = 0.7730060, b2 = 1.0142911),
    tolerance = 1e-5
  )
})
