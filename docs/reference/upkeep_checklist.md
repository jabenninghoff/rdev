# Create upkeep checklist

Build an upkeep checklist following the format of
[`usethis::use_tidy_upkeep_issue()`](https://usethis.r-lib.org/reference/tidyverse.html).

## Usage

``` r
upkeep_checklist(last_upkeep = last_upkeep_year())
```

## Arguments

- last_upkeep:

  Year when upkeep was last performed.

## Value

Upkeep checklist for current year as a GitHub markdown array.
