# Build rdev Site

`build_rdev_site()` is a wrapper for
[`pkgdown::build_site_github_pages()`](https://pkgdown.r-lib.org/reference/build_site_github_pages.html)
optimized for rdev workflow that updates `README.md` and performs a
clean GitHub pages build using `pkgdown`.

## Usage

``` r
build_rdev_site(pkg = ".", ...)
```

## Arguments

- pkg:

  Path to package. Currently, only `pkg = "."` is supported.

- ...:

  additional arguments passed to
  [`pkgdown::build_site_github_pages()`](https://pkgdown.r-lib.org/reference/build_site_github_pages.html)
  (not implemented)

## Details

When run, `build_rdev_site()` calls:

1.  [`devtools::build_readme()`](https://devtools.r-lib.org/reference/build_rmd.html)

2.  [`pkgdown::build_site_github_pages()`](https://pkgdown.r-lib.org/reference/build_site_github_pages.html)
    with `install = TRUE` and `new_process = TRUE`

## Continuous Integration

Both `build_rdev_site()` and
[`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
are meant to be used as part of a CI/CD workflow, and temporarily set
the environment variable `CI == "TRUE"` so that the build will fail when
non-internal topics are not included on the reference index page per
[`pkgdown::build_reference()`](https://pkgdown.r-lib.org/reference/build_reference.html).
