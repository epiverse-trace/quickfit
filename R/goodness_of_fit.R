#' Calculates the goodness-of-fit statistics for the fitted distributions
#'
#' @inheritParams multi_fitdist
#'
#' @return A `gofstat.fitdist` object from the `{fitdistrplus}` package
#' @export
#'
#' @examples
#' goodness_of_fit(
#'   data = rgamma(n = 100, shape = 1, scale = 1),
#'   models = c('gamma', 'weibull', 'lnorm')
#' )
goodness_of_fit <- function(data, models) {
  fitdist <- vector("list", length(models))
  # fit distributions to data
  if (is.data.frame(data)) {
    stop("goodness of fit cannot be computed for censored data")
  } else {
    fitdist <- lapply(
      models,
      fitdistrplus::fitdist,
      data = data
    )
  }

  # return the goodness-of-fit statistics for each model
  fitdistrplus::gofstat(fitdist, fitnames = models)
}
