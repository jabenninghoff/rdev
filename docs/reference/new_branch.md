# Start a new branch

Create a new "feature" branch from the current or default branch of the
project git repository using
[`gert::git_branch_create()`](https://docs.ropensci.org/gert/reference/git_branch.html)
and bump 'dev' version to 9000 with
[`desc::desc_bump_version()`](https://desc.r-lib.org/reference/desc_bump_version.html).

## Usage

``` r
new_branch(name, bump_ver = TRUE, current = FALSE)
```

## Arguments

- name:

  name of the new branch.

- bump_ver:

  if `TRUE`, bump 'dev' version to 9000, see details.

- current:

  create new branch from the currently active branch (`TRUE`) or from
  the default branch (`FALSE`), see details.

## Details

The new branch will be created and checked out if it does not exist on
local or remote. If the version in DESCRIPTION has 3 components (a
release version) and `bump_ver` is `TRUE` (the default), the fourth
component, 'dev' will be bumped to 9000 and checked in to the new
branch.

If the version already has 4 components, it is not changed.

If `current = FALSE` (the default), the new branch will be created from
the default branch as determined by
[`usethis::git_default_branch()`](https://usethis.r-lib.org/reference/git-default-branch.html).
