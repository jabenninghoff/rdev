# Build Quarto Site

`build_quarto_site()` is a wrapper for
[`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)
that also updates `README.md` and optionally deletes the Quarto
`_freeze` directory to fully re-render the site.

## Usage

``` r
build_quarto_site(input = NULL, as_job = FALSE, unfreeze = FALSE, ...)
```

## Arguments

- input:

  The input file or project directory to be rendered (defaults to
  rendering the project in the current working directory).

- as_job:

  Render as an RStudio background job. Default is `"auto"`, which will
  render individual documents normally and projects as background jobs.
  Use the `quarto.render_as_job` R option to control the default
  globally.

- unfreeze:

  If `TRUE`, delete the Quarto `_freeze` directory to fully re-render
  the site.

- ...:

  Arguments passed to
  [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html).

## Details

When run, `build_quarto_site()` calls:

1.  [`devtools::build_readme()`](https://devtools.r-lib.org/reference/build_rmd.html)

2.  [`unfreeze()`](https://jabenninghoff.github.io/rdev/reference/unfreeze.md)
    (if `unfreeze = TRUE`)

3.  [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)

## Supported File Types

While `build_quarto_site()` supports both R Markdown (`.Rmd`) and Quarto
(`.qmd`) notebooks in the `analysis` directory interchangeably,
[`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
supports `.Rmd` files only.
