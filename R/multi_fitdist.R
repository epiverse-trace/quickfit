#' Maximum likelihood fitting of multiple distributions
#'
#' @param data A numeric vector of values
#' @param models A character string or vector of character strings
#' specifying the names of the candidate models. This follows the R naming
#' convention for distributions, the density function is `d[name]`.
#' @param func A function (`closure`) used to fit the models.
#' @param rank_by A character string, either "loglik", "aic" or "bic" to rank
#' the order of the output data frame. Default is "aic".
#'
#' @return A data frame of all models
#' @export
#'
#' @examples
#' \dontrun{
#' multi_fitdist(
#'   data = rgamma(n = 100, shape = 1, scale = 1),
#'   models = c("gamma", "weibull", "lnorm")
#'   func = fitdistrplus::fitdist
#' )
#' }
multi_fitdist <- function(data,
                          models,
                          func,
                          rank_by = c("aic", "bic", "loglik")) {

  # check input
  func <- match.fun(func)
  rank_by <- match.arg(rank_by)

  # try and call function input with args
  tryCatch(
    {
      res <- vector("list", length = length(models))
      for (i in seq_along(models)) {
        args <- list(data, models[i])
        if (!is.null(names(models[i]))) {
          arg_names <- lapply(args, names)
          names(args)[2] <- arg_names[2]
          names(args)[1] <- ""
        }
        res[[i]] <- do.call(func, args = args)
      }
    },
    error = function(cnd) {
      message(
        "Failed to fit models to data please check input \n",
        "See documentation of input function for further details"
      )
      return(NA)
    }
  )

  # check whether the list contains s3 or s4 objects
  is_res_s4 <- all(sapply(res, isS4))

  name_accessor <- ifelse(
    test = is_res_s4,
    yes = methods::slotNames,
    no = names
  )
  slot_accessor <- ifelse(test = is_res_s4, yes = "slot", no = "[[")

  # check if function output contains loglikelihood
  res_names <- lapply(res, name_accessor)
  has_loglik <- sapply(res_names, function(x) "loglik" %in% x)

  # extract loglikelihood
  if (all(has_loglik)) {
    loglik <- vapply(res, slot_accessor, "loglik", FUN.VALUE = numeric(1))
    aic <- calc_aic(loglik = loglik)
    bic <- calc_bic(loglik = loglik, data = data)
  } else {
    stop(
      "Fitting function input does not have loglik in output",
      call. = FALSE
    )
  }

  # package results into data frame
  res <- data.frame(models = models, loglik = loglik, aic = aic, bic = bic)

  # order the results from best fit to worst
  res <- res[order(res[, rank_by], method = "radix"), ]
  rownames(res) <- NULL

  # return results
  res
}

#' Calculates the Akaike information criterion for the loglikelihood of a two
#' parameter probability distribution
#'
#' @param loglik A vector or single number the loglikelihood of the model
#' @param df A numeric specifying the degrees of freedom for the model in order
#' to calculate the Akaike information criterion
#'
#' @return A single or vector of numerics equal to the input vector length
#' @export
#'
#' @examples
#' calc_aic(loglik = -110)
calc_aic <- function(loglik, df = 2) {

  # make loglik a logLik class for AIC method
  class(loglik) <- "logLik"

  # set degrees of freedom (TODO: allow df to change)
  attr(loglik, "df") <- df

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
