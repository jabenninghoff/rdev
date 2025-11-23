# Check dependencies

Check dependencies in DESCRIPTION.

## Usage

``` r
missing_deps(exclude_base = TRUE)

extra_deps()
```

## Arguments

- exclude_base:

  exclude packages installed with R from missing dependencies

## Value

data.frame from either
[`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html)
or
[`desc::desc_get_deps()`](https://desc.r-lib.org/reference/desc_get_deps.html).

## Details

`missing_deps()` reports
[`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html)
not in DESCRIPTION.

`extra_deps()` reports
[`desc::desc_get_deps()`](https://desc.r-lib.org/reference/desc_get_deps.html)
not found by renv.

The current package
([`pkgload::pkg_name(".")`](https://pkgload.r-lib.org/reference/packages.html))
and `renv` (in `renv.lock` only) are automatically removed from
[`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html),
along with 'base' R packages if `exclude_base` is `TRUE` (base,
compiler, datasets, grDevices, graphics, grid, methods, parallel,
splines, stats, stats4, tcltk, tools, utils).
