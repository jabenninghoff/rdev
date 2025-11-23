# Update WORDLIST from notebooks

Update package `inst/WORDLIST` with words from
[`spell_check_notebooks()`](https://jabenninghoff.github.io/rdev/reference/spell_check_notebooks.md).

## Usage

``` r
update_wordlist_notebooks(
  pkg = ".",
  vignettes = TRUE,
  path = "analysis",
  regexp = "[.][Rq]md$",
  confirm = TRUE
)
```

## Arguments

- pkg:

  path to package root directory containing the `DESCRIPTION` file

- vignettes:

  check all `rmd` and `rnw` files in the pkg root directory (e.g.
  `readme.md`) and package `vignettes` folder.

- path:

  A character vector of one or more paths.

- regexp:

  A regular expression (e.g. `[.]csv$`) passed on to
  [`grep()`](https://rdrr.io/r/base/grep.html) to filter paths.

- confirm:

  show changes and ask confirmation before adding new words to the list

## Details

`update_wordlist_notebooks` is a customized version of
[`spelling::update_wordlist()`](https://docs.ropensci.org/spelling//reference/wordlist.html)
using code from
[`wordlist.R`](https://github.com/ropensci/spelling/blob/master/R/wordlist.R).
