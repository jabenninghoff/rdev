# Initialize rdev package

Initialize a rdev package within a newly created
[`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md)
project by creating a new git branch, committing all changes, and
running
[`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md).

## Usage

``` r
init()
```

## Details

`init()` will stop if
[`rlang::is_interactive()`](https://rlang.r-lib.org/reference/is_interactive.html)
is `FALSE`.

After running `init()`, update the Title and Description fields in the
`DESCRIPTION` file without committing and run either
[`setup_analysis()`](https://jabenninghoff.github.io/rdev/reference/setup_analysis.md)
or
[`setup_rdev()`](https://jabenninghoff.github.io/rdev/reference/setup_rdev.md)
per the
[quickstart](https://jabenninghoff.github.io/rdev/reference/quickstart.md).

## See also

[quickstart](https://jabenninghoff.github.io/rdev/reference/quickstart.md)
