# Use rdev pkgdown

Add pkgdown with rdev customizations. Implemented as a wrapper for
[`usethis::use_pkgdown()`](https://usethis.r-lib.org/reference/use_pkgdown.html).

## Usage

``` r
use_rdev_pkgdown(config_file = "_pkgdown.yml", destdir = "docs")
```

## Arguments

- config_file:

  Path to the pkgdown yaml config file, relative to the project.

- destdir:

  Target directory for pkgdown docs.

## Details

In addition to running
[`usethis::use_pkgdown()`](https://usethis.r-lib.org/reference/use_pkgdown.html),
`use_rdev_pkgdown` adds `extra.css` to `pkgdown` to fix rendering of
GitHub-style [task
lists](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/about-task-lists),
adds the GitHub Pages URL, and enables
[`template.light-switch`](https://pkgdown.r-lib.org/articles/customise.html#light-switch).
