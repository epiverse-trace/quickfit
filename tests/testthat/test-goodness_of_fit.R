test_that("goodness_of_fit works as expected on vector", {
  res <- goodness_of_fit(
    data = rlnorm(n = 100, meanlog = 1, sdlog = 1),
    models = c("lnorm", "gamma", "weibull")
  )
  expect_s3_class(res, "gofstat.fitdist")
})

test_that("goodness_of_fit works as expected on data.frame", {
  left <- rlnorm(n = 100, meanlog = 1, sdlog = 1)
  right <- left + rlnorm(n = 100, meanlog = 1, sdlog = 1)
  expect_error(
    goodness_of_fit(
      data = data.frame(left = left, right = right),
      models = c("lnorm", "gamma", "weibull")
    ),
    regexp = "goodness of fit cannot be computed for censorred data"
  )
})
