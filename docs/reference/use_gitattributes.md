# Use rdev .gitattributes

Install rdev .gitattributes template using
[`usethis::use_template()`](https://usethis.r-lib.org/reference/use_template.html)
to set GitHub Linguist
[overrides](https://github.com/github-linguist/linguist/blob/main/docs/overrides.md).
If an analysis package is detected, RMarkdown will be enabled as a
language for GitHub statistics.

## Usage

``` r
use_gitattributes(open = FALSE)
```

## Arguments

- open:

  Open the newly created file for editing? Happens in RStudio, if
  applicable, or via
  [`utils::file.edit()`](https://rdrr.io/r/utils/file.edit.html)
  otherwise.
