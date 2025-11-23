# Set up rdev package

Set up an rdev package for traditional package development after running
[`init()`](https://jabenninghoff.github.io/rdev/reference/init.md) and
updating Title and Description in `DESCRIPTION`, by committing changes
and running
[`use_rdev_pkgdown()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_pkgdown.md),
[`use_spelling()`](https://jabenninghoff.github.io/rdev/reference/use_spelling.md),
[`use_codecov()`](https://jabenninghoff.github.io/rdev/reference/use_codecov.md),
and [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md).

## Usage

``` r
setup_rdev()
```

## Details

`setup_rdev()` will stop if
[`rlang::is_interactive()`](https://rlang.r-lib.org/reference/is_interactive.html)
is `FALSE`, and will run
[`open_files()`](https://jabenninghoff.github.io/rdev/reference/open_files.md)
if running in RStudio.

## See also

[quickstart](https://jabenninghoff.github.io/rdev/reference/quickstart.md)
