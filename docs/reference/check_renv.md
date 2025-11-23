# Check renv

Runs
[`renv`](https://rstudio.github.io/renv/reference/renv-package.html)
[`status(dev = TRUE)`](https://rstudio.github.io/renv/reference/status.html),
[`clean()`](https://rstudio.github.io/renv/reference/clean.html), and
optionally
[`update()`](https://rstudio.github.io/renv/reference/update.html)

## Usage

``` r
check_renv(update = rlang::is_interactive())
```

## Arguments

- update:

  run
  [`renv::update()`](https://rstudio.github.io/renv/reference/update.html)

## Examples

``` r
if (FALSE) { # \dontrun{
check_renv()
check_renv(update = FALSE)
} # }
```
