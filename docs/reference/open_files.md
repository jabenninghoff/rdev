# Open rdev files

Open a standard set of files for editing in RStudio.

## Usage

``` r
open_files(files = c("TODO.md", "NEWS.md", "README.Rmd", "DESCRIPTION"))
```

## Arguments

- files:

  vector of files to open.

## Value

named character vector of files opened.

## Details

By default, `open_files()` opens four documents in RStudio: `TODO.md`,
`NEWS.md`, `README.Rmd`, and `DESCRIPTION`.

`open_files()` will stop with an error if RStudio is not running.
