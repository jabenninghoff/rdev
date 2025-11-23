# Get analysis notebook metadata

Extract the YAML front matter and 'description' line from an [analysis
notebook](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html),
and construct a URL to the notebook's location on GitHub pages.

## Usage

``` r
rmd_metadata(file_path)
```

## Arguments

- file_path:

  Path to analysis notebook

## Value

Named list containing analysis notebook title, URL, date, and
description

## Details

The 'description' line is the the first non-blank line in the body of an
R notebook that serves as a brief description of the work.

For quarto packages, `rmd_metadata()` will extract the YAML front matter
and description from Quarto format (`.qmd`) notebooks.
