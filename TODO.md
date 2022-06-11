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
- [x] Switch from development version of `styler` (1.3.2.9000) when a new release becomes available
- [x] ~~Validate that `lint_all` works as expected within `ci`~~
- [x] Add 'create package' workflow example to README, remove TODO section "Analysis package creation process"
- [x] Move `_pkgdown.yml` to repository root to make projects discoverable by the [pgkdown](https://pkgdown.r-lib.org) GitHub [query](https://github.com/search?q=filename%3Apkgdown.yml+path%3A%2F&type=Code)
- [x] Update `README.Rmd` template to dynamically generate list of notebooks in `analysis`
- [x] Automate release process
- [x] Automate creation of feature branches, including 'Bump version' using `desc::desc_bump_version("dev")`
- [x] Add check to `stage_release()` to look for missing topics in `_pkgdown.yml` reference section
- [x] Update `use_rdev_package()`
- [x] Handle `.Rmd` files that already have an `html_document` section
- [x] Move `rmd_metadata()` from README-analysis.Rmd to rdev package
- [x] Add tests per comments in `R/` after reading package book, documentation
- [x] Update Roxygen comments after reading package book, documentation, review and merge duplicate Roxygen docs
- [x] Write a manual regression test script (notes with R commands) ~~as a vignette~~ to validate 'Creating Packages' ~~and 'GitHub Releases'~~
- [x] Add messages, warnings to `build_analysis_site()` to report on progress
- [x] Add function to spell check notebooks
- [x] Automate branch protection
- [x] Address issue <https://github.com/r-lib/usethis/issues/1568>, which has been closed
- [x] Add dplyr when running `use_analysis_package()`
- [x] ~~Consider switching `getOption("pkgType")` from `source` to `both` per R [options](https://stat.ethz.ch/R-manual/R-devel/library/base/html/options.html)~~ per the [R macOS FAQ](https://cran.r-project.org/bin/macosx/RMacOSX-FAQ.html#What-is-the-difference-between-the-CRAN-build-and-a-vanilla-build_003f), "Only the CRAN build is guaranteed to be compatible with the package binaries on CRAN (or Bioconductor)."
- [x] Support creating repos in organizations
- [x] ~~Consider incorporating the GitHub description into `DESCRIPTION`~~
- [x] Create a wrapper for `spelling` that includes notebooks in package spell checking, WORDLIST
- [x] Add a `spell_check_test_notebooks()` function for CI spellchecks on notebooks
- [x] Convert manual tests (`Setup.Rmd`) into an R Script that can be run from within the package created with `create_github_repo()`
- [x] Add a function to add missing (notebook) dependencies to DESCRIPTION, see `renv::dependencies()` and `desc::desc_get_deps()`
- [x] Add `check_renv()` to `ci()` and stop if `renv::status()` is not up to date
- [ ] Switch from development versions of `styler` (1.3.2.9000) and `lintr` (2.0.1.9000) when a new release becomes available - both were needed to address bugs in the current release versions, 1.3.2 and 2.0.1.
- [ ] Move scripts from `tools` to `inst/bin` or similar, per [Stack Overflow](https://stackoverflow.com/questions/26104709/is-there-any-special-functionality-in-r-package-exec-or-tools-directories) and [R Packages](https://r-pkgs.org/inst.html#inst-other-langs)
- [ ] Replace proof-docs with [urlchecker](https://r-lib.github.io/urlchecker/), support checking GitHub Pages `docs` directory using `url_db_from_HTML_files` (ask if a PR for this would be accepted)

## GitHub

- [x] Set up [GitHub Actions](https://usethis.r-lib.org/reference/github_actions.html)
  - [x] Use [standard](https://github.com/r-lib/actions/blob/master/examples/check-standard.yaml) `R CMD check`
  - [x] Use [lintr](https://github.com/r-lib/actions/blob/master/examples/lint.yaml)
- [x] Faster CI checks
- [x] ~~Switch to [full](https://github.com/r-lib/actions/blob/master/examples/check-full.yaml) `R CMD check` ?~~
- [x] Update GitHub Actions from r-lib [examples](https://github.com/r-lib/actions/tree/master/examples)
- [x] Run [test coverage](https://github.com/r-lib/actions/blob/master/examples/test-coverage.yaml)
- [x] ~~Skip CI checks for changes in only the `docs/` directory~~
- [x] ~~Add GitHub Action for html/link checking using something like [htmlproofer](https://github.com/gjtorikian/html-proofer)~~
- [x] ~~Autobuild `docs/` like [pkgdown](https://github.com/r-lib/actions/blob/master/examples/pkgdown.yaml) ?~~
