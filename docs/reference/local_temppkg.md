# Temporary package

Temporarily create a rdev or R analysis package, which is automatically
removed afterwards.

## Usage

``` r
local_temppkg(dir = fs::file_temp(), type = "usethis", env = parent.frame())
```

## Arguments

- dir:

  Path to package directory, created if necessary, defaults to
  [`fs::file_temp()`](https://fs.r-lib.org/reference/file_temp.html).

- type:

  type of package to create, one of "usethis" -
  [`usethis::create_package()`](https://usethis.r-lib.org/reference/create_package.html),
  "rdev" -
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md),
  "analysis" -
  [`use_analysis_package(use_quarto = FALSE)`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md),
  or "quarto" -
  [`use_analysis_package(use_quarto = TRUE)`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md).

- env:

  Environment passed to
  [`withr::defer()`](https://withr.r-lib.org/reference/defer.html),
  defaults to
  [`parent.frame()`](https://rdrr.io/r/base/sys.parent.html).

## Value

Path to temporary package directory.

## Details

Used internally for testing rdev automation. Based on the [usethis case
study](https://testthat.r-lib.org/articles/test-fixtures.html#case-study-usethis)
from
[`testthat`](https://testthat.r-lib.org/reference/testthat-package.html).

## See also

[withr::withr-package](https://withr.r-lib.org/reference/withr.html)

## Examples

``` r
if (FALSE) { # \dontrun{
test_that("local_temppkg creates a directory", {
  dir <- usethis::ui_silence(local_temppkg())
  expect_true(fs::dir_exists(dir))
})
} # }
```
