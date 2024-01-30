#### Checks on test_fn_req_args() ####
test_that("Function to check N required arguments", {
  # Test function to check number of required arguments
  expect_true(
    test_fn_req_args(
      function(x) dgamma(x, 5, 1)
    )
  )
  # `+` needs two arguments
  expect_true(
    test_fn_req_args(
      `+`, 2L
    )
  )
  expect_false(
    test_fn_req_args(
      `+`, 1L
    )
  )
  expect_false(
    test_fn_req_args(
      function(x, y, ...) dgamma(x, 5, 1, ...) + y
    )
  )
  expect_true(
    test_fn_req_args(
      dgamma, 2
    )
  )

  # fails on poorly specified n
  expect_error(
    test_fn_req_args("dummy_fn", seq(10)),
    regexp = "`n_req_args` must be a single number"
  )
  expect_error(
    test_fn_req_args("dummy_fn", -1),
    regexp = "`n_req_args` must be a natural number > 0"
  )
  expect_error(
    test_fn_req_args("dummy_fn", NA_real_),
    regexp = "`n_req_args` must be finite and non-missing"
  )
  expect_error(
    test_fn_req_args("dummy_fn", Inf),
    regexp = "`n_req_args` must be finite and non-missing"
  )

  # expect TRUE when an appropriate primitive is passed
  # NOTE: Passes as this primitive has one arg
  expect_true(
    test_fn_req_args(is.list)
  )

  ## functions with ellipsis
  expect_true(
    test_fn_req_args(
      function(x, ...) dgamma(x, 5, 1, ...)
    )
  )
})

#### Test function to check for numeric output ####
test_that("Function to check numeric output", {
  # well specified case
  expect_true(
    test_fn_num_out(
      function(x) dgamma(x, 5, 1)
    )
  )
  # false on wrong input type
  expect_error(
    test_fn_num_out("dummy_fn"),
    regexp = "`fn` must be a function"
  )
  # fails on poorly specified n
  expect_error(
    test_fn_num_out("dummy_fn", seq(10)),
    regexp = "`n` must be a single number"
  )
  expect_error(
    test_fn_num_out("dummy_fn", -1),
    regexp = "`n` must be a natural number > 0"
  )
  expect_error(
    test_fn_num_out("dummy_fn", NA_real_),
    regexp = "`n` must be finite and non-missing"
  )
  expect_error(
    test_fn_num_out("dummy_fn", Inf),
    regexp = "`n` must be finite and non-missing"
  )
  # false on wrong return type
  expect_false(
    test_fn_num_out(
      function(x, ...) as.character(dgamma(x, 5, 1, ...))
    )
  )
  # false on wrong return length
  fn <- function(x) {
    a <- x + 1
    a[-1]
  }
  expect_false(
    test_fn_num_out(fn)
  )
})
