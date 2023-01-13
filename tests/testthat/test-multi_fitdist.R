test_that("multi_fitdist works as expected on vector", {
  res <- multi_fitdist(
    data = rlnorm(n = 100, meanlog = 1, sdlog = 1),
    models = c("lnorm", "gamma", "weibull")
  )
  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 3L)
  expect_identical(ncol(res), 4L)
})

test_that("multi_fitdist works as expected on censored data", {
  # data from fitdistrplus
  data("salinity")
  res <- multi_fitdist(
    data = salinity,
    models = c("lnorm", "gamma", "weibull")
  )
  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 3L)
  expect_identical(ncol(res), 4L)
})

test_that("multi_fitdist works as expected on vector", {
  # data from coarseDataTools
  data("nycH1N1")
  res <- multi_fitdist(
    data = nycH1N1,
    models = c("lnorm", "weibull")
  )
  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 2L)
  expect_identical(ncol(res), 4L)
})
