# Create an upkeep checklist in a GitHub issue

Opens an issue in the package repository with a checklist of tasks for
regular maintenance and adherence to rdev package standards. Some tasks
are meant to be done only once, and others should be reviewed
periodically. Adapted from
[`usethis::use_upkeep_issue()`](https://usethis.r-lib.org/reference/use_upkeep_issue.html)
and
[`usethis::use_tidy_upkeep_issue()`](https://usethis.r-lib.org/reference/tidyverse.html).

## Usage

``` r
use_upkeep_issue(last_upkeep = last_upkeep_year())
```

## Arguments

- last_upkeep:

  Year of last upkeep. By default, the `Config/rdev/last-upkeep` field
  in `DESCRIPTION` is consulted for this, if it's defined. If there's no
  information on the last upkeep, the issue will contain the full
  checklist.
