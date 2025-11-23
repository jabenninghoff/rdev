# Get license option

Retrieve and validate `rdev.license` option.

## Usage

``` r
get_license()
```

## Value

license string, one of `c("mit", "gpl", "lgpl", "proprietary")`

## Details

`rdev.license` must be one of `c("mit", "gpl", "lgpl", "proprietary")`,
and defaults to `"mit"`. If `rdev.license` is `"proprietary"`,
`rdev.license.copyright` (the name of the copyright holder) must also be
set.
