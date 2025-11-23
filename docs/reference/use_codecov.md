# Use rdev code coverage

Install code coverage with
[`usethis::use_coverage(type = "codecov")`](https://usethis.r-lib.org/reference/use_coverage.html),
`DT` package for
[`covr::report()`](http://covr.r-lib.org/reference/report.md), and rdev
GitHub action `test-coverage.yaml`.

## Usage

``` r
use_codecov(prompt = FALSE)
```

## Arguments

- prompt:

  If TRUE, prompt before writing `renv.lock`, passed to
  [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html).

## Details

Because
[`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md),
[`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)
and `use_codecov()` all modify README.Rmd, `use_codecov()` must be run
last or its changes will be overwritten. `use_codecov()` is not run in
[`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md).

Set option `rdev.codecov` to `FALSE` to skip installation of codecov.io
and `test-coverage.yaml`: `options(rdev.codecov = FALSE)`

## GitHub Actions

GitHub Actions can be disabled by setting `rdev.github.actions` to
`FALSE`: `options(rdev.github.actions = FALSE)`
