
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rdev

<!-- badges: start -->

[![R-CMD-check](https://github.com/jabenninghoff/rdev/workflows/R-CMD-check/badge.svg)](https://github.com/jabenninghoff/rdev/actions)
[![lint](https://github.com/jabenninghoff/rdev/workflows/lint/badge.svg)](https://github.com/jabenninghoff/rdev/actions)
<!-- badges: end -->

## Overview

**R Development Tools:** My personalized collection of development
packages, tools and utility functions.

Feel free to use and/or fork this project!

## Installation

You can install the development version from
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

## Examples

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
#> 
#> renv::update()
#> * Querying repositories for available source packages ... Done!
#> * Checking for updated packages ... Done!
#> * All packages appear to be up-to-date.
```

I also have a `ci()` function to run all my continuous integration tests
locally:

``` r
ci()
#> ℹ Updating rdev documentation
#> ℹ Loading rdev
#> Writing NAMESPACE
#> Writing NAMESPACE
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> * checking for file ‘.../DESCRIPTION’ ... OK
#> * preparing ‘rdev’:
#> * checking DESCRIPTION meta-information ... OK
#> * installing the package to build vignettes
#> * creating vignettes ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> Omitted ‘LazyData’ from DESCRIPTION
#> * building ‘rdev_0.5.0.tar.gz’
#> 
#> ── R CMD check ─────────────────────────────────────────────────────────────────
#> * using log directory ‘/private/var/folders/vn/cw5f9gws42v9m8mdsds_zbl00000gp/T/RtmpfRpPor/filefcb014d6113f/rdev.Rcheck’
#> * using R version 4.1.2 (2021-11-01)
#> * using platform: x86_64-apple-darwin19.6.0 (64-bit)
#> * using session charset: UTF-8
#> * using option ‘--no-manual’
#> * checking for file ‘rdev/DESCRIPTION’ ... OK
#> * this is package ‘rdev’ version ‘0.5.0’
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
#>   Running ‘testthat.R’
#>  OK
#> * checking for unstated dependencies in vignettes ... OK
#> * checking package vignettes in ‘inst/doc’ ... OK
#> * checking running R code from vignettes ...
#>   ‘analysis-package-layout.Rmd’ using ‘UTF-8’... OK
#>   ‘rdev-style.Rmd’ using ‘UTF-8’... OK
#>  NONE
#> * checking re-building of vignette outputs ... OK
#> * DONE
#> Status: OK
#> ── R CMD check results ───────────────────────────────────────── rdev 0.5.0 ────
#> Duration: 31s
#> 
#> 0 errors ✓ | 0 warnings ✓ | 0 notes ✓
```
