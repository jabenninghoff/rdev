
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rdev

<!-- badges: start -->

[![R-CMD-check](https://github.com/jabenninghoff/rdev/workflows/R-CMD-check/badge.svg)](https://github.com/jabenninghoff/rdev/actions)
[![lint](https://github.com/jabenninghoff/rdev/workflows/lint/badge.svg)](https://github.com/jabenninghoff/rdev/actions)
[![Codecov test
coverage](https://codecov.io/gh/jabenninghoff/rdev/branch/main/graph/badge.svg)](https://app.codecov.io/gh/jabenninghoff/rdev?branch=main)
<!-- badges: end -->

## Overview

**R Development Tools:** An opinionated collection of development tools,
packages, and utilities.

Feel free to use and/or fork this project!

## Installation

You can install the development version of rdev from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jabenninghoff/rdev")
```

Or using renv:

``` r
# install.packages("renv")
renv::install("jabenninghoff/rdev")
```

## Development

-   Changelog: See “Changelog” or `NEWS.md`.
-   Planned: [TODO](TODO.md)

## Creating Packages

rdev supports creation of new R packages following rdev conventions as
well as new [R
Analysis](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)
packages. The typical setup workflow is:

1.  Use `available::available()` to check package name
2.  Create new base package using `create_github_repo()`
3.  Add new package to GitHub Desktop
4.  Commit to git with message: `rdev::create_github_repo()`
5.  Run `use_rdev_package()` within new project to add remaining
    templates and settings
6.  Commit to git with message: `rdev::use_rdev_package()`
7.  Run either `use_analysis_package()` or `usethis::use_pkgdown()` for
    GitHub Pages
8.  Commit to git
9.  Edit DESCRIPTION and add a Title and Description
10. Update TODO.md, NEWS.md, README.Rmd, and DESCRIPTION as needed
11. Run `check_renv()`, `ci()` to validate package
12. Commit to git and begin development

## GitHub Releases

rdev automates the workflow for creating GitHub releases along with
updating GitHub pages for either standard R packages or R analysis
packages, using the release notes format in NEWS.md. A typical
development workflow is:

1.  Bump version and create new feature branch with `new_branch()`
2.  *Write all the things*
3.  Update the release notes for the new version in NEWS.md, following
    the conventions described in `get_release()`
4.  Finalize the release and merge all changes to git
5.  Run `stage_release()` to create a new pull request on GitHub using
    details derived from NEWS.md, including updating the README and
    GitHub pages
6.  After the pull request has been reviewed and passes all required
    status checks, accept the staged release with `merge_release()`,
    which merges the pull request, cleans up branches, and publishes a
    new GitHub release

Feature branches can be merged without starting a new release;
`stage_release()` just requires that everything is committed, including
new release notes in NEWS.md before running. When ready to release,
`stage_release()` will use the existing branch if on a feature branch,
and create a new release branch if on the default.

## Workflow

For my workflow, I typically check renv when I start:

``` r
library(rdev)

check_renv()
#> renv::status()
#> * The project is already synchronized with the lockfile.
#> 
#> renv::clean()
#> * No stale package locks were found.
#> * No temporary directories were found in the project library.
#> * The project has been cleaned.
```

I also have a `ci()` function to run all my continuous integration tests
locally:

``` r
ci()
#> renv::status()
#> * The project is already synchronized with the lockfile.
#> 
#> style_all()
#> Styling  48  files:
#>  .Rprofile                                               ✔ 
#>  README.Rmd                                              ✔ 
#>  inst/rmarkdown/templates/analysis/skeleton/skeleton.Rmd ✔ 
#>  inst/templates/package.R                                ✔ 
#>  inst/templates/README-analysis.Rmd                      ✔ 
#>  inst/templates/README-rdev.Rmd                          ✔ 
#>  inst/templates/spelling.R                               ✔ 
#>  inst/templates/test-spelling.R                          ✔ 
#>  R/build.R                                               ✔ 
#>  R/ci.R                                                  ✔ 
#>  R/helpers.R                                             ✔ 
#>  R/init.R                                                ✔ 
#>  R/package.R                                             ✔ 
#>  R/release.R                                             ✔ 
#>  R/setup.R                                               ✔ 
#>  R/to_document.R                                         ✔ 
#>  R/urlchecker.R                                          ✔ 
#>  R/utils.R                                               ✔ 
#>  tests/spelling.R                                        ✔ 
#>  tests/testthat.R                                        ✔ 
#>  tests/manual/setup.Rmd                                  ✔ 
#>  tests/manual/test-new-repo-1.R                          ✔ 
#>  tests/manual/test-new-repo-2.R                          ✔ 
#>  tests/manual/test-new-repo-3-analysis.R                 ✔ 
#>  tests/manual/test-new-repo-3-package.R                  ✔ 
#>  tests/testthat/test-build.R                             ✔ 
#>  tests/testthat/test-ci.R                                ✔ 
#>  tests/testthat/test-helpers.R                           ✔ 
#>  tests/testthat/test-init.R                              ✔ 
#>  tests/testthat/test-inst.R                              ✔ 
#>  tests/testthat/test-release.R                           ✔ 
#>  tests/testthat/test-setup.R                             ✔ 
#>  tests/testthat/test-spelling.R                          ✔ 
#>  tests/testthat/test-to_document.R                       ✔ 
#>  tests/testthat/test-utils.R                             ✔ 
#>  tests/testthat/test-ci/testcode_1.R                     ✔ 
#>  tests/testthat/test-ci/testcode_2.R                     ✔ 
#>  tests/testthat/test-ci/testcode.Rmd                     ✔ 
#>  tests/testthat/test-to_document/document.Rmd            ✔ 
#>  tests/testthat/test-to_document/extra-spaces.Rmd        ✔ 
#>  tests/testthat/test-to_document/minimal-document.Rmd    ✔ 
#>  tests/testthat/test-to_document/minimal.Rmd             ✔ 
#>  tests/testthat/test-to_document/multiple.Rmd            ✔ 
#>  tests/testthat/test-to_document/no-front-matter.Rmd     ✔ 
#>  tests/testthat/test-to_document/no-yaml.Rmd             ✔ 
#>  tests/testthat/test-to_document/valid.Rmd               ✔ 
#>  tests/testthat/test-to_document/with-code.Rmd           ✔ 
#>  vignettes/analysis-package-layout.Rmd                   ✔ 
#> ───────────────────────────────────────────────────────
#> Status   Count   Legend 
#> ✔    48  File unchanged.
#> ℹ    0   File changed.
#> ✖    0   Styling threw an error.
#> ───────────────────────────────────────────────────────
#> 
#> lint_all()
#> 
#> devtools::document()
#> ℹ Updating rdev documentation
#> ℹ Loading rdev
#> 
#> Setting env vars: NOT_CRAN="true", CI="true"
#> rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> * checking for file ‘.../DESCRIPTION’ ... OK
#> * preparing ‘rdev’:
#> * checking DESCRIPTION meta-information ... OK
#> * installing the package to build vignettes
#> * creating vignettes ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> * building ‘rdev_1.5.0.tar.gz’
#> 
#> ── R CMD check ─────────────────────────────────────────────────────────────────
#> * using log directory ‘/private/var/folders/vn/cw5f9gws42v9m8mdsds_zbl00000gp/T/RtmpREadqj/file132f02410d8b3/rdev.Rcheck’
#> * using R version 4.2.0 (2022-04-22)
#> * using platform: x86_64-apple-darwin19.6.0 (64-bit)
#> * using session charset: UTF-8
#> * using option ‘--no-manual’
#> * checking for file ‘rdev/DESCRIPTION’ ... OK
#> * this is package ‘rdev’ version ‘1.5.0’
#> * package encoding: UTF-8
#> * checking package namespace information ... OK
#> * checking package dependencies ... OK
#> * checking if this is a source package ... OK
#> * checking if there is a namespace ... OK
#> * checking for executable files ... OK
#> * checking for hidden files and directories ... OK
#> * checking for portable file names ... OK
#> * checking for sufficient/correct file permissions ... OK
#> * checking whether package ‘rdev’ can be installed ... OK
#> * checking installed package size ... OK
#> * checking package directory ... OK
#> * checking ‘build’ directory ... OK
#> * checking DESCRIPTION meta-information ... OK
#> * checking top-level files ... OK
#> * checking for left-over files ... OK
#> * checking index information ... OK
#> * checking package subdirectories ... OK
#> * checking R files for non-ASCII characters ... OK
#> * checking R files for syntax errors ... OK
#> * checking whether the package can be loaded ... OK
#> * checking whether the package can be loaded with stated dependencies ... OK
#> * checking whether the package can be unloaded cleanly ... OK
#> * checking whether the namespace can be loaded with stated dependencies ... OK
#> * checking whether the namespace can be unloaded cleanly ... OK
#> * checking loading without being on the library search path ... OK
#> * checking dependencies in R code ... OK
#> * checking S3 generic/method consistency ... OK
#> * checking replacement functions ... OK
#> * checking foreign function calls ... OK
#> * checking R code for possible problems ... OK
#> * checking Rd files ... OK
#> * checking Rd metadata ... OK
#> * checking Rd cross-references ... OK
#> * checking for missing documentation entries ... OK
#> * checking for code/documentation mismatches ... OK
#> * checking Rd \usage sections ... OK
#> * checking Rd contents ... OK
#> * checking for unstated dependencies in examples ... OK
#> * checking installed files from ‘inst/doc’ ... OK
#> * checking files in ‘vignettes’ ... OK
#> * checking examples ... OK
#> * checking for unstated dependencies in ‘tests’ ... OK
#> * checking tests ...
#>   Running ‘spelling.R’
#>   Comparing ‘spelling.Rout’ to ‘spelling.Rout.save’ ... OK
#>   Running ‘testthat.R’
#>  OK
#> * checking for unstated dependencies in vignettes ... OK
#> * checking package vignettes in ‘inst/doc’ ... OK
#> * checking running R code from vignettes ...
#>   ‘analysis-package-layout.Rmd’ using ‘UTF-8’... OK
#>  NONE
#> * checking re-building of vignette outputs ... OK
#> * DONE
#> Status: OK
#> ── R CMD check results ───────────────────────────────────────── rdev 1.5.0 ────
#> Duration: 36.4s
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
