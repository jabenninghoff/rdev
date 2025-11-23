# Summarize package downloads

A wrapper for
[`cranlogs::cran_downloads()`](https://r-hub.github.io/cranlogs/reference/cran_downloads.html)
that summarizes the number of package downloads from the RStudio CRAN
mirror.

## Usage

``` r
package_downloads(packages, when = "last-month")
```

## Arguments

- packages:

  A character vector of the packages to query.

- when:

  The period to summarize, one of `last-day`, `last-week` or
  `last-month` (the default).

## Value

A data frame containing the total number of downloads by package for the
specified period, sorted by popularity.

## Details

By default, the summary is for the last month.
