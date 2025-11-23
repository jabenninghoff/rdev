# Use rdev spelling

Install
[spelling](https://docs.ropensci.org/spelling//reference/spell_check_package.html)
with rdev conventions.

## Usage

``` r
use_spelling(lang = "en-US", prompt = FALSE)
```

## Arguments

- lang:

  Preferred spelling language. Usually either `"en-US"` or `"en-GB"`.

- prompt:

  If TRUE, prompt before writing `renv.lock`, passed to
  [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html).

## Details

Since
[`spelling::spell_check_setup()`](https://docs.ropensci.org/spelling//reference/spell_check_package.html)
requires user interaction, `use_spelling()` is not run in
[`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md).
