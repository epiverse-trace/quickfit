#' Helper function to call a fitting function across different models
#'
#' @description This is a utility function that allows comparing different model fits to a single dataset. It does this by executing a specified function on
#' the data provided and over all models specified. The function then organises
#' the output and calculates the AIC and BIC and ranks the output by model fit
#' , determined by the `rank_by` argument.
#'
#' @details The vector of models given in the `models` argument needs to be
#' named with the name of the model argument supplied to `func` when it
#' is not the second argument in that function. All elements of the vector need
#' to be named, see example.
#'
#' The data is assumed to always be the first argument of the function supplied
#' in `func`, `multi_fitdist()` will not work correctly if this is not the case.
#'
#' @param data A vector or data frame containing data that is required by the
#' function specified in `func` argument.
#' @param models A character string or vector of character strings
#' specifying the names of the candidate models. The naming of the models
#' should match those required by the function specified in the `func` argument.
#' The vector of models should be named with the name of the model argument
#' from that specified in `func` when the argument is not second. See details.
#' @param func A function (`closure`) used to fit the models. Could be user-defined or specified from another package's namespace.
#' @param rank_by A character string, either "loglik", "aic" or "bic" to rank
#' the order of the output data frame. Default is "aic".
#'
#' @return A data frame containing the models and associated loglikelihood, aic, and bic. 
#' @export
#'
#' @examples
#' \dontrun{
#' multi_fitdist(
#'   data = rgamma(n = 100, shape = 1, scale = 1),
#'   models = c("gamma", "weibull", "lnorm"),
#'   func = fitdistrplus::fitdist
#' )
#'
#' # Where the model is not the second argument in the function specified, the models have to be named according to what they are called in the original function.
#' # argument of the function input. Here, `distr` is the name required in `fitdistrplus::fitdist()`
#' multi_fitdist(
#'   data = rgamma(n = 100, shape = 1, scale = 1),
#'   models = c(distr = "gamma", distr = "weibull", distr = "lnorm"),
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
 is_res_s4 <- all(vapply(res, isS4, FUN.VALUE = logical(1))

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

#' Calculates the Akaike information criterion
#'
#' @param loglik A vector or single number the loglikelihood of the model
#' @param df A numeric specifying the degrees of freedom for the model in order
#' to calculate the Akaike information criterion. Default is 2.
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

#' Calculates the Bayesian information criterion
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
