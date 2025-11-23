# Build Analysis Site

`build_analysis_site()` is a wrapper for
[`pkgdown::build_site_github_pages()`](https://pkgdown.r-lib.org/reference/build_site_github_pages.html)
that adds an 'Analysis' menu containing rendered versions of all .Rmd
files in `analysis/`.

## Usage

``` r
build_analysis_site(pkg = ".", ...)
```

## Arguments

- pkg:

  Path to package. Currently, only `pkg = "."` is supported.

- ...:

  additional arguments passed to
  [`pkgdown::build_site_github_pages()`](https://pkgdown.r-lib.org/reference/build_site_github_pages.html)
  (not implemented)

## Value

rmarkdown \_site.yml as yaml, invisibly

## Details

When run, `build_analysis_site()`:

1.  Reads base
    [pkgdown::pkgdown](https://pkgdown.r-lib.org/reference/pkgdown-package.html)
    settings from `pkgdown/_base.yml`

2.  Writes base settings to `_pkgdown.yml`

3.  Creates a template using
    [`pkgdown::template_navbar()`](https://pkgdown.r-lib.org/reference/templates.html)
    and inserts an `analysis` menu with links to html versions of each
    .Rmd file in `analysis/`

4.  Writes the template to `_pkgdown.yml`

5.  Updates `README.md` by running
    [`devtools::build_readme()`](https://devtools.r-lib.org/reference/build_rmd.html)
    (if `README.Rmd` exists) to update the list of notebooks

6.  Runs
    [`pkgdown::build_site_github_pages()`](https://pkgdown.r-lib.org/reference/build_site_github_pages.html)
    with `install = TRUE` and `new_process = TRUE`

7.  Creates a `_site.yml` file based on the final `_pkgdown.yml` that
    clones the
    [pkgdown::pkgdown](https://pkgdown.r-lib.org/reference/pkgdown-package.html)
    navbar in a temporary build directory

8.  Copies the following from `analysis/` into the build directory:
    `*.Rmd`, `assets/`, `data/`, `import/`, `rendered/`

9.  Changes `*.Rmd` from `html_notebook` to `html_document` using
    [`to_document()`](https://jabenninghoff.github.io/rdev/reference/to_document.md)

10. Builds a site using
    [`rmarkdown::render_site()`](https://pkgs.rstudio.com/rmarkdown/reference/render_site.html)
    using modified `html_document` output settings to render files with
    the look and feel of `html_notebook`

11. Moves the rendered files to `docs/`: `*.html`, `assets/`,
    `rendered/`, without overwriting

`build_analysis_site()` will fail with an error if there are no files in
`analysis/*.Rmd`, or if `pkgdown/_base.yml` does not exist.

## Continuous Integration

Both
[`build_rdev_site()`](https://jabenninghoff.github.io/rdev/reference/build_rdev_site.md)
and `build_analysis_site()` are meant to be used as part of a CI/CD
workflow, and temporarily set the environment variable `CI == "TRUE"` so
that the build will fail when non-internal topics are not included on
the reference index page per
[`pkgdown::build_reference()`](https://pkgdown.r-lib.org/reference/build_reference.html).

## Supported File Types

While
[`build_quarto_site()`](https://jabenninghoff.github.io/rdev/reference/build_quarto_site.md)
supports both R Markdown (`.Rmd`) and Quarto (`.qmd`) notebooks in the
`analysis` directory interchangeably, `build_analysis_site()` supports
`.Rmd` files only.
