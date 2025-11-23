# Use rdev package conventions

Add rdev templates and settings within the active package. Normally
invoked when first setting up a package.

## Usage

``` r
use_rdev_package(quiet = TRUE)
```

## Arguments

- quiet:

  If TRUE, disable user prompts by setting
  [`rlang::local_interactive()`](https://rlang.r-lib.org/reference/is_interactive.html)
  to FALSE.

## GitHub Pages

GitHub Pages is enabled by default for public repositories, and can be
disabled by setting `rdev.github.pages` to `FALSE`:
`options(rdev.github.pages = FALSE)`. GitHub Pages is disabled by
default for private repositories (as it is not supported on the free
plan), and can be enabled by setting `rdev.github.pages` to `TRUE`.

## GitHub Actions

GitHub Actions can be disabled by setting `rdev.github.actions` to
`FALSE`: `options(rdev.github.actions = FALSE)`
