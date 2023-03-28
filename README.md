
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
#> Loading required package: pak
pak::pak("epiverse-trace/quickfit")
#> ℹ Loading metadata database
#> ℹ Loading metadata database
#> ✔ Loading metadata database ... done
#> ✔ Loading metadata database ... done
#> 
#>  
#> 
#> ℹ No downloads are needed
#> ℹ No downloads are needed
#> ✔ 1 pkg + 2 deps: kept 3 [12.1s]
#> ✔ 1 pkg + 2 deps: kept 3 [12.1s]
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
#> 4.327078 1.782706 
#> 
#> $log_likelihood
#> [1] -99.85416

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
#> 4.327078 1.782706 
#> 
#> $profile_out
#>       a1       a2       b1       b2 
#> 3.818017 4.828017 1.481874 2.203870
```

Additionally, multiple distribution models can be compared (for censored
and non-censored data).

``` r
multi_fitdist(
  data = rlnorm(n = 100, meanlog = 1, sdlog = 1), 
  models = c("lnorm", "gamma", "weibull")
)
#>    models    loglik      aic      bic
#> 1   lnorm -233.4841 470.9682 476.1786
#> 2   gamma -243.1483 490.2967 495.5070
#> 3 weibull -243.2092 490.4185 495.6288
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
