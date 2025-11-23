# Local CI

Run continuous integration tests locally.

## Usage

``` r
ci(
  renv = TRUE,
  missing = TRUE,
  pkgdown = TRUE,
  styler = NULL,
  lintr = TRUE,
  document = TRUE,
  normalize = TRUE,
  extra = TRUE,
  spelling = TRUE,
  urls = TRUE,
  rcmdcheck = TRUE
)
```

## Arguments

- renv:

  check
  [`renv::status(dev = TRUE)`](https://rstudio.github.io/renv/reference/status.html)

- missing:

  run
  [`missing_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)

- pkgdown:

  check
  [`pkgdown::check_pkgdown()`](https://pkgdown.r-lib.org/reference/check_pkgdown.html)
  if `_pkgdown.yml` exists

- styler:

  style all files using
  [`style_all()`](https://jabenninghoff.github.io/rdev/reference/style_all.md),
  see details

- lintr:

  lint all files using
  [`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md)

- document:

  run
  [`devtools::document()`](https://devtools.r-lib.org/reference/document.html)

- normalize:

  run
  [`desc::desc_normalize()`](https://desc.r-lib.org/reference/desc_normalize.html)

- extra:

  run
  [`extra_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)

- spelling:

  update spelling
  [`WORDLIST`](https://docs.ropensci.org/spelling//reference/wordlist.html)

- urls:

  validate URLs with
  [`url_check()`](https://jabenninghoff.github.io/rdev/reference/urlchecker-reexports.md)
  and
  [`html_url_check()`](https://jabenninghoff.github.io/rdev/reference/html_url_check.md)

- rcmdcheck:

  run `R CMD check` using:
  [`rcmdcheck::rcmdcheck(args = "–no-manual", error_on = "warning")`](http://r-lib.github.io/rcmdcheck/reference/rcmdcheck.md)

## Details

If
[`renv::status(dev = TRUE)`](https://rstudio.github.io/renv/reference/status.html)
is not synchronized, `ci()` will stop.

If
[`missing_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)
returns any missing dependencies, `ci()` will stop.

[`pkgdown::check_pkgdown()`](https://pkgdown.r-lib.org/reference/check_pkgdown.html)
will halt `ci()` with an error if `_pkgdown.yml` is invalid.

If `styler` is set to `NULL` (the default),
[`style_all()`](https://jabenninghoff.github.io/rdev/reference/style_all.md)
will be run only if there are no uncommitted changes to git. Setting the
value to `TRUE` or `FALSE` overrides this check.

If
[`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md)
finds any lints, `ci()` will stop and open the RStudio markers pane.

Output from `missing`, `extra`, and `urls` is printed as a
[tibble](https://tibble.tidyverse.org/reference/tibble.html) for
improved readability in the console.

## Examples

``` r
if (FALSE) { # \dontrun{
ci()
ci(styler = TRUE)
ci(styler = FALSE, rcmdcheck = FALSE)
} # }
```
