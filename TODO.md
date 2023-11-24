# TODO

## Content

- [x] &nbsp;Add README.Rmd
- [x] &nbsp;Update `DESCRIPTION` and use description data in `README.Rmd`
- [x] &nbsp;Add ORCID

## Package

- [x] &nbsp;Write a utility function to sort `.Rbuildignore`
- [x] &nbsp;Implement [pkgdown](https://pkgdown.r-lib.org)
- [x] &nbsp;Add links / update [Rd formatting](https://roxygen2.r-lib.org/articles/rd-formatting.html) for all function documentation.
- [x] &nbsp;Add dummy imports to silence R CMD check note per [tidyverse](https://github.com/tidyverse/tidyverse/blob/master/R/tidyverse.R)
- [x] &nbsp;Migrate `build_analysis_site()` to rdev
- [x] &nbsp;Switch from development version of `styler` (1.3.2.9000) when a new release becomes available
- [x] &nbsp;~~Validate that `lint_all` works as expected within `ci`~~
- [x] &nbsp;Add 'create package' workflow example to README, remove TODO section "Analysis package creation process"
- [x] &nbsp;Move `_pkgdown.yml` to repository root to make projects discoverable by the [pgkdown](https://pkgdown.r-lib.org) GitHub [query](https://github.com/search?q=filename%3Apkgdown.yml+path%3A%2F&type=Code)
- [x] &nbsp;Update `README.Rmd` template to dynamically generate list of notebooks in `analysis`
- [x] &nbsp;Automate release process
- [x] &nbsp;Automate creation of feature branches, including 'Bump version' using `desc::desc_bump_version("dev")`
- [x] &nbsp;Add check to `stage_release()` to look for missing topics in `_pkgdown.yml` reference section
- [x] &nbsp;Update `use_rdev_package()`
- [x] &nbsp;Handle `.Rmd` files that already have an `html_document` section
- [x] &nbsp;Move `rmd_metadata()` from README-analysis.Rmd to rdev package
- [x] &nbsp;Add tests per comments in `R/` after reading package book, documentation
- [x] &nbsp;Update Roxygen comments after reading package book, documentation, review and merge duplicate Roxygen docs
- [x] &nbsp;Write a manual regression test script (notes with R commands) ~~as a vignette~~ to validate 'Creating Packages' ~~and 'GitHub Releases'~~
- [x] &nbsp;Add messages, warnings to `build_analysis_site()` to report on progress
- [x] &nbsp;Add function to spell check notebooks
- [x] &nbsp;Automate branch protection
- [x] &nbsp;Address issue <https://github.com/r-lib/usethis/issues/1568>, which has been closed
- [x] &nbsp;Add dplyr when running `use_analysis_package()`
- [x] &nbsp;~~Consider switching `getOption("pkgType")` from `source` to `both` per R [options](https://stat.ethz.ch/R-manual/R-devel/library/base/html/options.html)~~ per the [R macOS FAQ](https://cran.r-project.org/bin/macosx/RMacOSX-FAQ.html#What-is-the-difference-between-the-CRAN-build-and-a-vanilla-build_003f), "Only the CRAN build is guaranteed to be compatible with the package binaries on CRAN (or Bioconductor)."
- [x] &nbsp;Support creating repos in organizations
- [x] &nbsp;~~Consider incorporating the GitHub description into `DESCRIPTION`~~
- [x] &nbsp;Create a wrapper for `spelling` that includes notebooks in package spell checking, WORDLIST
- [x] &nbsp;Add a `spell_check_test_notebooks()` function for CI spellchecks on notebooks
- [x] &nbsp;Convert manual tests (`Setup.Rmd`) into an R Script that can be run from within the package created with `create_github_repo()`
- [x] &nbsp;Add a function to add missing (notebook) dependencies to DESCRIPTION, see `renv::dependencies()` and `desc::desc_get_deps()`
- [x] &nbsp;Add `check_renv()` to `ci()` and stop if `renv::status()` is not up to date
- [x] &nbsp;Replace proof-docs with [urlchecker](https://urlchecker.r-lib.org), support checking GitHub Pages `docs` directory using `url_db_from_HTML_files` ~~(ask if a PR for this would be accepted)~~
- [x] &nbsp;Move scripts from `tools` to `inst/bin` or similar, per [Stack Overflow](https://stackoverflow.com/questions/26104709/is-there-any-special-functionality-in-r-package-exec-or-tools-directories) and [R Packages](https://r-pkgs.org/inst.html#inst-other-langs)
- [x] &nbsp;Switch from development versions of `styler` (1.3.2.9000) and `lintr` (2.0.1.9000) when a new release becomes available - both were needed to address bugs in the current release versions, 1.3.2 and 2.0.1.
- [x] &nbsp;Add trailing slash to GitHub Pages URL
- [x] &nbsp;Update `lint_all()` to lint all types, including `.Rpres`
- [x] &nbsp;~~Add custom CSS files to [`_site.yml`](https://rmarkdown.rstudio.com/docs/reference/render_site.html) and analysis notebook templates to control font size, as described in this [article](https://medium.com/@HadrienD/how-to-customize-font-size-in-r-markdown-documents-f5adff36e2cc), or possibly using [`bs_theme()`](https://rstudio.github.io/bslib/articles/theming.html), since pkgdown customizes the default using [`build_bslib()`](https://github.com/r-lib/pkgdown/blob/main/R/theme.R)~~ (issue exists in unsupported Safari 14 but not Safari 15)
- [ ] &nbsp;Replace `dev = TRUE` logic if <https://github.com/rstudio/renv/issues/1695> is accepted
- [ ] &nbsp;Update errors and messages after reading Advanced R [Conditions](https://adv-r.hadley.nz/conditions.html) and re-reading the Tidyverse [Style Guide](https://style.tidyverse.org/index.html)
- [ ] &nbsp;Establish default [knitr options](https://yihui.org/knitr/options/), including `knitr::opts_chunk$set(fig.align = "center"")`, add to analysis template, also review [settings](https://github.com/hadley/adv-r/blob/master/common.R) for *Advanced R*
- [ ] &nbsp;Reduce the number of Imports, per R CMD check:

```
> checking package dependencies ... NOTE
  Imports includes 26 non-default packages.
  Importing from so many packages makes the package vulnerable to any of
  them becoming unavailable.  Move as many as possible to Suggests and
  use conditionally.
```

## GitHub

- [x] &nbsp;Set up [GitHub Actions](https://usethis.r-lib.org/reference/github_actions.html)
  - [x] &nbsp;Use [standard](https://github.com/r-lib/actions/blob/master/examples/check-standard.yaml) `R CMD check`
  - [x] &nbsp;Use [lintr](https://github.com/r-lib/actions/blob/master/examples/lint.yaml)
- [x] &nbsp;Faster CI checks
- [x] &nbsp;~~Switch to [full](https://github.com/r-lib/actions/blob/master/examples/check-full.yaml) `R CMD check` ?~~
- [x] &nbsp;Update GitHub Actions from r-lib [examples](https://github.com/r-lib/actions/tree/master/examples)
- [x] &nbsp;Run [test coverage](https://github.com/r-lib/actions/blob/master/examples/test-coverage.yaml)
- [x] &nbsp;~~Skip CI checks for changes in only the `docs/` directory~~
- [x] &nbsp;~~Add GitHub Action for html/link checking using something like [htmlproofer](https://github.com/gjtorikian/html-proofer)~~
- [x] &nbsp;~~Autobuild `docs/` like [pkgdown](https://github.com/r-lib/actions/blob/master/examples/pkgdown.yaml) ?~~
