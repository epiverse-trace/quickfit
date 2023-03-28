
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
#> → Will install 3 packages.
#> → Will install 3 packages.
#> → Will download 2 CRAN packages (793.30 kB), cached: 1 (0 B).
#> → Will download 2 CRAN packages (793.30 kB), cached: 1 (0 B).
#> + backports   1.4.1  ⬇ (98.74 kB)
#> + checkmate   2.1.0  ⬇ (694.55 kB)
#> + readepi     0.0.1 👷🏾‍♀️🔧 (GitHub: 6707090)
#> + backports   1.4.1  ⬇ (98.74 kB)
#> + checkmate   2.1.0  ⬇ (694.55 kB)
#> + readepi     0.0.1 👷🏾‍♀️🔧 (GitHub: 6707090)
#> ℹ Getting 2 pkgs (793.30 kB), 1 cached
#> ℹ Getting 2 pkgs (793.30 kB), 1 cached
#> ✔ Got backports 1.4.1 (x86_64-apple-darwin17.0) (98.74 kB)
#> ✔ Got backports 1.4.1 (x86_64-apple-darwin17.0) (98.74 kB)
#> ✔ Got checkmate 2.1.0 (x86_64-apple-darwin17.0) (694.55 kB)
#> ✔ Got checkmate 2.1.0 (x86_64-apple-darwin17.0) (694.55 kB)
#> ✔ Got readepi 0.0.1 (source) (15.63 kB)
#> ✔ Got readepi 0.0.1 (source) (15.63 kB)
#> ✔ Installed backports 1.4.1  (65ms)
#> ✔ Installed backports 1.4.1  (65ms)
#> ✔ Installed checkmate 2.1.0  (351ms)
#> ✔ Installed checkmate 2.1.0  (351ms)
#> ℹ Packaging readepi 0.0.1
#> ℹ Packaging readepi 0.0.1
#> ✔ Packaged readepi 0.0.1 (1s)
#> ✔ Packaged readepi 0.0.1 (1s)
#> ℹ Building readepi 0.0.1
#> ℹ Building readepi 0.0.1
#> ✔ Built readepi 0.0.1 (1.5s)
#> ✔ Built readepi 0.0.1 (1.5s)
#> ✔ Installed readepi 0.0.1 (github::epiverse-trace/quickfit@6707090) (31ms)
#> ✔ Installed readepi 0.0.1 (github::epiverse-trace/quickfit@6707090) (31ms)
#> ✔ 1 pkg + 2 deps: added 3, dld 3 (NA B) [13.3s]
#> ✔ 1 pkg + 2 deps: added 3, dld 3 (NA B) [13.3s]
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
#> 4.264514 1.953023 
#> 
#> $log_likelihood
#> [1] -104.418

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
#> 4.264514 1.953023 
#> 
#> $profile_out
#>       a1       a2       b1       b2 
#> 3.714837 4.814837 1.623450 2.414425
```

Additionally, multiple distribution models can be compared (for censored
and non-censored data).

``` r
multi_fitdist(
  data = rlnorm(n = 100, meanlog = 1, sdlog = 1), 
  models = c("lnorm", "gamma", "weibull")
)
#>    models    loglik      aic      bic
#> 1   lnorm -258.6797 521.3593 526.5697
#> 2 weibull -271.7130 547.4260 552.6363
#> 3   gamma -277.1335 558.2671 563.4774
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
