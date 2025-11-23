# Determine rdev package type

Use heuristics (when `strict = FALSE`) or presence of specific files
(when `strict = TRUE`) to determine package type. If one of the files is
found, the package is strictly determined:

## Usage

``` r
package_type(pkg = ".", strict = FALSE)
```

## Arguments

- pkg:

  path to package

- strict:

  strictly determine package type (see description)

## Value

type string, one of `c("unknown", rdev", "analysis", "quarto")`

## Details

- If `_quarto.yml` is found, the type is `quarto`

- If `pkgdown/_base.yml` is found, the type is `analysis`

- If `_pkgdown.yml` is found, the type is `rdev`

`package_type` will return `unknown` if `strict = TRUE` and none of the
files are present. When strict checking is disabled, the package is
assumed to be `analysis` if an `analysis` directory is present, and
`rdev` if not.
