# Check URLs in HTML files

Runs
[`urlchecker::url_check()`](https://rdrr.io/pkg/urlchecker/man/url_check.html)
with a database created using the `url_db_from_HTML_files` function in
the tools package.

## Usage

``` r
html_url_check(
  path = "docs",
  parallel = TRUE,
  pool = curl::new_pool(),
  progress = TRUE
)
```

## Arguments

- path:

  Path to the directory of HTML files

- parallel:

  If `TRUE`, check the URLs in parallel

- pool:

  A multi handle created by
  [`curl::new_pool()`](https://jeroen.r-universe.dev/curl/reference/multi.html).
  If `NULL` use a global pool.

- progress:

  Whether to show the progress bar for parallel checks

## Value

A `url_checker_db` object (invisibly). This is a `check_url_db` object
with an added class with a custom print method.
