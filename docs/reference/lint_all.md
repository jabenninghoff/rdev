# Lint all files

Lint all files in a project. Implemented as a wrapper for
[`lintr::lint_dir()`](https://lintr.r-lib.org/reference/lint.html).

## Usage

``` r
lint_all(
  pattern = "(?i)[.](r|rmd|qmd|rnw|rhtml|rpres|rrst|rtex|rtxt)$",
  exclusions = list("renv", "packrat", "R/RcppExports.R"),
  ...
)
```

## Arguments

- pattern:

  regex pattern for files, by default it will take files with any of the
  extensions .R, .Rmd, .qmd, .Rnw, .Rhtml, .Rpres, .Rrst, .Rtex, .Rtxt,
  ignoring case.

- exclusions:

  exclusions for
  [`exclude()`](https://lintr.r-lib.org/reference/exclude.html),
  relative to the package path.

- ...:

  Arguments passed on to
  [`lintr::lint_dir`](https://lintr.r-lib.org/reference/lint.html)

  `parse_settings`

  :   Logical, default `TRUE`. Whether to try and parse the
      [settings](https://lintr.r-lib.org/reference/read_settings.html).
      Otherwise, the
      [`default_settings()`](https://lintr.r-lib.org/reference/default_settings.html)
      are used.

  `path`

  :   For the base directory of the project (for `lint_dir()`) or
      package (for `lint_package()`).

  `relative_path`

  :   if `TRUE`, file paths are printed using their path relative to the
      base directory. If `FALSE`, use the full absolute path.

  `show_progress`

  :   Logical controlling whether to show linting progress with a simple
      text progress bar *via*
      [`utils::txtProgressBar()`](https://rdrr.io/r/utils/txtProgressBar.html).
      The default behavior is to show progress in
      [`interactive()`](https://rdrr.io/r/base/interactive.html)
      sessions not running a testthat suite.

## Value

A list of lint objects.

## Examples

``` r
if (FALSE) { # \dontrun{
lint_all()
lint_all("analysis")
} # }
```
