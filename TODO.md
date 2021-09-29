# TODO

## Content

- [x] Add README.Rmd
- [x] Update `DESCRIPTION` and use description data in `README.Rmd`
- [x] Add ORCID

## Package

- [x] Write a utility function to sort `.Rbuildignore`
- [x] Implement [pkgdown](https://pkgdown.r-lib.org)
- [x] Add links / update [Rd formatting](https://roxygen2.r-lib.org/articles/rd-formatting.html) for all function documentation.
- [x] Add dummy imports to silence R CMD check note per [tidyverse](https://github.com/tidyverse/tidyverse/blob/master/R/tidyverse.R)
- [x] Migrate `build_analysis_site()` to rdev
- [ ] Add messages, warnings to `build_analysis_site()` to report on progress
- [ ] Update Roxygen comments after reading package book, documentation
- [ ] Add tests per comments in `R/` after reading package book, documentation
- [x] Switch from development version of `styler` (1.3.2.9000) when a new release becomes available
- [ ] Switch from development versions of `styler` (1.3.2.9000) and `lintr` (2.0.1.9000) when a new release becomes available - both were needed to address bugs in the current release versions, 1.3.2 and 2.0.1.
- [ ] Automate release process
- [ ] Handle `.Rmd` files that already have an `html_document` section
- [ ] Validate that `lint_all` works as expected within `ci`

## GitHub

- [x] Set up [GitHub Actions](https://usethis.r-lib.org/reference/github_actions.html)
  - [x] Use [standard](https://github.com/r-lib/actions/blob/master/examples/check-standard.yaml) `R CMD check`
  - [x] Use [lintr](https://github.com/r-lib/actions/blob/master/examples/lint.yaml)
- [x] Faster CI checks
- [ ] Skip CI checks for changes in only the `docs/` directory
- [ ] Run [test coverage](https://github.com/r-lib/actions/blob/master/examples/test-coverage.yaml)
- [ ] Add GitHub Action for html/link checking using something like [htmlproofer](https://github.com/gjtorikian/html-proofer)
- [ ] Switch to  [full](https://github.com/r-lib/actions/blob/master/examples/check-full.yaml) `R CMD check` ?
- [ ] Autobuild `docs/` like [pkgdown](https://github.com/r-lib/actions/blob/master/examples/pkgdown.yaml) ?

## Analysis package release process

Notes on manually releasing an analysis package for future automation.

Prior to release:

- Update release notes (`NEWS.md`) [TODO: verify and extract version and release notes using release script]
- Add new notebooks to `README.md` [TODO: generate list of files in `analysis` using R code]
- Merge all changes to `main`

Creating a release (0.7.1):

1. Create release branch
1. Update `Version` field in `DESCRIPTION` to `0.7.1`
1. Commit: `GitHub release 0.7.1`
1. Run build_analysis_site()
1. Commit: `build_analysis_site() for release 0.7.1`
1. Open Pull Request [TODO: include release notes]
1. Rebase and merge
1. Delete branch
1. Publish new GitHub release. Name: `0.7.1`, Title: `0.7.1`, Target commit: `build_analysis_site() for release 0.7.1`, Description: blank [TODO: use release notes]
