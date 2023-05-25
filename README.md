
<!-- README.md is generated from README.Rmd. Please edit that file. -->
<!-- The code to render this README is stored in .github/workflows/render-readme.yaml -->
<!-- Variables marked with double curly braces will be transformed beforehand: -->
<!-- `packagename` is extracted from the DESCRIPTION file -->
<!-- `gh_repo` is extracted via a special environment variable in GitHub Actions -->

# quickfit

quickfit provides functions to estimate one and two parameter functions
via maximum likelihood

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/epiverse-trace/quickfit/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/quickfit/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/quickfit/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/quickfit?branch=main)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`{quickfit}` is an `R` package to help with simple model fitting tasks
in epidemiology.

`{quickfit}` is developed at the [Centre for the Mathematical Modelling
of Infectious
Diseases](https://www.lshtm.ac.uk/research/centres/centre-mathematical-modelling-infectious-diseases)
at the London School of Hygiene and Tropical Medicine as part of the
[Epiverse Initiative](https://data.org/initiatives/epiverse/).

## Installation

You can install the development version of quickfit from
[GitHub](https://github.com/) with:

``` r
# check whether {pak} is installed
if(!require("pak")) install.packages("pak")
pak::pak("epiverse-trace/quickfit")
```

## Quick start

These examples illustrate some of the current functionalities:

``` r
library(quickfit)
```

Generate some simulated data, define a likelihood, then estimate MLE, or
MLE and 95% confidence interval based on profile likelihood:

``` r
sim_data <- rnorm(50, 4, 2)

# Define likelihood function
log_l <- function(x,a,b) dnorm(x, a, b, log = TRUE)

# Estimate MLE
estimate_mle(log_l, sim_data, n_param = 2, a_initial = 3, b_initial = 1)
#> $estimate
#>        a        b 
#> 3.986475 1.997933 
#> 
#> $log_likelihood
#> [1] -105.5594

# Estimate 95% CI based on profile likelihood
calculate_profile(
  log_l, 
  data_in = sim_data, 
  n_param = 2, 
  a_initial = 3, 
  b_initial = 1, 
  precision = 0.01
)
#> $estimate
#>        a        b 
#> 3.986475 1.997933 
#> 
#> $profile_out
#>       a1       a2       b1       b2 
#> 3.418503 4.548503 1.660782 2.469944
```

Additionally, multiple distribution models can be compared (for censored
and non-censored data).

``` r
multi_fitdist(
  data = rlnorm(n = 100, meanlog = 1, sdlog = 1), 
  models = c("lnorm", "gamma", "weibull"), 
  func = fitdistrplus::fitdist
)
#>    models    loglik      aic      bic
#> 1   gamma -238.2154 480.4309 485.6412
#> 2   lnorm -238.2519 480.5038 485.7142
#> 3 weibull -239.2969 482.5937 487.8041
```

## Help

To report a bug please open an
[issue](https://github.com/epiverse-trace/quickfit/issues/new/choose)

### Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/quickfit/pulls).

### Code of Conduct

Please note that the quickfit project is released with a [Contributor
Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
