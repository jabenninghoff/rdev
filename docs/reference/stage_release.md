# Stage a GitHub release

Open a GitHub pull request for a new release from `NEWS.md`. Approve,
merge, and create the release using
[`merge_release()`](https://jabenninghoff.github.io/rdev/reference/merge_release.md).

## Usage

``` r
stage_release(
  pkg = ".",
  filename = "NEWS.md",
  unfreeze = FALSE,
  host = getOption("rdev.host")
)
```

## Arguments

- pkg:

  path to package. Currently, only `pkg = "."` is supported.

- filename:

  name of file containing release notes, defaults to `NEWS.md`.

- unfreeze:

  If `TRUE`, delete the Quarto `_freeze` directory to fully re-render
  the site.

- host:

  GitHub host to target, passed to the `.api_url` argument of
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html). If unspecified,
  gh defaults to "https://api.github.com", although gh's default can be
  customised by setting the GITHUB_API_URL environment variable.

  For a hypothetical GitHub Enterprise instance, either
  "https://github.acme.com/api/v3" or "https://github.acme.com" is
  acceptable.

## Value

results of GitHub pull request, invisibly

## Details

When run, `stage_release()`:

1.  Extracts release version and release notes from `NEWS.md` using
    [`get_release()`](https://jabenninghoff.github.io/rdev/reference/get_release.md)

2.  Validates version conforms to rdev conventions (#.#.#) and release
    notes aren't empty

3.  Verifies that version tag doesn't already exist using
    [`gert::git_tag_list()`](https://docs.ropensci.org/gert/reference/git_tag.html)

4.  Checks for uncommitted changes and stops if any exist using
    [`gert::git_status()`](https://docs.ropensci.org/gert/reference/git_commit.html)

5.  Creates a new branch if on the default branch
    ([`gert::git_branch()`](https://docs.ropensci.org/gert/reference/git_branch.html)
    `==`
    [`usethis::git_default_branch()`](https://usethis.r-lib.org/reference/git-default-branch.html))
    using
    [`gert::git_branch_create()`](https://docs.ropensci.org/gert/reference/git_branch.html)

6.  Updates `Version` in `DESCRIPTION` with
    [`desc::desc_set_version()`](https://desc.r-lib.org/reference/desc_set_version.html),
    commits and push to git with message `"GitHub release <version>"`
    using
    [`gert::git_add()`](https://docs.ropensci.org/gert/reference/git_commit.html),
    [`gert::git_commit()`](https://docs.ropensci.org/gert/reference/git_commit.html)
    and
    [`gert::git_push()`](https://docs.ropensci.org/gert/reference/git_fetch.html)

7.  Runs
    [`build_quarto_site()`](https://jabenninghoff.github.io/rdev/reference/build_quarto_site.md)
    (if `_quarto.yml` exists),
    [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
    (if `pkgdown/_base.yml` exists) or
    [`build_rdev_site()`](https://jabenninghoff.github.io/rdev/reference/build_rdev_site.md)
    (if `_pkgdown.yml` exists), commits and pushes changes (if any) to
    git with message: `"<builder> for release <version>"`

8.  Opens a pull request with the title `"<package> <version>"` and the
    release notes in the body using
    [`gh::gh()`](https://gh.r-lib.org/reference/gh.html)

## Host

Set the `rdev.host` option when using a GitHub Enterprise server:
`options(rdev.host = "https://github.example.com/api/v3")`
