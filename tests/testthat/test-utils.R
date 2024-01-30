test_that(".fit works as expected" ,{
  func <- function(x) {
    (x - 3)^2 + 5
  }
  expect_equal(.fit(func = func, fit_method = "optim", upper = 5), 3)
})

test_that(".fit fails as expected", {
  expect_error(
    .fit(func = "function", fit_method = "optim"),
    regexp = "func must be a function"
  )
  func <- function(x) {
    (x - 3)^2 + 5
  }
  expect_error(
    .fit(func = func, fit_method = "other"),
    regexp = "(arg)*(should be one of)*(optim)*(grid)"
  )
  expect_error(
    .fit(func = func, fit_method = "optim", a = 1, a = 2),
    regexp = "(Arguments)*(must have unique names)"
  )
  expect_error(
    .fit(func = func, fit_method = "optim", mthod = "L-BFGS-B"),
    regexp = "Arguments supplied in `...` not valid"
  )
  expect_error(
    .fit(func = func, fit_method = "grid", method = "L-BFGS-B"),
    regexp = "Arguments supplied in `...` not valid"
  )
})
