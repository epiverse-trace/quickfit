#' Maximum likelihood fitting of multiple distributions
#'
#' @param data A numeric vector of values
#' @param models A character string or vector of character strings
#' specifying the names of the candidate models. This follows the R naming
#' convention for distributions, the density function is `d[name]`.
#'
#' @return A data frame of all models
#' @export
#'
#' @examples
#' multi_fitdist(
#'   data = rgamma(n = 100, shape = 1, scale = 1),
#'   models = c("gamma", "weibull", "lnorm")
#' )
multi_fitdist <- function(data, models) {

  # fit distributions to data
  if (is.data.frame(data)) {
    if (ncol(data) == 2) {
      res <- lapply(
        models,
        fitdistrplus::fitdistcens,
        censdata = data
      )
    } else {
      res <- fit_cdt_dist(data = data, models = models)
      # data is formatted in fit_cdt_dist so return early
      return(res)
    }
  } else {
    res <- lapply(
      models,
      fitdistrplus::fitdist,
      data = data
    )
  }

  # extract loglikelihood, aic and bic
  loglik <- vapply(res, "[[", "loglik", FUN.VALUE = numeric(1))
  aic <- vapply(res, "[[", "aic", FUN.VALUE = numeric(1))
  bic <- vapply(res, "[[", "bic", FUN.VALUE = numeric(1))

  # package results into data frame
  res <- data.frame(models = models, loglik = loglik, aic = aic, bic = bic)

  # order the results from best fit to worst
  res <- res[order(res$aic, method = "radix"), ]
  rownames(res) <- NULL

  # return results
  res
}

#' Fits probability distributions using `coarseDataTools::dic.fit()`
#'
#' @inheritParams multi_fitdist
#'
#' @return A data frame of all models
#' @export
#'
#' @examples
#' library(coarseDataTools)
#' data("nycH1N1")
#' fit_cdt_dist(data = nycH1N1, models = c("lnorm", "weibull"))
fit_cdt_dist <- function(data, models) {

  # convert models to format accepted by dic.fit()
  models <- gsub(pattern = "lnorm", replacement = "L", x = models, fixed = TRUE)
  models <- gsub(pattern = "gamma", replacement = "G", x = models, fixed = TRUE)
  models <- gsub(
    pattern = "weibull", replacement = "W", x = models, fixed = TRUE
  )

  fitdist <- lapply(models, function(x, data) {
    if (x == "G") {
      # gamma distribution fitting requires bootstrapping
      coarseDataTools::dic.fit(dat = data, dist = x, n.boots = 100)
    } else {
      coarseDataTools::dic.fit(dat = data, dist = x)
    }
  }, data)

  # extract loglikelihood
  loglik <- vapply(fitdist, "slot", "loglik", FUN.VALUE = numeric(1))

  # calculate aic and bic
  aic <- calc_aic(loglik)
  bic <- calc_bic(loglik, data)

  # change models back to original
  models <- gsub(pattern = "^L$", replacement = "lnorm", x = models)
  models <- gsub(pattern = "^G$", replacement = "gamma", x = models)
  models <- gsub(pattern = "^W$", replacement = "weibull", x = models)

  # package results into data frame
  res <- data.frame(models = models, loglik = loglik, aic = aic, bic = bic)

  # order the results from best fit to worst
  res <- res[order(res$aic, method = "radix"), ]
  rownames(res) <- NULL

  # return results
  res
}

#' Calculates the Akaike information criterion for the loglikelihood of a two
#' parameter probability distribution
#'
#' @param loglik A vector or single number the loglikelihood of the model
#'
#' @return A single or vector of numerics equal to the input vector length
#' @export
#'
#' @examples
#' calc_aic(loglik = -110)
calc_aic <- function(loglik) {

  # make loglik a logLik class for AIC method
  class(loglik) <- "logLik"

  # set degrees of freedom (TODO: allow df to change)
  attr(loglik, "df") <- 2

  # calculate and return AIC
  stats::AIC(loglik)
}

#' Calculates the Bayesian information criterion for the loglikelihood of a two
#' parameter probability distribution
#'
#' @inheritParams calc_aic
#' @inheritParams multi_fitdist
#'
#' @return A single or vector of numerics equal to the input vector length
#' @export
#'
#' @examples
#' # example using vector
#' data <- c(2, 13, 22, 25, 11, 12, 11, 23, 13, 24)
#' calc_bic(loglik = -110, data = data)
#'
#' # example using tabular data
#' data <- data.frame(
#'   c(2, 13, 22, 25, 11, 12, 11, 23, 13, 24),
#'   c(4, 15, 19, 1, 16, 10, 3, 17, 16, 3)
#' )
#' calc_bic(loglik = -110, data = data)
calc_bic <- function(loglik, data, df = 2) {

  # make loglik a logLik class for BIC method
  class(loglik) <- "logLik"

  # set degrees of freedom (TODO: allow df to change)
  attr(loglik, "df") <- df

  # set number of observations
  if (is.null(dim(data))) {
    attr(loglik, "nobs") <- length(data)
  } else {
    # tabular data is assumed to have one obs per row
    attr(loglik, "nobs") <- dim(data)[1L]
  }

  # calculate and return BIC
  stats::BIC(loglik)
}
