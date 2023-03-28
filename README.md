
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
#> → Will update 1 package.
#> → Will update 1 package.
#> → The package (0 B) is cached.
#> → The package (0 B) is cached.
#> + quickfit 0.0.0.9000 → 0.0.0.9000 👷🏿‍♀️🔧 (GitHub: 5d11e96)
#> + quickfit 0.0.0.9000 → 0.0.0.9000 👷🏿‍♀️🔧 (GitHub: 5d11e96)
#> ℹ No downloads are needed, 1 pkg is cached
#> ℹ No downloads are needed, 1 pkg is cached
#> ✔ Got quickfit 0.0.0.9000 (source) (27.92 kB)
#> ✔ Got quickfit 0.0.0.9000 (source) (27.92 kB)
#> ℹ Packaging quickfit 0.0.0.9000
#> ℹ Packaging quickfit 0.0.0.9000
#> ✔ Packaged quickfit 0.0.0.9000 (567ms)
#> ✔ Packaged quickfit 0.0.0.9000 (567ms)
#> ℹ Building quickfit 0.0.0.9000
#> ℹ Building quickfit 0.0.0.9000
#> ✔ Built quickfit 0.0.0.9000 (1.4s)
#> ✔ Built quickfit 0.0.0.9000 (1.4s)
#> ✔ Installed quickfit 0.0.0.9000 (github::epiverse-trace/quickfit@5d11e96) (41ms)
#> ✔ Installed quickfit 0.0.0.9000 (github::epiverse-trace/quickfit@5d11e96) (41ms)
#> ✔ 1 pkg + 12 deps: kept 10, upd 1, dld 1 (NA B) [14.6s]
#> ✔ 1 pkg + 12 deps: kept 10, upd 1, dld 1 (NA B) [14.6s]
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
#> 4.103950 1.838315 
#> 
#> $log_likelihood
#> [1] -101.392

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
#> 4.103950 1.838315 
#> 
#> $profile_out
#>       a1       a2       b1       b2 
#> 3.588357 4.628357 1.528099 2.272617
```

Additionally, multiple distribution models can be compared (for censored
and non-censored data).

``` r
multi_fitdist(
  data = rlnorm(n = 100, meanlog = 1, sdlog = 1), 
  models = c("lnorm", "gamma", "weibull")
)
#>    models    loglik      aic      bic
#> 1   lnorm -264.0081 532.0161 537.2265
#> 2 weibull -272.9079 549.8158 555.0262
#> 3   gamma -272.9284 549.8568 555.0672
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
