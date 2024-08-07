
<!-- README.md is generated from README.Rmd. Please edit that file. -->
<!-- The code to render this README is stored in .github/workflows/render-readme.yaml -->
<!-- Variables marked with double curly braces will be transformed beforehand: -->
<!-- `packagename` is extracted from the DESCRIPTION file -->
<!-- `gh_repo` is extracted via a special environment variable in GitHub Actions -->

# *quickfit*: Toolbox of model fitting helper functions <img src="man/figures/logo.svg" align="right" width="120" />

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/epiverse-trace/quickfit/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/quickfit/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/quickfit/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/quickfit?branch=main)
[![Project Status: Suspended – Initial development has started, but
there has not yet been a stable, usable release; work has been stopped
for the time being but the author(s) intend on resuming
work.](https://www.repostatus.org/badges/latest/suspended.svg)](https://www.repostatus.org/#suspended)
<!-- badges: end -->

`{quickfit}` was intended to be an `R` package to help with simple model
fitting tasks in epidemiology and as a central place to store helper
functions used in Epiverse-TRACE.

The development of `{quickfit}` has been **suspended** it is no longer
considered necessary to have a dedicated package within Epiverse-TRACE
to conduct model fitting, and helper functions will remain in the
package they were developed in and shared/copied directly across
packages rather than requiring taking on a dependency to import them.
Development may resume if the need for a utility package becomes
apparent.

`{quickfit}` was developed at the [Centre for the Mathematical Modelling
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

**The examples below show the existing functionality; this is not
currently planned to be developed further.**

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
#> 3.996152 2.029174 
#> 
#> $log_likelihood
#> [1] -106.3236

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
#> 3.996152 2.029174 
#> 
#> $profile_out
#>       a1       a2       b1       b2 
#> 3.426729 4.566729 1.686751 2.508567
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
#> 1   lnorm -244.8528 493.7056 498.9159
#> 2 weibull -252.4967 508.9933 514.2037
#> 3   gamma -254.0602 512.1204 517.3308
```

## Help

To report a bug please open an
[issue](https://github.com/epiverse-trace/quickfit/issues/new/choose);
please note that development on `{quickfit}` has been suspended,
therefore it is not guaranteed that all issues will be responded to.

### Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/quickfit/pulls).

Development on `{quickfit}` has been suspended.

However, if you think this package could be developed for a specific use
case then contributions are very welcome as issues, or on the main
[Epiverse Discussion
board](https://github.com/orgs/epiverse-trace/discussions).

### Code of Conduct

Please note that the quickfit project is released with a [Contributor
Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
