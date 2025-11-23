# Spell Check Notebooks

Perform a spell check on notebooks with
[`spelling::spell_check_files()`](https://docs.ropensci.org/spelling//reference/spell_check_files.html).

## Usage

``` r
spell_check_notebooks(
  path = "analysis",
  regexp = "[.][Rq]md$",
  use_wordlist = TRUE,
  lang = NULL
)
```

## Arguments

- path:

  A character vector of one or more paths.

- regexp:

  A regular expression (e.g. `[.]csv$`) passed on to
  [`grep()`](https://rdrr.io/r/base/grep.html) to filter paths.

- use_wordlist:

  ignore words in the package
  [WORDLIST](https://docs.ropensci.org/spelling//reference/wordlist.html)
  file.

- lang:

  set `Language` field in `DESCRIPTION` e.g. `"en-US"` or `"en-GB"`. For
  supporting other languages, see the [hunspell
  vignette](https://docs.ropensci.org/hunspell/articles/intro.html#hunspell-dictionaries).

## Details

If `lang` is `NULL` (the default), get language from `DESCRIPTION` using
[`desc::desc_get_field()`](https://desc.r-lib.org/reference/desc_get_field.html).
