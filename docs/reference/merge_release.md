# Merge staged GitHub release

Merge a pull request staged with
[`stage_release()`](https://jabenninghoff.github.io/rdev/reference/stage_release.md)
and create a new release on GitHub.

## Usage

``` r
merge_release(pkg = ".", filename = "NEWS.md", host = getOption("rdev.host"))
```

## Arguments

- pkg:

  path to package. Currently, only `pkg = "."` is supported.

- filename:

  name of file containing release notes, defaults to `NEWS.md`.

- host:

  GitHub host to target, passed to the `.api_url` argument of
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html). If unspecified,
  gh defaults to "https://api.github.com", although gh's default can be
  customised by setting the GITHUB_API_URL environment variable.

  For a hypothetical GitHub Enterprise instance, either
  "https://github.acme.com/api/v3" or "https://github.acme.com" is
  acceptable.

## Value

list containing results of pull request merge and GitHub release,
invisibly

## Details

Manually verify that all status checks have completed before running, as
`merge_release()` doesn't currently validate that status checks are
successful.

When run, `merge_release()`:

1.  Determines the staged release title from `NEWS.md` using
    [`get_release()`](https://jabenninghoff.github.io/rdev/reference/get_release.md)

2.  Selects the GitHub pull request that matches the staged release
    title, stops if there is more or less than one matching PR using
    [`gh::gh()`](https://gh.r-lib.org/reference/gh.html)

3.  Verifies the staged pull request is ready to be merged by checking
    the locked, draft, mergeable, and rebaseable flags

4.  Merges the pull request into the default branch using "Rebase and
    merge" using [`gh::gh()`](https://gh.r-lib.org/reference/gh.html)

5.  Deletes the pull request branch remotely and locally using
    [`gh::gh()`](https://gh.r-lib.org/reference/gh.html) and
    [`gert::git_branch_delete()`](https://docs.ropensci.org/gert/reference/git_branch.html)

6.  Updates the default branch with
    [`gert::git_pull()`](https://docs.ropensci.org/gert/reference/git_fetch.html)

7.  Adds the version tag to the `DESCRIPTION` commit with the message
    `"GitHub release <version>"` with
    [`gert::git_tag_create()`](https://docs.ropensci.org/gert/reference/git_tag.html)
    and pushes using
    [`gert::git_tag_push()`](https://docs.ropensci.org/gert/reference/git_tag.html)

8.  Create the GitHub release from the newly created tag, with the name
    `"<version>"` and the release notes in the body, using
    [`gh::gh()`](https://gh.r-lib.org/reference/gh.html)

## Host

Set the `rdev.host` option when using a GitHub Enterprise server:
`options(rdev.host = "https://github.example.com/api/v3")`
