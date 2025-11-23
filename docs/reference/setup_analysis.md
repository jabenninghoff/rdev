# Set up analysis package

Set up an analysis package within an rdev package newly initialized with
[`init()`](https://jabenninghoff.github.io/rdev/reference/init.md),
after updating Title and Description in `DESCRIPTION`, by committing
changes and running
[`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md),
[`use_spelling()`](https://jabenninghoff.github.io/rdev/reference/use_spelling.md),
and [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md).

## Usage

``` r
setup_analysis(use_quarto = TRUE)
```

## Arguments

- use_quarto:

  If `TRUE` (the default), use Quarto for publishing
  ([`build_quarto_site()`](https://jabenninghoff.github.io/rdev/reference/build_quarto_site.md)),
  otherwise use
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md).

## Details

`setup_analysis()` will stop if
[`rlang::is_interactive()`](https://rlang.r-lib.org/reference/is_interactive.html)
is `FALSE`, and will run
[`open_files()`](https://jabenninghoff.github.io/rdev/reference/open_files.md)
if running in RStudio.

## See also

[quickstart](https://jabenninghoff.github.io/rdev/reference/quickstart.md)
