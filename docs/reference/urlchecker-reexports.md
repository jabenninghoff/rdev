# Functions re-exported from the urlchecker package

These functions are re-exported from the urlchecker package.

## Usage

``` r
url_check(
  path = ".",
  db = NULL,
  parallel = TRUE,
  pool = curl::new_pool(),
  progress = TRUE
)

url_update(path = ".", results = url_check(path))
```

## Arguments

- path:

  Path to the package

- db:

  A url database

- parallel:

  If `TRUE`, check the URLs in parallel

- pool:

  A multi handle created by
  [`curl::new_pool()`](https://jeroen.r-universe.dev/curl/reference/multi.html).
  If `NULL` use a global pool.

- progress:

  Whether to show the progress bar for parallel checks

- results:

  results from
  [url_check](https://rdrr.io/pkg/urlchecker/man/url_check.html).

## Details

Follow the links below to see the urlchecker documentation.

[`urlchecker::url_check()`](https://rdrr.io/pkg/urlchecker/man/url_check.html)

[`urlchecker::url_update()`](https://rdrr.io/pkg/urlchecker/man/url_update.html)
