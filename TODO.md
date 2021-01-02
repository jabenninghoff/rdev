# TODO

## Content

- [x] Add README.Rmd
- [x] Update `DESCRIPTION` and use description data in `README.Rmd`
- [ ] Add ORCID

## Package

- [x] Write a utility function to sort `.Rbuildignore`
- [x] Implement [pkgdown](https://pkgdown.r-lib.org)
- [ ] Add tests for `check_renv()`, `ci()`, `sort_file()` ?
- [ ] Improved tests for `style_all()`, `lint_all()`

## GitHub

- [x] Set up [GitHub Actions](https://usethis.r-lib.org/reference/github_actions.html)
  - [x] Use [standard](https://github.com/r-lib/actions/blob/master/examples/check-standard.yaml) `R CMD check`
  - [x] Use [lintr](https://github.com/r-lib/actions/blob/master/examples/lint.yaml)
- [ ] Run [test coverage](https://github.com/r-lib/actions/blob/master/examples/test-coverage.yaml)
- [ ] Add GitHub Action for html/link checking using something like [htmlproofer](https://github.com/gjtorikian/html-proofer)
- [ ] Switch to  [full](https://github.com/r-lib/actions/blob/master/examples/check-full.yaml) `R CMD check` ?
- [ ] Autobuild `docs/` like [pkgdown](https://github.com/r-lib/actions/blob/master/examples/pkgdown.yaml) ?
