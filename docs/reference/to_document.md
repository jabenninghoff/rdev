# Convert R Notebook to `html_document`

Copies a file using
[`fs::file_copy()`](https://fs.r-lib.org/reference/copy.html) and
changes the output type in the yaml front matter from `html_notebook` to
`html_document`, removing all other output types.

## Usage

``` r
to_document(file_path, new_path, overwrite = FALSE)
```

## Arguments

- file_path:

  Path to the source file

- new_path:

  Path to copy the converted file using
  [`fs::file_copy()`](https://fs.r-lib.org/reference/copy.html)

- overwrite:

  Overwrite file if it exists, passed to
  [`fs::file_copy()`](https://fs.r-lib.org/reference/copy.html)

## Value

Path to new file

## See also

[`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)

## Examples

``` r
if (FALSE) { # \dontrun{
to_document("notebook.Rmd", "document.Rmd")
to_document("notebooks_dir/notebook.Rmd", "documents_dir")
} # }
```
