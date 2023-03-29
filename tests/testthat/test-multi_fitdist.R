test_that("multi_fitdist works as expected on vector", {
  skip_if_not(
    requireNamespace("fitdistrplus", quietly = TRUE),
    message = "{fitdistrplus} package required for running test"
  )

  res <- multi_fitdist(
    data = rlnorm(n = 100, meanlog = 1, sdlog = 1),
    models = c("lnorm", "gamma", "weibull"),
    func = fitdistrplus::fitdist
  )
  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 3L)
  expect_identical(ncol(res), 4L)
})

test_that("multi_fitdist works as expected on censored data", {
  skip_if_not(
    requireNamespace("fitdistrplus", quietly = TRUE),
    message = "{fitdistrplus} package required for running test"
  )

  data <- data.frame(
    left = c(3.2, 20, 30, 20, 25, 0.23, 20, 12.80, 3.2, 25),
    right = c(NA, 25, NA, NA, 47, NA, NA, 15, 47, NA)
  )
  res <- multi_fitdist(
    data = data,
    models = c("lnorm", "gamma", "weibull"),
    func = fitdistrplus::fitdistcens
  )
  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 3L)
  expect_identical(ncol(res), 4L)
})

test_that("multi_fitdist works as expected on vector", {
  skip_if_not(
    requireNamespace("coarseDataTools", quietly = TRUE),
    message = "{coarseDataTools} package required for running test"
  )

  data <- data.frame(
    EL = c(7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25,
           7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25,
           7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25, 7.25),
    ER = c(12, 11, 10, 12, 11, 13, 11, 13, 11, 12, 11, 11, 11, 14, 14, 10,
           10, 14, 11, 12, 12, 11, 10, 12, 11, 13, 11, 13, 11, 12),
    SL  = c(11, 10, 9, 11, 10, 12, 10, 12, 10, 11, 10, 10, 10, 13, 13, 9,
            9, 13, 10, 11, 11, 10, 9, 11, 10, 12, 10, 12, 10, 11),
    SR = c(12, 11, 10, 12, 11, 13, 11, 13, 11, 12, 11, 11, 11, 14, 14, 10,
           10, 14, 11, 12, 12, 11, 10, 12, 11, 13, 11, 13, 11, 12),
    type = rep(0, 30)
  )
  # suppress warning produced by supplied function
  capture.output(res <- suppressWarnings(
    multi_fitdist(
      data = data,
      models = c(dist = "L", dist = "W"), # nolint
      func = coarseDataTools::dic.fit
    )
  ))
  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 2L)
  expect_identical(ncol(res), 4L)
})
