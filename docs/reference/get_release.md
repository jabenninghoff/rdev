# Get release details

Extract release version and release notes from `NEWS.md`.

## Usage

``` r
get_release(pkg = ".", filename = "NEWS.md")
```

## Arguments

- pkg:

  path to package. Currently, only `pkg = "."` is supported.

- filename:

  name of file containing release notes, defaults to `NEWS.md`.

## Value

list containing the package, version and release notes from the first
release contained in `NEWS.md`

## Details

`get_release()` assumes that `NEWS.md` contains markdown release notes,
with each release header of the format: `"# <package> <version>"`
followed by the release notes, and expects the first line of `NEWS.md`
to be a release header.
