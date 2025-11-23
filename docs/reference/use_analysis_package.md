# Use Analysis Package Layout

Add the [Analysis Package
Layout](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)
to the current package.

## Usage

``` r
use_analysis_package(use_quarto = TRUE, prompt = FALSE)
```

## Arguments

- use_quarto:

  If `TRUE` (the default), use Quarto for publishing
  ([`build_quarto_site()`](https://jabenninghoff.github.io/rdev/reference/build_quarto_site.md)),
  otherwise use
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md).

- prompt:

  If TRUE, prompt before writing `renv.lock`, passed to
  [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html).

## Value

List containing `dirs` created, `rbuildignore` lines added to
.Rbuildignore, `gitignore` exclusions added to .gitignore.

## Details

When run, `use_analysis_package()`:

1.  Creates analysis package directories

2.  Adds exclusions to .gitignore and .Rbuildignore

3.  Adds `extra.css` to `analysis/assets` and `pkgdown` (when
    `use_quarto` is `FALSE`) to fix rendering of GitHub-style [task
    lists](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/about-task-lists)

4.  Adds `.nojekyll`, `_quarto.yml`, `changelog.qmd`, `index.qmd` and
    `analysis/_metadata.yml` from templates OR creates `_base.yml` in
    `pkgdown` from the first `URL` in `DESCRIPTION`

5.  Installs the `README.Rmd` template for analysis packages, and the
    `dplyr` package needed for the `README.Rmd` template
