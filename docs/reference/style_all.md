# Style all files

Style all files in a project. Implemented as a wrapper for
[`styler::style_dir()`](https://styler.r-lib.org/reference/style_dir.html)
that defaults to styling `.R`, `.Rprofile`, `.Rmd`, `.Rmarkdown`,
`.Rnw`, and `.qmd` files, excluding files in `packrat`, `renv`, and
`R/RcppExports.R`.

## Usage

``` r
style_all(
  path = ".",
  filetype = c("R", "Rprofile", "Rmd", "Rmarkdown", "Rnw", "Qmd"),
  exclude_dirs = c("packrat", "renv"),
  exclude_files = "R/RcppExports.R",
  ...
)
```

## Arguments

- path:

  Path to a directory with files to transform.

- filetype:

  Vector of file extensions indicating which file types should be
  styled. Case is ignored, and the `.` is optional, e.g.
  `c(".R",".Rmd")`, or `c("r", "rmd")`. Supported values (after
  standardization) are: "qmd", "r", "rmd", "rmarkdown", "rnw", and
  "rprofile". Rmarkdown is treated as Rmd.

- exclude_dirs:

  Character vector with directories to exclude (recursively).

- exclude_files:

  Character vector with regular expressions to files that should be
  excluded from styling.

- ...:

  Arguments passed on to
  [`styler::style_dir`](https://styler.r-lib.org/reference/style_dir.html)

  `style`

  :   A function that creates a style guide to use, by default
      [`tidyverse_style`](https://styler.r-lib.org/reference/tidyverse_style.html).
      Not used further except to construct the argument `transformers`.
      See
      [`style_guides()`](https://styler.r-lib.org/reference/style_guides.html)
      for details.

  `transformers`

  :   A set of transformer functions. This argument is most conveniently
      constructed via the `style` argument and `...`. See 'Examples'.

  `recursive`

  :   A logical value indicating whether or not files in sub directories
      of `path` should be styled as well.

  `include_roxygen_examples`

  :   Whether or not to style code in roxygen examples.

  `base_indention`

  :   Integer scalar indicating by how many spaces the whole output text
      should be indented. Note that this is not the same as splitting by
      line and add a `base_indention` spaces before the code in the case
      multi-line strings are present. See 'Examples'.

  `dry`

  :   To indicate whether styler should run in *dry* mode, i.e. refrain
      from writing back to files .`"on"` and `"fail"` both don't write
      back, the latter returns an error if the input code is not
      identical to the result of styling. "off", the default, writes
      back if the input and output of styling are not identical.

## Examples

``` r
if (FALSE) { # \dontrun{
style_all()
style_all("analysis", filetype = "Rmd")
} # }
```
