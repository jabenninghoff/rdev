# Create rdev GitHub repository

Create, configure, clone, and open a new GitHub R package repository
following rdev conventions.

## Usage

``` r
create_github_repo(
  repo_name,
  repo_desc = "",
  private = FALSE,
  org = NULL,
  host = getOption("rdev.host")
)
```

## Arguments

- repo_name:

  The name of the GitHub repository to create

- repo_desc:

  The description of the GitHub repository to create

- private:

  If `TRUE`, creates a private repository.

- org:

  The organization to create the repository in. If `NULL`, create the
  repository in the active user's account.

- host:

  GitHub host to target, passed to the `.api_url` argument of
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html). If unspecified,
  gh defaults to "https://api.github.com", although gh's default can be
  customised by setting the GITHUB_API_URL environment variable.

  For a hypothetical GitHub Enterprise instance, either
  "https://github.acme.com/api/v3" or "https://github.acme.com" is
  acceptable.

## Value

return value from [`gh::gh()`](https://gh.r-lib.org/reference/gh.html)
creating the repository, invisibly

## Details

When run, `create_github_repo()`:

1.  Creates a new GitHub repository using
    [`gh::gh()`](https://gh.r-lib.org/reference/gh.html) with license
    template from
    [`get_license()`](https://jabenninghoff.github.io/rdev/reference/get_license.md)

2.  Activates Dependabot alerts per
    `getOption("rdev.dependabot", default = TRUE)`

3.  Activates Dependabot security updates per
    `getOption("rdev.dependabot", default = TRUE)`

4.  Adds branch protection to the default branch (if `private` is
    `FALSE`)

5.  Clones the repository locally with
    [`usethis::create_from_github()`](https://usethis.r-lib.org/reference/create_from_github.html)

6.  Creates a basic package using
    [`usethis::create_package()`](https://usethis.r-lib.org/reference/create_package.html)

7.  If running interactively, the repository will automatically be
    opened in RStudio, GitHub Desktop, and the default browser

## GitHub Actions

GitHub Actions can be disabled by setting `rdev.github.actions` to
`FALSE`: `options(rdev.github.actions = FALSE)`

## Host

Set the `rdev.host` option when using a GitHub Enterprise server:
`options(rdev.host = "https://github.example.com/api/v3")`

## See also

[quickstart](https://jabenninghoff.github.io/rdev/reference/quickstart.md)
